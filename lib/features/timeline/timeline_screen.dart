library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/auth/auth_controller.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';
import 'package:myhealth_ai/features/family/managing_dependent_banner.dart';
import 'package:myhealth_ai/features/records/import_record_modal.dart';
import 'package:myhealth_ai/features/records/record_detail_screen.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/empty_state_widget.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/timeline/timeline_controller.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  IconData _iconForRecordType(RecordType type) {
    switch (type) {
      case RecordType.visitNote:
      case RecordType.consultationNote:
        return Icons.article_outlined;
      case RecordType.labResult:
      case RecordType.labReport:
        return Icons.science_outlined;
      case RecordType.imaging:
      case RecordType.imagingReport:
        return Icons.medical_services_outlined;
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(timelineControllerProvider);
    final aiState = ref.watch(aiSummaryControllerProvider);
    final controller = ref.read(timelineControllerProvider.notifier);
    final user = ref.watch(currentUserProvider);
    final managedDependent = ref.watch(managedDependentProvider);
    final patientId = managedDependent?.id ?? user?.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unified Health Timeline'),
        actions: [
          IconButton(
            tooltip: 'Import External PDF',
            icon: const Icon(Icons.upload_file_rounded),
            onPressed: () {
              if (patientId != null) {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => ImportRecordModal(patientId: patientId),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (managedDependent != null)
              const Padding(
                padding: EdgeInsets.fromLTRB(AppSpacing.pagePadding, AppSpacing.sm, AppSpacing.pagePadding, 0),
                child: ManagingDependentBanner(),
              ),
            // Search Bar & Filter Chips Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal, vertical: AppSpacing.sm),
              child: Column(
                children: [
                  TextField(
                    onChanged: controller.search,
                    decoration: const InputDecoration(
                      hintText: 'Search records, diagnoses, labs...',
                      prefixIcon: Icon(Icons.search_rounded, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: state.selectedType == null,
                          onSelected: (_) => controller.selectType(null),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        ...RecordType.values.map((type) {
                          final isSelected = state.selectedType == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: AppSpacing.xs),
                            child: FilterChip(
                              label: Text(type.name),
                              selected: isSelected,
                              onSelected: (_) => controller.selectType(type),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Timeline Feed Content
            Expanded(
              child: state.isLoading
                  ? ListView.builder(
                      padding: const EdgeInsets.all(AppSpacing.pagePadding),
                      itemCount: 5,
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.only(bottom: AppSpacing.md),
                        child: SkeletalShimmer(width: double.infinity, height: 100),
                      ),
                    )
                  : state.records.isEmpty
                      ? EmptyStateWidget(
                          icon: Icons.timeline_rounded,
                          title: 'No Clinical Records Found',
                          description: 'Upload a PDF medical report or complete a consultation to build your health timeline.',
                          actionLabel: 'Import PDF Report',
                          onAction: () {
                            if (patientId != null) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => ImportRecordModal(patientId: patientId),
                              );
                            }
                          },
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(AppSpacing.pagePadding),
                          itemCount: state.records.length + (aiState.summary != null && aiState.summary!.keyEvents.isNotEmpty ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Render AI Key Event Highlights as the first card (P3-11)
                            if (aiState.summary != null && aiState.summary!.keyEvents.isNotEmpty && index == 0) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                                child: DoubleBezelCard(
                                  backgroundColor: context.aiSurface,
                                  borderColor: AppColors.aiAccent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.auto_awesome_rounded, color: AppColors.aiAccent, size: 18),
                                          SizedBox(width: AppSpacing.sm),
                                          Text(
                                            'AI Key Timeline Milestones',
                                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.aiAccent),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: AppSpacing.sm),
                                      ...aiState.summary!.keyEvents.take(2).map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.only(bottom: 6),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.primaryTeal),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  '${e.title} (${e.date})',
                                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                              ClinicalBadge(
                                                label: e.importance,
                                                backgroundColor: e.importance == 'High' ? const Color(0x20EF4444) : const Color(0x203B82F6),
                                                textColor: e.importance == 'High' ? AppColors.critical : AppColors.info,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final recordIndex = (aiState.summary != null && aiState.summary!.keyEvents.isNotEmpty) ? index - 1 : index;
                            final record = state.records[recordIndex];
                            final icon = _iconForRecordType(record.recordType);

                            return StaggeredFadeSlide(
                              index: index,
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                                child: DoubleBezelCard(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => RecordDetailScreen(record: record),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryTeal.withValues(alpha: 0.12),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(icon, color: AppColors.primaryTeal, size: 22),
                                      ),
                                      const SizedBox(width: AppSpacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    record.title,
                                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                                  ),
                                                ),
                                                ClinicalBadge.recordType(record.recordType),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${formatClinicalDate(record.occurredAt)} • ${record.sourceFacility}',
                                              style: TextStyle(color: context.textTertiary, fontSize: 11),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              record.body,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: context.textSecondary, fontSize: 13),
                                            ),
                                            if (record.labValues.isNotEmpty) ...[
                                              const SizedBox(height: AppSpacing.sm),
                                              Row(
                                                children: [
                                                  ClinicalBadge(
                                                    label: '${record.labValues.length} Lab Values',
                                                    backgroundColor: AppColors.primaryTealSurface,
                                                    textColor: AppColors.primaryTeal,
                                                  ),
                                                  if (record.labValues.any((l) => l.abnormalFlag)) ...[
                                                    const SizedBox(width: 6),
                                                    const ClinicalBadge(
                                                      label: 'Abnormal Flag',
                                                      backgroundColor: Color(0x20EF4444),
                                                      textColor: AppColors.critical,
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
