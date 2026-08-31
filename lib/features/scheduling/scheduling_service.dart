library;

import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/failures.dart';
import 'package:myhealth_ai/core/result.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/services/ml/feature_extractor.dart';
import 'package:myhealth_ai/services/ml/no_show_predictor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Candidate appointment slot with ML-predicted risk scoring.
class ScoredSlot {
  const ScoredSlot({
    required this.slotStart,
    required this.slotEnd,
    required this.doctorId,
    required this.doctorName,
    required this.departmentName,
    required this.prediction,
  });

  final DateTime slotStart;
  final DateTime slotEnd;
  final int doctorId;
  final String doctorName;
  final String departmentName;
  final NoShowPrediction prediction;
}

/// Smart Scheduling Service coordinating slot availability, ML risk scoring,
/// and multi-tier reminder generation (RQ2).
class SchedulingService {
  SchedulingService(this.ref);

  final Ref ref;

  /// Generates available slot candidates for a given doctor and date range,
  /// then scores each slot using NoShowPredictor and sorts by risk (lowest first).
  Future<Result<List<ScoredSlot>, AppFailure>> getScoredSlots({
    required User patient,
    required int doctorId,
    required String doctorName,
    required String departmentName,
    required DateTime dateFrom,
    required DateTime dateTo,
    required int activeMedCount,
    required DateTime? lastVisitDate,
  }) async {
    try {
      final predictor = await NoShowPredictor.load();
      final apptRepo = ref.read(appointmentRepositoryProvider);

      // Get existing booked appointments for the doctor in the date range
      final existingResult = await apptRepo.getAppointmentsForDoctor(
        doctorId,
      );
      final existingSlots = existingResult.fold(
        (list) => list.map((a) => a.slotStart).toSet(),
        (_) => <DateTime>{},
      );

      // Get prior no-show and completed counts for the patient
      final historyResult = await apptRepo.getAppointmentsForPatient(patient.id);
      final history = historyResult.fold((l) => l, (_) => <Appointment>[]);
      final priorNoShows = history.where((a) => a.status == AppointmentStatus.noShow).length;
      final priorCompleted = history.where((a) => a.status == AppointmentStatus.completed).length;

      // Generate candidate 30-minute slots from 8:00 to 16:00
      final candidates = <ScoredSlot>[];
      var day = DateTime(dateFrom.year, dateFrom.month, dateFrom.day);
      final endDay = DateTime(dateTo.year, dateTo.month, dateTo.day);

      while (!day.isAfter(endDay)) {
        // Skip Fridays and Saturdays (Bahrain weekend)
        if (day.weekday != DateTime.friday && day.weekday != DateTime.saturday) {
          for (int hour = 8; hour < 16; hour++) {
            for (int minute = 0; minute < 60; minute += 30) {
              final slotStart = DateTime(day.year, day.month, day.day, hour, minute);
              final slotEnd = slotStart.add(const Duration(minutes: 30));

              // Skip past slots
              if (slotStart.isBefore(DateTime.now())) continue;

              // Skip booked slots
              if (existingSlots.contains(slotStart)) continue;

              final features = FeatureExtractor.extract(
                patient: patient,
                proposedSlotStart: slotStart,
                bookingDate: DateTime.now(),
                priorNoShows: priorNoShows,
                priorCompleted: priorCompleted,
                activeMedicationCount: activeMedCount,
                lastVisitDate: lastVisitDate,
              );

              final prediction = predictor.predict(features);

              candidates.add(ScoredSlot(
                slotStart: slotStart,
                slotEnd: slotEnd,
                doctorId: doctorId,
                doctorName: doctorName,
                departmentName: departmentName,
                prediction: prediction,
              ));
            }
          }
        }
        day = day.add(const Duration(days: 1));
      }

      // Sort by lowest risk first (best slots at top)
      candidates.sort((a, b) => a.prediction.probability.compareTo(b.prediction.probability));

      return Success(candidates);
    } catch (e) {
      return Failure(GeneralFailure(message: 'Scheduling error: $e'));
    }
  }

  /// Generates multi-tier reminders based on the predicted risk band.
  ///
  /// - Low Risk:   1 reminder (24h before)
  /// - Medium Risk: 2 reminders (48h and 24h before)
  /// - High Risk:   3 reminders (7 days, 48h, and morning-of with phone flag)
  List<ReminderSpec> generateReminders({
    required DateTime slotStart,
    required RiskBand riskBand,
    required int appointmentId,
    required int patientId,
  }) {
    final reminders = <ReminderSpec>[];

    switch (riskBand) {
      case RiskBand.low:
        reminders.add(ReminderSpec(
          appointmentId: appointmentId,
          patientId: patientId,
          scheduledAt: slotStart.subtract(const Duration(hours: 24)),
          channel: 'notification',
          message: 'Reminder: You have an appointment tomorrow.',
        ));
        break;

      case RiskBand.medium:
        reminders.addAll([
          ReminderSpec(
            appointmentId: appointmentId,
            patientId: patientId,
            scheduledAt: slotStart.subtract(const Duration(hours: 48)),
            channel: 'notification',
            message: 'Reminder: Your appointment is in 2 days. Please confirm attendance.',
          ),
          ReminderSpec(
            appointmentId: appointmentId,
            patientId: patientId,
            scheduledAt: slotStart.subtract(const Duration(hours: 24)),
            channel: 'notification',
            message: 'Reminder: You have an appointment tomorrow.',
          ),
        ]);
        break;

      case RiskBand.high:
        reminders.addAll([
          ReminderSpec(
            appointmentId: appointmentId,
            patientId: patientId,
            scheduledAt: slotStart.subtract(const Duration(days: 7)),
            channel: 'notification',
            message: 'Upcoming: Your appointment is next week. Please plan ahead.',
          ),
          ReminderSpec(
            appointmentId: appointmentId,
            patientId: patientId,
            scheduledAt: slotStart.subtract(const Duration(hours: 48)),
            channel: 'notification',
            message: 'Important: Your appointment is in 2 days. Please confirm.',
          ),
          ReminderSpec(
            appointmentId: appointmentId,
            patientId: patientId,
            scheduledAt: DateTime(slotStart.year, slotStart.month, slotStart.day, 7, 0),
            channel: 'phone_confirmation',
            message: 'URGENT: Your appointment is TODAY. Phone confirmation requested.',
          ),
        ]);
        break;
    }

    return reminders;
  }
}

/// Lightweight reminder specification for insertion into the database.
class ReminderSpec {
  const ReminderSpec({
    required this.appointmentId,
    required this.patientId,
    required this.scheduledAt,
    required this.channel,
    required this.message,
  });

  final int appointmentId;
  final int patientId;
  final DateTime scheduledAt;
  final String channel;
  final String message;
}

/// Riverpod provider for SchedulingService.
final schedulingServiceProvider = Provider<SchedulingService>((ref) {
  return SchedulingService(ref);
});
