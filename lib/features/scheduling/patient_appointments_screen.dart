library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/scheduling/booking_wizard_screen.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class PatientAppointmentsScreen extends ConsumerWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final apptFuture = ref.watch(appointmentRepositoryProvider).getAppointmentsForPatient(user.id);

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

            // Separate upcoming and past
            final now = DateTime.now();
            final upcoming = appointments.where((a) =>
                a.slotStart.isAfter(now) && a.status == AppointmentStatus.booked).toList();
            final past = appointments.where((a) =>
                a.slotStart.isBefore(now) || a.status != AppointmentStatus.booked).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (upcoming.isNotEmpty) ...[
                    Text(
                      'Upcoming',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...upcoming.map((a) => _AppointmentCard(
                      appointment: a,
                      isUpcoming: true,
                      onCancel: () => _cancelAppointment(context, ref, a),
                    )),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                  if (past.isNotEmpty) ...[
                    Text(
                      'Past & Cancelled',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...past.take(10).map((a) => _AppointmentCard(
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
            child: const Text('Cancel It', style: TextStyle(color: AppColors.critical)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: DoubleBezelCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClinicalBadge.appointmentStatus(appointment.status),
                const Spacer(),
                if (appointment.riskBand != null) ClinicalBadge.riskBand(appointment.riskBand!),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              appointment.doctorName ?? 'Consultant Physician',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 2),
            Text(
              '${formatClinicalDate(appointment.slotStart)} at ${formatTime24h(appointment.slotStart)}',
              style: const TextStyle(color: AppColors.primaryTeal, fontWeight: FontWeight.w600, fontSize: 13),
            ),
            if (appointment.reasonText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Reason: ${appointment.reasonText}',
                style: TextStyle(color: context.textSecondary, fontSize: 12),
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
                    icon: const Icon(Icons.edit_calendar_rounded, size: 16, color: AppColors.primaryTeal),
                    label: const Text('Reschedule', style: TextStyle(color: AppColors.primaryTeal, fontSize: 12)),
                  ),
                  const SizedBox(width: 8),
                  if (onCancel != null)
                    TextButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.cancel_outlined, size: 16, color: AppColors.critical),
                      label: const Text('Cancel', style: TextStyle(color: AppColors.critical, fontSize: 12)),
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
