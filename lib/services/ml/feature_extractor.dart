library;

import 'package:myhealth_ai/domain/entities/models.dart';

/// Extracts the 11-element feature vector from patient profile and appointment context (RQ2).
abstract final class FeatureExtractor {
  /// Computes [List<double>] of length 11 matching the ML model's feature schema.
  static List<double> extract({
    required User patient,
    required DateTime proposedSlotStart,
    required DateTime bookingDate,
    required int priorNoShows,
    required int priorCompleted,
    required int activeMedicationCount,
    required DateTime? lastVisitDate,
  }) {
    final leadTimeDays = proposedSlotStart.difference(bookingDate).inDays.clamp(0, 90).toDouble();
    final age = patient.age.toDouble();
    final noShowRatio = priorNoShows / (priorNoShows + priorCompleted + 1.0);

    final hasChronicCondition = (patient.patientProfile != null &&
            patient.patientProfile!.chronicConditions.isNotEmpty)
        ? 1.0
        : 0.0;

    final numMeds = activeMedicationCount.toDouble();
    final hour = proposedSlotStart.hour.toDouble();
    final isMorning = hour < 12.0 ? 1.0 : 0.0;

    // Bahrain work week: Sunday(7)–Thursday(4). Weekend-adjacent = Thursday(4) or Sunday(7)
    final weekday = proposedSlotStart.weekday; // 1=Mon ... 7=Sun
    final isWeekendAdjacent = (weekday == DateTime.thursday || weekday == DateTime.sunday) ? 1.0 : 0.0;

    final daysSinceLastVisit = lastVisitDate != null
        ? bookingDate.difference(lastVisitDate).inDays.clamp(0, 365).toDouble()
        : 365.0;

    return [
      leadTimeDays,           // f0
      age,                    // f1
      priorNoShows.toDouble(),// f2
      priorCompleted.toDouble(),// f3
      noShowRatio,            // f4
      hasChronicCondition,    // f5
      numMeds,                // f6
      isMorning,              // f7
      isWeekendAdjacent,      // f8
      daysSinceLastVisit,     // f9
      hour,                   // f10
    ];
  }
}
