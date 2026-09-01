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
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/quick_switch_user_dialog.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';
import 'package:myhealth_ai/features/staff/patients/patient_chart_screen.dart';
import 'package:myhealth_ai/features/staff/schedule/doctor_schedule_screen.dart';
import 'package:myhealth_ai/services/clinical/appointment_triage_service.dart';

const List<String> _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

const List<String> _monthsLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// The clinician's day.
///
/// It answers two questions and nothing else: who is next, and is anyone in
/// trouble. Counts print in the masthead, unacknowledged critical flags run
/// as one ticker line, and the clinic list sorts urgent-first with a leading
/// stripe rather than a row of coloured badges.
class StaffDashboardScreen extends ConsumerStatefulWidget {
  const StaffDashboardScreen({super.key});

  @override
  ConsumerState<StaffDashboardScreen> createState() => _StaffDashboardScreenState();
}

class _StaffDashboardScreenState extends ConsumerState<StaffDashboardScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _setStatus(int appointmentId, AppointmentStatus status) async {
    await ref
        .read(appointmentRepositoryProvider)
        .updateAppointmentStatus(appointmentId, status);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final staff = ref.watch(currentUserProvider);
    if (staff == null) return const SizedBox.shrink();

    final profile = staff.staffProfile;
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    final appointmentsFuture = ref
        .watch(appointmentRepositoryProvider)
        .getAppointmentsForStaff(staff.id, date: _selectedDate);
    final flagsFuture = ref.watch(riskRepositoryProvider).getActiveRiskFlags();
    final tasksFuture = ref
        .watch(taskRepositoryProvider)
        .getTasksForStaff(staff.id, status: TaskStatus.pending);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Masthead ────────────────────────────────────────────
              FutureBuilder(
                future: appointmentsFuture,
                builder: (context, snapshot) {
                  final appts = snapshot.hasData
                      ? snapshot.data!.fold((l) => l, (_) => <Appointment>[])
                      : <Appointment>[];
                  final booked = appts
                      .where((a) =>
                          a.status == AppointmentStatus.booked ||
                          a.status == AppointmentStatus.confirmed)
                      .length;
                  final seen = appts
                      .where((a) => a.status == AppointmentStatus.completed)
                      .length;
                  final urgent = appts
                      .where((a) =>
                          AppointmentTriageService.classify(a.reasonText) ==
                          AppointmentUrgency.urgent)
                      .length;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Eyebrow(
                                  profile != null
                                      ? '${staff.fullName} · ${profile.jobTitle} · ${profile.licenseNo}'
                                      : staff.fullName,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_weekdays[_selectedDate.weekday - 1]} '
                                  '${_selectedDate.day} '
                                  '${_monthsLong[_selectedDate.month - 1]}',
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontSize: 30,
                                    letterSpacing: -1.0,
                                    height: 1.06,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const ThemeToggleButton(),
                          IconButton(
                            tooltip: 'Availability',
                            icon: const Icon(Icons.tune_rounded, size: 20),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const DoctorScheduleScreen(),
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Switch user',
                            icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (_) => const QuickSwitchUserDialog(),
                            ),
                          ),
                          IconButton(
                            tooltip: 'Sign out',
                            icon: const Icon(Icons.logout_rounded, size: 20),
                            onPressed: () =>
                                ref.read(authControllerProvider.notifier).logout(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: theme.colorScheme.onSurface, width: 3),
                            bottom: BorderSide(color: theme.colorScheme.onSurface),
                          ),
                        ),
                        child: Row(
                          children: [
                            _Count(value: '$booked', label: 'To see'),
                            _Count(value: '$seen', label: 'Seen'),
                            _Count(
                              value: '$urgent',
                              label: 'Urgent',
                              emphasis: urgent > 0,
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: _selectedDate,
                                      firstDate: DateTime.now()
                                          .subtract(const Duration(days: 90)),
                                      lastDate:
                                          DateTime.now().add(const Duration(days: 90)),
                                    );
                                    if (picked != null) {
                                      setState(() => _selectedDate = picked);
                                    }
                                  },
                                  icon: const Icon(Icons.calendar_today_rounded, size: 16),
                                  label: const Text('Another day'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // ── Critical flags ──────────────────────────────────────
              FutureBuilder(
                future: flagsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox.shrink();
                  final flags = snapshot.data!
                      .fold((l) => l, (_) => <RiskFlagItem>[])
                      .where((f) =>
                          f.severity == RiskSeverity.critical &&
                          f.acknowledgedAt == null)
                      .toList();
                  if (flags.isEmpty) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      color: theme.brightness == Brightness.dark
                          ? AppColors.accent2900
                          : AppColors.accent2100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const ClinicalBadge(
                                label: 'Unacknowledged',
                                tone: ClinicalTone.critical,
                                pulsing: true,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                '${flags.length} critical '
                                '${flags.length == 1 ? 'flag' : 'flags'}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          for (final flag in flags.take(3))
                            Padding(
                              padding: const EdgeInsets.only(bottom: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${flag.patientName ?? 'Patient #${flag.patientId}'} — '
                                      '${flag.rationale}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        height: 1.45,
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    formatTime24h(flag.detectedAt),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () async {
                                for (final flag in flags) {
                                  await ref
                                      .read(riskRepositoryProvider)
                                      .acknowledgeRiskFlag(flag.id, staff.id);
                                }
                                if (mounted) setState(() {});
                              },
                              child: const Text('Acknowledge all'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Clinic list and tasks ───────────────────────────────
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _ClinicList(
                        future: appointmentsFuture,
                        onSetStatus: _setStatus,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xxxl),
                    Expanded(flex: 2, child: _TaskColumn(future: tasksFuture)),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ClinicList(future: appointmentsFuture, onSetStatus: _setStatus),
                    const SizedBox(height: AppSpacing.xxl),
                    _TaskColumn(future: tasksFuture),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Count extends StatelessWidget {
  const _Count({required this.value, required this.label, this.emphasis = false});

  final String value;
  final String label;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontSize: 26,
              height: 1.0,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: emphasis
                  ? (theme.brightness == Brightness.dark
                      ? AppColors.accent2300
                      : AppColors.accent2700)
                  : theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 3),
          Eyebrow(label),
        ],
      ),
    );
  }
}

class _ClinicList extends StatelessWidget {
  const _ClinicList({required this.future, required this.onSetStatus});

  final Future<dynamic> future;
  final Future<void> Function(int, AppointmentStatus) onSetStatus;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHead(title: 'Clinic list'),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < 4; i++)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: SkeletalShimmer(width: double.infinity, height: 72),
                ),
            ],
          );
        }

        final appts = snapshot.data!.fold((l) => l, (_) => <Appointment>[]);

        if (appts.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.event_available_outlined,
            title: 'Clear day',
            description: 'No appointments are scheduled for this date.',
          );
        }

        // Clinically urgent patients surface first regardless of slot time.
        final sorted = [...appts]..sort((a, b) {
          final byUrgency = AppointmentTriageService.classify(b.reasonText)
              .index
              .compareTo(AppointmentTriageService.classify(a.reasonText).index);
          if (byUrgency != 0) return byUrgency;
          return a.slotStart.compareTo(b.slotStart);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(title: 'Clinic list — urgent first, then by time'),
            for (var i = 0; i < sorted.length; i++)
              StaggeredFadeSlide(
                index: i,
                child: _AppointmentRow(
                  appointment: sorted[i],
                  onSetStatus: onSetStatus,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AppointmentRow extends StatelessWidget {
  const _AppointmentRow({required this.appointment, required this.onSetStatus});

  final Appointment appointment;
  final Future<void> Function(int, AppointmentStatus) onSetStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final urgency = AppointmentTriageService.classify(appointment.reasonText);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PatientChartScreen(patientId: appointment.patientId),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 3, height: 52, color: urgency.accentColor),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 52,
                  child: Text(
                    formatTime24h(appointment.slotStart),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              appointment.patientName ??
                                  'Patient #${appointment.patientId}',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (urgency != AppointmentUrgency.routine)
                            ClinicalBadge(
                              label: urgency.label,
                              tone: urgency.tone,
                              pulsing: urgency == AppointmentUrgency.urgent,
                            ),
                          const SizedBox(width: AppSpacing.xs),
                          ClinicalBadge.appointmentStatus(appointment.status),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        appointment.reasonText.isNotEmpty
                            ? appointment.reasonText
                            : 'Routine consultation',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                      ),
                      if (appointment.noShowRisk != null &&
                          appointment.riskBand == RiskBand.high) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Missed ${(appointment.noShowRisk! * 100).toStringAsFixed(1)}% '
                          'likely — confirm by phone',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          if (appointment.status == AppointmentStatus.booked ||
                              appointment.status == AppointmentStatus.confirmed) ...[
                            OutlinedButton(
                              onPressed: () => onSetStatus(
                                appointment.id,
                                AppointmentStatus.checkedIn,
                              ),
                              child: const Text('Check in'),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            TextButton(
                              onPressed: () => onSetStatus(
                                appointment.id,
                                AppointmentStatus.noShow,
                              ),
                              child: const Text('No-show'),
                            ),
                          ] else if (appointment.status ==
                              AppointmentStatus.checkedIn)
                            ElevatedButton(
                              onPressed: () => onSetStatus(
                                appointment.id,
                                AppointmentStatus.completed,
                              ),
                              child: const Text('Mark seen'),
                            )
                          else
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => PatientChartScreen(
                                    patientId: appointment.patientId,
                                  ),
                                ),
                              ),
                              child: const Text('Open chart'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const RowRule(),
        ],
      ),
    );
  }
}

class _TaskColumn extends StatelessWidget {
  const _TaskColumn({required this.future});

  final Future<dynamic> future;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        final tasks = snapshot.hasData
            ? snapshot.data!.fold((l) => l, (_) => <StaffTaskItem>[])
            : <StaffTaskItem>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHead(title: 'Waiting on you'),
            if (!snapshot.hasData)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.md),
                child: SkeletalShimmer(width: double.infinity, height: 64),
              )
            else if (tasks.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Text('Nothing outstanding.', style: theme.textTheme.bodyMedium),
              )
            else
              for (final task in (tasks
                  ..sort((a, b) => b.blendedPriority.compareTo(a.blendedPriority))))
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            task.patientName != null
                                ? '${task.patientName} · due ${formatClinicalDate(task.dueAt)}'
                                : 'Due ${formatClinicalDate(task.dueAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                          if (task.aiRationale != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.aiRationale!,
                              style: theme.textTheme.labelSmall?.copyWith(height: 1.45),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const RowRule(),
                  ],
                ),
          ],
        );
      },
    );
  }
}
