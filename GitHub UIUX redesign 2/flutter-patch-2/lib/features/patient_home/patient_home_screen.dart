library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/di.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_screen.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/medications/medications_screen.dart';
import 'package:myhealth_ai/features/patient_home/patient_shell.dart';
import 'package:myhealth_ai/features/records/import_record_modal.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/shared/theme_toggle_button.dart';
import 'package:myhealth_ai/features/vitals/log_vitals_modal.dart';
import 'package:myhealth_ai/features/vitals/vitals_screen.dart';

const List<String> _weekdays = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
];

const List<String> _monthsLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

const List<String> _monthsShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Today — what the patient needs to act on before anything else.
///
/// The previous Home screen opened with a four-button quick-action bar, a
/// profile card and an AI teaser before the appointment. This one leads with
/// the appointment, then the single most notable clinical figure, then the
/// day's medicine times.
class PatientHomeScreen extends ConsumerWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final managedDependent = ref.watch(managedDependentProvider);
    final displayed = managedDependent ?? user;
    final patientId = effectivePatientId(ref, user);
    final now = DateTime.now();

    final apptFuture =
        ref.watch(appointmentRepositoryProvider).getAppointmentsForPatient(patientId);
    final medsFuture = ref
        .watch(vitalsRepositoryProvider)
        .getMedicationsForPatient(patientId, activeOnly: true);

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
              StaggeredFadeSlide(
                index: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Eyebrow(
                            '${_weekdays[now.weekday - 1]}, ${now.day} ${_monthsLong[now.month - 1]}',
                            accent: true,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            managedDependent != null
                                ? "${displayed.fullName.split(' ').first}'s record"
                                : 'Good morning,\n${displayed.fullName.split(' ').first}',
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontSize: 34,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -1.1,
                              height: 1.05,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ThemeToggleButton(),
                    IconButton(
                      tooltip: 'Sign out',
                      icon: const Icon(Icons.logout_rounded, size: 20),
                      onPressed: () =>
                          ref.read(authControllerProvider.notifier).logout(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'CPR ${displayed.nationalId}  ·  ${displayed.age} yrs  ·  '
                '${displayed.gender == 'M' ? 'Male' : 'Female'}'
                '${displayed.patientProfile != null ? '  ·  Blood ${displayed.patientProfile!.bloodType}' : ''}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),

              if (managedDependent != null) ...[
                const SizedBox(height: AppSpacing.md),
                const ManagingDependentBanner(),
              ],

              const SizedBox(height: AppSpacing.lg),
              const StaggeredFadeSlide(index: 1, child: SafetyBanner()),

              // ── Next appointment ────────────────────────────────────
              const SizedBox(height: AppSpacing.xxl),
              StaggeredFadeSlide(
                index: 2,
                child: FutureBuilder(
                  future: apptFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionHead(title: 'Next appointment'),
                          SizedBox(height: AppSpacing.md),
                          SkeletalShimmer(width: double.infinity, height: 96),
                        ],
                      );
                    }

                    final appts = snapshot.data!.fold((l) => l, (r) => <Appointment>[]);
                    final upcoming = appts
                        .where((a) =>
                            a.status == AppointmentStatus.booked ||
                            a.status == AppointmentStatus.confirmed)
                        .toList()
                      ..sort((a, b) => a.slotStart.compareTo(b.slotStart));

                    if (upcoming.isEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SectionHead(title: 'Next appointment'),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Nothing booked. Your last visit was '
                            '${appts.isEmpty ? 'not recorded' : formatClinicalDate(appts.last.slotStart)}.',
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ElevatedButton(
                            onPressed: () => ref
                                .read(patientNavIndexProvider.notifier)
                                .state = PatientTab.book,
                            child: const Text('Book an appointment'),
                          ),
                        ],
                      );
                    }

                    return _NextAppointment(appointment: upcoming.first);
                  },
                ),
              ),

              // ── The figure worth noticing ───────────────────────────
              const SizedBox(height: AppSpacing.xxl),
              StaggeredFadeSlide(
                index: 3,
                child: _WatchThis(patientId: patientId),
              ),

              // ── Today's medicines ───────────────────────────────────
              const SizedBox(height: AppSpacing.xxl),
              StaggeredFadeSlide(
                index: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHead(
                      title: "Today's medicines",
                      trailing: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const MedicationsScreen()),
                        ),
                        child: const Text('All'),
                      ),
                    ),
                    FutureBuilder(
                      future: medsFuture,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Padding(
                            padding: EdgeInsets.only(top: AppSpacing.md),
                            child: SkeletalShimmer(width: double.infinity, height: 72),
                          );
                        }
                        final meds = snapshot.data!.fold((l) => l, (r) => <Medication>[]);
                        if (meds.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.md),
                            child: Text(
                              'No active prescriptions on record.',
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }
                        return Column(
                          children: [
                            for (final m in meds) _MedicationRow(medication: m),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Secondary actions, stated as links not as a button bar
              const SizedBox(height: AppSpacing.xxl),
              StaggeredFadeSlide(
                index: 5,
                child: Wrap(
                  spacing: AppSpacing.lg,
                  runSpacing: AppSpacing.xs,
                  children: [
                    TextButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => LogVitalsModal(patientId: patientId),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('Log a reading'),
                    ),
                    TextButton.icon(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => ImportRecordModal(patientId: patientId),
                      ),
                      icon: const Icon(Icons.upload_file_rounded, size: 18),
                      label: const Text('Import a report'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The appointment, with its reminder plan stated rather than badged.
class _NextAppointment extends StatelessWidget {
  const _NextAppointment({required this.appointment});

  final Appointment appointment;

  String _reminderPlan(RiskBand? band) {
    switch (band) {
      case RiskBand.high:
        return 'Three reminders: a week before, two days before, and the '
            'morning of — plus a phone confirmation.';
      case RiskBand.medium:
        return 'Two reminders, two days and one day before.';
      case RiskBand.low:
      case null:
        return 'One reminder, 24 hours before.';
    }
  }

  Color _bandInk(RiskBand? band) {
    switch (band) {
      case RiskBand.high:
        return AppColors.riskHigh;
      case RiskBand.medium:
        return AppColors.riskMedium;
      case RiskBand.low:
      case null:
        return AppColors.riskLow;
    }
  }

  double _bandWidth(RiskBand? band) {
    switch (band) {
      case RiskBand.high:
        return 120;
      case RiskBand.medium:
        return 70;
      case RiskBand.low:
      case null:
        return 34;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final start = appointment.slotStart;
    final risk = appointment.noShowRisk;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHead(
          title: 'Next appointment',
          trailing: ClinicalBadge.appointmentStatus(appointment.status),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              child: Column(
                children: [
                  Text(
                    start.day.toString().padLeft(2, '0'),
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 32,
                      height: 1.0,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Eyebrow(_monthsShort[start.month - 1]),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              width: 1,
              height: 92,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appointment.doctorName ?? 'Consultant physician',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  if (appointment.departmentName != null)
                    Text(appointment.departmentName!, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 6),
                  Text(
                    '${formatTime24h(appointment.slotStart)} – '
                    '${formatTime24h(appointment.slotEnd)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (appointment.reasonText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      appointment.reasonText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Container(
                        width: _bandWidth(appointment.riskBand),
                        height: 6,
                        color: _bandInk(appointment.riskBand),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          risk != null
                              ? '${(risk * 100).toStringAsFixed(1)}% chance this gets missed'
                              : 'Attendance risk not scored',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _reminderPlan(appointment.riskBand),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// The one clinical figure the patient should see today: the most recently
/// drawn abnormal lab value, or the latest vitals reading if none is flagged.
class _WatchThis extends ConsumerWidget {
  const _WatchThis({required this.patientId});

  final int patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final aiState = ref.watch(aiSummaryControllerProvider);

    final recordsFuture = ref
        .watch(recordRepositoryProvider)
        .getTimelineForPatient(patientId, limit: 20);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHead(
          title: 'Watch this',
          trailing: aiState.summary != null
              ? Text(
                  'AI reading · ${formatClinicalDate(aiState.summary!.generatedAt)}',
                  style: theme.textTheme.labelSmall,
                )
              : null,
        ),
        const SizedBox(height: AppSpacing.md),
        FutureBuilder(
          future: recordsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SkeletalShimmer(width: double.infinity, height: 84);
            }

            final records = snapshot.data!.fold((l) => l, (r) => <MedicalRecord>[]);
            LabValue? flagged;
            MedicalRecord? source;
            for (final r in records) {
              for (final lab in r.labValues) {
                if (lab.abnormalFlag) {
                  flagged = lab;
                  source = r;
                  break;
                }
              }
              if (flagged != null) break;
            }

            if (flagged == null) {
              return Text(
                'Nothing outside its reference range in your last '
                '${records.length} records.',
                style: theme.textTheme.bodyMedium,
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FigureBlock(
                  value: flagged.value.toStringAsFixed(
                    flagged.value.truncateToDouble() == flagged.value ? 0 : 1,
                  ),
                  unit: flagged.unit,
                  context_: '${flagged.analyte}, drawn '
                      '${formatClinicalDate(source!.occurredAt)}. Reference '
                      '${flagged.refLow.toStringAsFixed(1)}–${flagged.refHigh.toStringAsFixed(1)}.',
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AiSummaryScreen()),
                      ),
                      child: const Text('Read the full summary'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const VitalsScreen()),
                      ),
                      child: const Text('See the trend'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// A medicine as a time in the day, not a card.
class _MedicationRow extends StatelessWidget {
  const _MedicationRow({required this.medication});

  final Medication medication;

  /// Reads the seeded frequency text for a time of day. The seed data uses
  /// consistent phrasing ("Once daily morning", "Once daily at bedtime"),
  /// so this stays a presentation detail rather than a schema change.
  String _timeHint(String frequency) {
    final f = frequency.toLowerCase();
    if (f.contains('bedtime')) return '22:30';
    if (f.contains('evening')) return '21:00';
    if (f.contains('morning')) return '08:00';
    if (f.contains('empty stomach')) return '07:00';
    if (f.contains('twice')) return '08:00 · 20:00';
    if (f.contains('needed')) return 'as needed';
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 78,
                child: Text(
                  _timeHint(medication.frequency),
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medication.name} ${medication.dose}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(medication.frequency, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
        const RowRule(),
      ],
    );
  }
}
