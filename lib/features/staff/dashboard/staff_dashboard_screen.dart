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
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/staff/patients/patient_chart_screen.dart';
import 'package:myhealth_ai/features/staff/schedule/doctor_schedule_screen.dart';

class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _updateStatus(int appointmentId, AppointmentStatus status) async {
    await ref.read(appointmentRepositoryProvider).updateAppointmentStatus(appointmentId, status);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(currentUserProvider);
    if (staff == null) return const SizedBox.shrink();

    final appointmentsFuture = ref.watch(appointmentRepositoryProvider).getAppointmentsForStaff(
          staff.id,
          date: _selectedDate,
        );

    final riskFlagsFuture = ref.watch(riskRepositoryProvider).getActiveRiskFlags();

    return Scaffold(
      appBar: AppBar(
        title: Text(staff.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Schedule Availability Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DoctorScheduleScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            tooltip: 'Quick Switch User (Defense Demo)',
            onPressed: () => showDialog(context: context, builder: (_) => const QuickSwitchUserDialog()),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
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
              const SafetyBanner(),
              const SizedBox(height: AppSpacing.md),

              // Active Critical Flags Ticker
              FutureBuilder(
                future: riskFlagsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final flags = snapshot.data!.fold((l) => l, (_) => <RiskFlagItem>[])
                      .where((f) => f.severity == RiskSeverity.critical && f.acknowledgedAt == null)
                      .toList();

                  if (flags.isEmpty) return const SizedBox.shrink();

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.critical.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.critical.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.emergency_rounded, color: AppColors.critical),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '⚠️ ${flags.length} Critical Clinical Risk Flag(s) requiring immediate attention!',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.critical, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Date Selection Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Schedule',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatClinicalDate(_selectedDate),
                        style: TextStyle(color: context.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 90)),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (picked != null) setState(() => _selectedDate = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Appointments List
              FutureBuilder(
                future: appointmentsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.sm),
                        child: SkeletalShimmer(width: double.infinity, height: 100),
                      ),
                    );
                  }

                  final appointments = snapshot.data!.fold((l) => l, (_) => <Appointment>[]);

                  if (appointments.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.event_available_rounded,
                      title: 'No Appointments Scheduled',
                      description: 'No patient appointments scheduled for this date.',
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appt = appointments[index];

                      return StaggeredFadeSlide(
                        index: index,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: DoubleBezelCard(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PatientChartScreen(patientId: appt.patientId),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${formatTime24h(appt.slotStart)} – ${formatTime24h(appt.slotEnd)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryTeal),
                                    ),
                                    const Spacer(),
                                    ClinicalBadge.appointmentStatus(appt.status),
                                    if (appt.riskBand != null) ...[
                                      const SizedBox(width: 6),
                                      ClinicalBadge.riskBand(appt.riskBand!),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundColor: AppColors.primaryTeal.withValues(alpha: 0.15),
                                      child: Text(
                                        (appt.patientName ?? "P")[0],
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryTeal),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appt.patientName ?? 'Patient #${appt.patientId}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                          ),
                                          Text(
                                            appt.reasonText.isNotEmpty ? appt.reasonText : 'Routine consultation',
                                            style: TextStyle(color: context.textSecondary, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (appt.status == AppointmentStatus.booked) ...[
                                      TextButton(
                                        onPressed: () => _updateStatus(appt.id, AppointmentStatus.checkedIn),
                                        child: const Text('Check In', style: TextStyle(fontSize: 12)),
                                      ),
                                      const SizedBox(width: 6),
                                      TextButton(
                                        onPressed: () => _updateStatus(appt.id, AppointmentStatus.noShow),
                                        child: const Text('No-Show', style: TextStyle(color: AppColors.critical, fontSize: 12)),
                                      ),
                                      const SizedBox(width: 6),
                                    ],
                                    if (appt.status == AppointmentStatus.checkedIn) ...[
                                      ElevatedButton.icon(
                                        onPressed: () => _updateStatus(appt.id, AppointmentStatus.completed),
                                        icon: const Icon(Icons.check_rounded, size: 16),
                                        label: const Text('Complete', style: TextStyle(fontSize: 12)),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
