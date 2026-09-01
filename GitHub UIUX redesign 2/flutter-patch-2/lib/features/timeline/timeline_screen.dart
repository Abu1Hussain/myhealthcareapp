library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_screen.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/records/import_record_modal.dart';
import 'package:myhealth_ai/features/records/record_detail_screen.dart';
import 'package:myhealth_ai/features/scheduling/patient_appointments_screen.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/timeline/timeline_controller.dart';
import 'package:myhealth_ai/features/vitals/vitals_screen.dart';

const List<String> _monthsLong = [
  'January', 'February', 'March', 'April', 'May', 'June',
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// Chart — the merged Timeline and Records view.
///
/// Records group under month headings rather than floating as identical
/// cards, lab values print as a small table inside the row they belong to,
/// and the type filter carries only the categories the patient actually has.
class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  IconData _iconFor(RecordType type) {
    switch (type) {
      case RecordType.visitNote:
      case RecordType.consultationNote:
        return Icons.article_outlined;
      case RecordType.labResult:
      case RecordType.labReport:
        return Icons.science_outlined;
      case RecordType.imaging:
      case RecordType.imagingReport:
        return Icons.medical_information_outlined;
      case RecordType.prescription:
        return Icons.medication_outlined;
      case RecordType.vaccination:
        return Icons.vaccines_outlined;
      case RecordType.dischargeSummary:
        return Icons.local_hospital_outlined;
      case RecordType.referral:
        return Icons.shortcut_outlined;
    }
  }

  String _shortLabel(RecordType type) {
    switch (type) {
      case RecordType.visitNote:
      case RecordType.consultationNote:
        return 'Visits';
      case RecordType.labResult:
      case RecordType.labReport:
        return 'Labs';
      case RecordType.imaging:
      case RecordType.imagingReport:
        return 'Imaging';
      case RecordType.prescription:
        return 'Scripts';
      case RecordType.vaccination:
        return 'Vaccines';
      case RecordType.dischargeSummary:
        return 'Discharge';
      case RecordType.referral:
        return 'Referrals';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(timelineControllerProvider);
    final aiState = ref.watch(aiSummaryControllerProvider);
    final controller = ref.read(timelineControllerProvider.notifier);
    final user = ref.watch(currentUserProvider);
    final managedDependent = ref.watch(managedDependentProvider);
    final patientId = managedDependent?.id ?? user?.id;

    final facilities = state.records.map((r) => r.sourceFacility).toSet();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Head ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Chart',
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontSize: 32,
                            letterSpacing: -1.0,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Import a PDF report',
                        icon: const Icon(Icons.upload_file_rounded, size: 20),
                        onPressed: patientId == null
                            ? null
                            : () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) =>
                                      ImportRecordModal(patientId: patientId),
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    state.isLoading
                        ? 'Reading your record…'
                        : '${state.records.length} records · '
                            '${facilities.length} ${facilities.length == 1 ? 'facility' : 'facilities'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  if (managedDependent != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    const ManagingDependentBanner(),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    onChanged: controller.search,
                    decoration: const InputDecoration(
                      hintText: 'Search records, diagnoses, labs…',
                      prefixIcon: Icon(Icons.search_rounded, size: 19),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterPill(
                          label: 'All',
                          selected: state.selectedType == null,
                          onTap: () => controller.selectType(null),
                        ),
                        for (final t in RecordType.values)
                          _FilterPill(
                            label: _shortLabel(t),
                            selected: state.selectedType == t,
                            onTap: () => controller.selectType(t),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const VitalsScreen()),
                        ),
                        child: const Text('Vitals'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PatientAppointmentsScreen(),
                          ),
                        ),
                        child: const Text('Appointments'),
                      ),
                      if (aiState.summary != null)
                        TextButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const AiSummaryScreen()),
                          ),
                          child: const Text('AI reading'),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Feed ────────────────────────────────────────────────
            Expanded(
              child: state.isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: 5,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.lg),
                        child: SkeletalShimmer(width: double.infinity, height: 92),
                      ),
                    )
                  : state.records.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.folder_open_outlined,
                          title: 'Nothing here yet',
                          description: state.searchQuery.isNotEmpty
                              ? 'No record matches "${state.searchQuery}". Clear the '
                                  'search to see your full chart.'
                              : 'Import a PDF report, or complete a consultation, '
                                  'and it will appear here in date order.',
                          actionLabel: patientId == null ? null : 'Import a report',
                          onAction: patientId == null
                              ? null
                              : () => showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (_) =>
                                        ImportRecordModal(patientId: patientId),
                                  ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.xxxl,
                          ),
                          itemCount: state.records.length,
                          itemBuilder: (context, index) {
                            final record = state.records[index];
                            final previous =
                                index == 0 ? null : state.records[index - 1];
                            final newMonth = previous == null ||
                                previous.occurredAt.month != record.occurredAt.month ||
                                previous.occurredAt.year != record.occurredAt.year;

                            return StaggeredFadeSlide(
                              index: index,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (newMonth) ...[
                                    SizedBox(height: index == 0 ? 0 : AppSpacing.lg),
                                    Container(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ),
                                      child: Eyebrow(
                                        '${_monthsLong[record.occurredAt.month - 1]} '
                                        '${record.occurredAt.year}',
                                      ),
                                    ),
                                  ],
                                  _RecordRow(
                                    record: record,
                                    icon: _iconFor(record.recordType),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          constraints: const BoxConstraints(minHeight: 36),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 7,
          ),
          decoration: BoxDecoration(
            color: selected
                ? (isDark ? AppColors.accent800 : AppColors.accent100)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : theme.colorScheme.onSurface.withValues(alpha: 0.16),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected
                    ? (isDark ? AppColors.accent200 : AppColors.accent800)
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// One record: date in the margin, title and source, body, then any lab
/// values as a compact table. Magenta appears only on an abnormal flag.
class _RecordRow extends StatelessWidget {
  const _RecordRow({required this.record, required this.icon});

  final MedicalRecord record;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final abnormal = record.labValues.where((l) => l.abnormalFlag).length;

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecordDetailScreen(record: record)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  child: Column(
                    children: [
                      Text(
                        record.occurredAt.day.toString().padLeft(2, '0'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Icon(
                        icon,
                        size: 15,
                        color: isDark ? AppColors.accent300 : AppColors.accent700,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        record.authorName != null
                            ? '${record.sourceFacility} · ${record.authorName}'
                            : record.sourceFacility,
                        style: theme.textTheme.labelSmall,
                      ),
                      if (record.body.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          record.body,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                        ),
                      ],
                      if (record.labValues.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        for (final lab in record.labValues.take(4))
                          _LabLine(lab: lab),
                        if (record.labValues.length > 4)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${record.labValues.length - 4} more analytes',
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        if (abnormal > 0) ...[
                          const SizedBox(height: AppSpacing.sm),
                          ClinicalBadge(
                            label: '$abnormal outside range',
                            tone: ClinicalTone.critical,
                          ),
                        ],
                      ],
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

class _LabLine extends StatelessWidget {
  const _LabLine({required this.lab});

  final LabValue lab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final high = lab.value > lab.refHigh;
    final low = lab.value < lab.refLow;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Expanded(child: Text(lab.analyte, style: theme.textTheme.bodySmall)),
          Text(
            '${lab.value} ${lab.unit}',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              lab.abnormalFlag ? (high ? 'high' : (low ? 'low' : 'flagged')) : 'normal',
              textAlign: TextAlign.right,
              style: theme.textTheme.labelSmall?.copyWith(
                color: lab.abnormalFlag
                    ? (isDark ? AppColors.accent2300 : AppColors.accent2700)
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
