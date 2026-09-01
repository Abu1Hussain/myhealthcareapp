library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/scheduling/booking_wizard_screen.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/urgency_legend.dart';
import 'package:myhealth_ai/services/clinical/appointment_triage_service.dart';

class PatientAppointmentsScreen extends ConsumerWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final managedDependent = ref.watch(managedDependentProvider);
    final patientId = effectivePatientId(ref, user);
    final apptFuture = ref.watch(appointmentRepositoryProvider).getAppointmentsForPatient(patientId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Appointments'),
        actions: [
          IconButton(
            tooltip: 'Book New Appointment',
            icon: const Icon(Icons.add_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const BookingWizardScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: apptFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.pagePadding),
                itemCount: 4,
                itemBuilder: (_, __) => const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: SkeletalShimmer(width: double.infinity, height: 100),
                ),
              );
            }

            final appointments = snapshot.data!.fold(
              (l) => l,
              (r) => <Appointment>[],
            );

            if (appointments.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.event_available_rounded,
                title: 'No Appointments',
                description: 'Book your first appointment to get started.',
                actionLabel: 'Book Appointment',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const BookingWizardScreen()),
                  );
                },
              );
            }

            final now = DateTime.now();
            final upcoming = appointments.where((a) =>
                a.slotStart.isAfter(now) && a.status == AppointmentStatus.booked).toList()
              ..sort((a, b) => a.slotStart.compareTo(b.slotStart));
            final past = appointments.where((a) =>
                a.slotStart.isBefore(now) || a.status != AppointmentStatus.booked).toList()
              ..sort((a, b) => b.slotStart.compareTo(a.slotStart));

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (managedDependent != null) ...[
                    const ManagingDependentBanner(),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                  const UrgencyLegend(),
                  const SizedBox(height: AppSpacing.lg),
                  if (upcoming.isNotEmpty) ...[
                    SectionHead(
                      title: 'Upcoming',
                      trailing: Text(
                        '${upcoming.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...upcoming.map((a) => _AppointmentCard(
                      appointment: a,
                      isUpcoming: true,
                      onCancel: () => _cancelAppointment(context, ref, a),
                    )),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  if (past.isNotEmpty) ...[
                    SectionHead(
                      title: 'Past & Cancelled',
                      trailing: Text(
                        '${past.length}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...past.take(15).map((a) => _AppointmentCard(
                      appointment: a,
                      isUpcoming: false,
                    )),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _cancelAppointment(BuildContext context, WidgetRef ref, Appointment appointment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Appointment?'),
        content: Text('Cancel your appointment on ${formatClinicalDate(appointment.slotStart)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Keep')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cancel It', style: TextStyle(color: AppColors.magentaInk)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(appointmentRepositoryProvider).cancelAppointment(appointment.id);
    }
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.isUpcoming,
    this.onCancel,
  });

  final Appointment appointment;
  final bool isUpcoming;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgency = AppointmentTriageService.classify(appointment.reasonText);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DoubleBezelCard(
        accentColor: urgency.accentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ClinicalBadge(
                  label: urgency.label,
                  tone: urgency.tone,
                  icon: urgency.icon,
                  pulsing: urgency == AppointmentUrgency.urgent,
                ),
                ClinicalBadge.appointmentStatus(appointment.status),
                if (appointment.riskBand != null) ClinicalBadge.riskBand(appointment.riskBand!),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              appointment.doctorName ?? 'Consultant Physician',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${formatClinicalDate(appointment.slotStart)} at ${formatTime24h(appointment.slotStart)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark ? AppColors.accent300 : AppColors.accent700,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            if (appointment.reasonText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Reason: ${appointment.reasonText}',
                style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
            if (isUpcoming) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const BookingWizardScreen()),
                      );
                    },
                    icon: const Icon(Icons.edit_calendar_outlined, size: 16),
                    label: const Text('Reschedule', style: TextStyle(fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  if (onCancel != null)
                    TextButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.magentaInk),
                      label: const Text('Cancel', style: TextStyle(color: AppColors.magentaInk, fontSize: 12)),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
