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
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/patient_home/patient_shell.dart';
import 'package:myhealth_ai/features/patient_home/widgets/ai_summary_card.dart';
import 'package:myhealth_ai/features/records/import_record_modal.dart';
import 'package:myhealth_ai/features/scheduling/booking_wizard_screen.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';
import 'package:myhealth_ai/features/vitals/log_vitals_modal.dart';

class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final managedDependent = ref.watch(managedDependentProvider);
    final displayedUser = managedDependent ?? user;
    final patientId = effectivePatientId(ref, user);

    final apptFuture = ref.watch(appointmentRepositoryProvider).getAppointmentsForPatient(patientId);
    final medsFuture = ref.watch(vitalsRepositoryProvider).getMedicationsForPatient(patientId, activeOnly: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          managedDependent != null
              ? "${displayedUser.fullName.split(' ').first}'s Health"
              : 'Welcome, ${displayedUser.fullName.split(' ').first}',
        ),
        actions: [
          const ThemeToggleButton(),
          IconButton(
            tooltip: 'Quick Switch Account (Demo)',
            icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryTeal),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const QuickSwitchUserDialog(),
              );
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => ref.read(authControllerProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Safety Disclaimer Banner
              const StaggeredFadeSlide(
                index: 0,
                child: SafetyBanner(),
              ),
              const SizedBox(height: AppSpacing.lg),

              if (managedDependent != null) ...[
                const ManagingDependentBanner(),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Patient CPR & Profile Header Card
              StaggeredFadeSlide(
                index: 1,
                child: DoubleBezelCard(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                        child: Text(
                          displayedUser.fullName[0],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayedUser.fullName,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'CPR: ${displayedUser.nationalId} • Age ${displayedUser.age} • ${displayedUser.gender == 'M' ? 'Male' : 'Female'}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      if (displayedUser.patientProfile != null) ...[
                        ClinicalBadge(
                          label: displayedUser.patientProfile!.bloodType,
                          backgroundColor: AppColors.primaryTealSurface,
                          textColor: AppColors.primaryTeal,
                          icon: Icons.bloodtype_outlined,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Quick Actions Bar
              StaggeredFadeSlide(
                index: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.calendar_month_rounded,
                        label: 'Book Appt',
                        color: AppColors.info,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const BookingWizardScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.upload_file_rounded,
                        label: 'Import PDF',
                        color: AppColors.warning,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => ImportRecordModal(patientId: patientId),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.add_chart_rounded,
                        label: 'Log Vitals',
                        color: AppColors.primaryTeal,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => LogVitalsModal(patientId: patientId),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: _QuickActionButton(
                        icon: Icons.timeline_rounded,
                        label: 'Timeline',
                        color: AppColors.aiAccent,
                        onTap: () => ref.read(patientNavIndexProvider.notifier).state = 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // AI Health Summary Teaser Card (RQ1)
              const StaggeredFadeSlide(
                index: 3,
                child: AiSummaryCard(),
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Upcoming Appointment Card Section
              Text(
                'Next Appointment',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: AppSpacing.md),

              FutureBuilder(
                future: apptFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SkeletalShimmer(width: double.infinity, height: 120);
                  }

                  final appts = snapshot.data!.fold((l) => l, (r) => <Appointment>[]);
                  final upcoming = appts.where((a) => a.status == AppointmentStatus.booked).toList();

                  if (upcoming.isEmpty) {
                    return DoubleBezelCard(
                      child: Row(
                        children: [
                          Icon(Icons.event_available_rounded, size: 36, color: context.textTertiary),
                          const SizedBox(width: AppSpacing.md),
                          const Expanded(
                            child: Text('No upcoming appointments scheduled.'),
                          ),
                          ElevatedButton(
                            onPressed: () => ref.read(patientNavIndexProvider.notifier).state = 1,
                            child: const Text('Book'),
                          ),
                        ],
                      ),
                    );
                  }

                  final next = upcoming.first;

                  return DoubleBezelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClinicalBadge.appointmentStatus(next.status),
                            const Spacer(),
                            if (next.riskBand != null) ClinicalBadge.riskBand(next.riskBand!),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          next.doctorName ?? 'Consultant Physician',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatClinicalDate(next.slotStart)} at ${formatTime24h(next.slotStart)}',
                          style: const TextStyle(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Reason: ${next.reasonText}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Active Medications Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Active Prescriptions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  TextButton(
                    onPressed: () => ref.read(patientNavIndexProvider.notifier).state = 3,
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),

              FutureBuilder(
                future: medsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const SkeletalShimmer(width: double.infinity, height: 80);
                  }

                  final meds = snapshot.data!.fold((l) => l, (r) => <Medication>[]);

                  if (meds.isEmpty) {
                    return const DoubleBezelCard(
                      child: Text('No active prescriptions on record.'),
                    );
                  }

                  return Column(
                    children: meds.take(3).map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: DoubleBezelCard(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryTealSurface,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.medication_rounded, color: AppColors.primaryTeal, size: 20),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${m.name} ${m.dose}',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                    ),
                                    Text(
                                      m.frequency,
                                      style: TextStyle(color: context.textSecondary, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DoubleBezelCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
