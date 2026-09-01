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
import 'package:myhealth_ai/features/scheduling/scheduling_service.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/services/clinical/appointment_triage_service.dart';

const List<String> _weekdaysShort = [
  'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

/// Booking — four steps, real roster, honest risk.
///
/// Two things changed beyond the styling. The department list and doctor
/// roster now come from the database (`getDepartments`, `getStaffMembers`)
/// instead of a hardcoded map whose names never matched the seed data, and
/// the appointment books against the selected department's real id rather
/// than `departmentId: 1`. No-show risk is one bar you can compare down the
/// column, with the percentage written out.
class BookingWizardScreen extends ConsumerStatefulWidget {
  const BookingWizardScreen({super.key});

  @override
  ConsumerState<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends ConsumerState<BookingWizardScreen> {
  int _step = 0;

  Department? _department;
  User? _doctor;

  ScoredSlot? _slot;
  List<ScoredSlot> _slots = [];
  bool _loadingSlots = false;

  final _reasonController = TextEditingController(text: 'Routine consultation');
  bool _booking = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String get _stepTitle {
    switch (_step) {
      case 0:
        return 'Which\ndepartment?';
      case 1:
        return 'Who would you\nlike to see?';
      case 2:
        return 'Fourteen days,\nranked';
      default:
        return 'Check and\nconfirm';
    }
  }

  bool get _canAdvance {
    switch (_step) {
      case 0:
        return _department != null;
      case 1:
        return _doctor != null;
      case 2:
        return _slot != null;
      default:
        return false;
    }
  }

  Future<void> _loadSlots() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _doctor == null) return;

    final patient = ref.read(managedDependentProvider) ?? user;
    setState(() => _loadingSlots = true);

    final medsResult = await ref
        .read(vitalsRepositoryProvider)
        .getMedicationsForPatient(patient.id, activeOnly: true);
    final meds = medsResult.fold((l) => l, (_) => <Medication>[]);

    final apptResult = await ref
        .read(appointmentRepositoryProvider)
        .getAppointmentsForPatient(patient.id);
    final appts = apptResult.fold((l) => l, (_) => <Appointment>[]);
    final lastVisit = appts
        .where((a) => a.status == AppointmentStatus.completed)
        .map((a) => a.slotStart)
        .fold<DateTime?>(null, (prev, d) => prev == null || d.isAfter(prev) ? d : prev);

    final now = DateTime.now();
    final result = await ref.read(schedulingServiceProvider).getScoredSlots(
          patient: patient,
          doctorId: _doctor!.id,
          doctorName: _doctor!.fullName,
          departmentName: _department?.name ?? '',
          dateFrom: now.add(const Duration(days: 1)),
          dateTo: now.add(const Duration(days: 14)),
          activeMedCount: meds.length,
          lastVisitDate: lastVisit,
        );

    result.fold(
      (slots) => setState(() {
        _slots = slots.take(20).toList();
        _loadingSlots = false;
      }),
      (_) => setState(() => _loadingSlots = false),
    );
  }

  Future<void> _confirm() async {
    final user = ref.read(currentUserProvider);
    if (user == null || _slot == null) return;
    final patient = ref.read(managedDependentProvider) ?? user;

    setState(() => _booking = true);

    final result = await ref.read(appointmentRepositoryProvider).bookAppointment(
          patientId: patient.id,
          staffId: _slot!.doctorId,
          departmentId: _department?.id ?? _doctor?.staffProfile?.departmentId ?? 1,
          slotStart: _slot!.slotStart,
          slotEnd: _slot!.slotEnd,
          visitType: 'Consultation',
          reasonText: _reasonController.text,
          predictedNoShowRisk: _slot!.prediction.probability,
          riskBand: _slot!.prediction.riskBand,
        );

    if (!mounted) return;

    result.fold(
      (appointment) {
        ref.read(schedulingServiceProvider).generateReminders(
              slotStart: _slot!.slotStart,
              riskBand: _slot!.prediction.riskBand,
              appointmentId: appointment.id,
              patientId: patient.id,
            );
        setState(() {
          _booking = false;
          _step = 0;
          _department = null;
          _doctor = null;
          _slot = null;
          _slots = [];
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Booked — ${formatClinicalDate(appointment.slotStart)} at '
              '${formatTime24h(appointment.slotStart)}',
            ),
          ),
        );
      },
      (failure) {
        setState(() => _booking = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not book: ${failure.message}')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (_step > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                          onPressed: () => setState(() => _step--),
                        ),
                      Expanded(
                        child: Eyebrow('Step ${_step + 1} of 4'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++)
                        Expanded(
                          child: Container(
                            height: 3,
                            margin: EdgeInsets.only(right: i == 3 ? 0 : 3),
                            color: i <= _step
                                ? (theme.brightness == Brightness.dark
                                    ? AppColors.accent400
                                    : AppColors.cyanInk)
                                : AppColors.neutral300,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    _stepTitle,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontSize: 30,
                      letterSpacing: -1.0,
                      height: 1.06,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
            Expanded(child: _stepContent()),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: _step < 3
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canAdvance
                            ? () {
                                if (_step == 1) _loadSlots();
                                setState(() => _step++);
                              }
                            : null,
                        child: Text(_step == 1 ? 'See available slots' : 'Continue'),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _booking ? null : _confirm,
                        child: _booking
                            ? const Text('Booking…')
                            : const Text('Confirm booking'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepContent() {
    switch (_step) {
      case 0:
        return _departmentStep();
      case 1:
        return _doctorStep();
      case 2:
        return _slotStep();
      default:
        return _confirmStep();
    }
  }

  // ── Step 1 ─────────────────────────────────────────────────────────
  Widget _departmentStep() {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: ref.read(userRepositoryProvider).getDepartments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SkeletalShimmer(width: double.infinity, height: 240),
          );
        }
        final departments = snapshot.data!.fold((l) => l, (_) => <Department>[]);

        if (departments.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.apartment_outlined,
            title: 'No departments configured',
            description: 'An administrator needs to add at least one '
                'department before appointments can be booked.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final dept = departments[index];
            final selected = _department?.id == dept.id;

            return StaggeredFadeSlide(
              index: index,
              child: InkWell(
                onTap: () => setState(() {
                  _department = dept;
                  _doctor = null;
                }),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dept.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 18,
                                    fontWeight:
                                        selected ? FontWeight.w600 : FontWeight.w400,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(dept.description, style: theme.textTheme.bodySmall),
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.accent300
                                  : AppColors.accent700,
                            ),
                        ],
                      ),
                    ),
                    const RowRule(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Step 2 ─────────────────────────────────────────────────────────
  Widget _doctorStep() {
    final theme = Theme.of(context);

    return FutureBuilder(
      future: ref
          .read(userRepositoryProvider)
          .getStaffMembers(departmentId: _department?.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SkeletalShimmer(width: double.infinity, height: 200),
          );
        }
        final staff = snapshot.data!.fold((l) => l, (_) => <User>[]);

        if (staff.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.person_search_outlined,
            title: 'No clinician in ${_department?.name ?? 'this department'}',
            description: 'Choose another department, or ask reception to '
                'assign a clinician to this one.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          itemCount: staff.length,
          itemBuilder: (context, index) {
            final doc = staff[index];
            final profile = doc.staffProfile;
            final selected = _doctor?.id == doc.id;
            final initials = doc.fullName
                .replaceAll('Dr. ', '')
                .split(' ')
                .where((p) => p.isNotEmpty)
                .take(2)
                .map((p) => p[0])
                .join();

            return StaggeredFadeSlide(
              index: index,
              child: InkWell(
                onTap: () => setState(() => _doctor = doc),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            alignment: Alignment.center,
                            color: theme.brightness == Brightness.dark
                                ? AppColors.surfaceDark
                                : AppColors.paperSurface,
                            child: Text(
                              initials,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.fullName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: 17,
                                    fontWeight:
                                        selected ? FontWeight.w600 : FontWeight.w400,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                if (profile != null) ...[
                                  Text(
                                    profile.specialty,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${profile.licenseNo} · ${profile.jobTitle}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (selected)
                            Icon(
                              Icons.check_rounded,
                              size: 20,
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.accent300
                                  : AppColors.accent700,
                            ),
                        ],
                      ),
                    ),
                    const RowRule(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Step 3 ─────────────────────────────────────────────────────────
  Widget _slotStep() {
    final theme = Theme.of(context);

    if (_loadingSlots) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: 5,
        itemBuilder: (_, __) => const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: SkeletalShimmer(width: double.infinity, height: 68),
        ),
      );
    }

    if (_slots.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.event_busy_outlined,
        title: 'Nothing free in the next fortnight',
        description: 'Every slot in this clinician\'s next fourteen working '
            'days is taken. Try another clinician, or check again tomorrow.',
      );
    }

    // The widest bar in the list sets the scale, so the bars are
    // comparable to each other rather than to an abstract maximum.
    final worst = _slots
        .map((s) => s.prediction.probability)
        .reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'Slots you are most likely to keep come first. The bar is the '
            'model\'s estimate that the appointment gets missed — shorter is '
            'better.',
            style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            itemCount: _slots.length,
            itemBuilder: (context, index) {
              final slot = _slots[index];
              final selected = _slot == slot;
              final p = slot.prediction.probability;
              final width = (p / (worst == 0 ? 1 : worst)) * 150;

              return StaggeredFadeSlide(
                index: index,
                child: InkWell(
                  onTap: () => setState(() => _slot = slot),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_weekdaysShort[slot.slotStart.weekday - 1]} '
                                    '${formatClinicalDate(slot.slotStart)} · '
                                    '${formatTime24h(slot.slotStart)}',
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight:
                                          selected ? FontWeight.w600 : FontWeight.w400,
                                      fontFeatures: const [FontFeature.tabularFigures()],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${slot.doctorName} · ${slot.departmentName}',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  const SizedBox(height: 7),
                                  Row(
                                    children: [
                                      Container(
                                        width: width.clamp(8, 150),
                                        height: 5,
                                        color: _bandInk(slot.prediction.riskBand),
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Text(
                                        '${(p * 100).toStringAsFixed(1)}%',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          fontFeatures: const [
                                            FontFeature.tabularFigures()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check_rounded,
                                size: 20,
                                color: theme.brightness == Brightness.dark
                                    ? AppColors.accent300
                                    : AppColors.accent700,
                              ),
                          ],
                        ),
                      ),
                      const RowRule(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ── Step 4 ─────────────────────────────────────────────────────────
  Widget _confirmStep() {
    final theme = Theme.of(context);
    final slot = _slot;
    if (slot == null) return const SizedBox.shrink();

    final profile = _doctor?.staffProfile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SummaryLine(label: 'Department', value: slot.departmentName),
          _SummaryLine(label: 'Clinician', value: slot.doctorName),
          if (profile != null) _SummaryLine(label: 'Licence', value: profile.licenseNo),
          _SummaryLine(
            label: 'Date',
            value: '${_weekdaysShort[slot.slotStart.weekday - 1]} '
                '${formatClinicalDate(slot.slotStart)}',
          ),
          _SummaryLine(
            label: 'Time',
            value: '${formatTime24h(slot.slotStart)} – ${formatTime24h(slot.slotEnd)}',
          ),

          const SizedBox(height: AppSpacing.xl),
          const SectionHead(title: 'What the model expects'),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FigureBlock(
                value: (slot.prediction.probability * 100).toStringAsFixed(1),
                unit: '%',
                size: 40,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    'chance this appointment gets missed — '
                    '${slot.prediction.riskLabel.toLowerCase()}',
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _reminderPlan(slot.prediction.riskBand),
            style: theme.textTheme.bodyMedium?.copyWith(height: 1.55),
          ),

          if (slot.prediction.topProtectiveFactors.isNotEmpty ||
              slot.prediction.topRiskFactors.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.lg),
            const Eyebrow('Why it ranked where it did'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final factor in slot.prediction.topProtectiveFactors)
                  ClinicalBadge(
                    label: '${factor.key} · helps',
                    tone: ClinicalTone.primary,
                  ),
                for (final factor in slot.prediction.topRiskFactors)
                  ClinicalBadge(label: '${factor.key} · adds risk'),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          const SectionHead(title: 'Reason for visit'),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _reasonController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'What would you like to be seen about?',
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedBuilder(
            animation: _reasonController,
            builder: (context, _) {
              final urgency =
                  AppointmentTriageService.classify(_reasonController.text);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClinicalBadge(
                    label: '${urgency.label} priority',
                    tone: urgency.tone,
                    icon: urgency.icon,
                    pulsing: urgency == AppointmentUrgency.urgent,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      urgency.description,
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Color _bandInk(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return AppColors.riskLow;
      case RiskBand.medium:
        return AppColors.riskMedium;
      case RiskBand.high:
        return AppColors.riskHigh;
    }
  }

  String _reminderPlan(RiskBand band) {
    switch (band) {
      case RiskBand.low:
        return 'One reminder will reach you 24 hours before.';
      case RiskBand.medium:
        return 'Two reminders: two days before, and the day before.';
      case RiskBand.high:
        return 'Three reminders — a week before, two days before, and the '
            'morning of — plus a phone call to confirm.';
    }
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 108,
                child: Text(label, style: theme.textTheme.bodySmall),
              ),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
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
