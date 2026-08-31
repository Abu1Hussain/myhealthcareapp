library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/domain/entities/models.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/patient_home/patient_shell.dart';
import 'package:myhealth_ai/features/shared/clinical_badge.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';

class AiSummaryScreen extends ConsumerWidget {
  const AiSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiSummaryControllerProvider);
    final controller = ref.read(aiSummaryControllerProvider.notifier);
    final summary = state.summary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Health Profile Summary'),
        actions: [
          IconButton(
            tooltip: 'Regenerate Summary',
            icon: const Icon(Icons.refresh_rounded),
            onPressed: state.isLoading ? null : () => controller.loadSummary(forceRefresh: true),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mandatory Safety Banner (P3-13)
              const SafetyBanner(),
              const SizedBox(height: AppSpacing.lg),

              if (state.isLoading) ...[
                const SkeletalShimmer(width: double.infinity, height: 180),
                const SizedBox(height: AppSpacing.lg),
                const SkeletalShimmer(width: double.infinity, height: 140),
                const SizedBox(height: AppSpacing.lg),
                const SkeletalShimmer(width: double.infinity, height: 120),
              ] else if (state.errorMessage != null) ...[
                DoubleBezelCard(
                  borderColor: AppColors.critical,
                  child: Column(
                    children: [
                      const Icon(Icons.error_outline_rounded, size: 40, color: AppColors.critical),
                      const SizedBox(height: AppSpacing.sm),
                      Text(state.errorMessage!, textAlign: TextAlign.center),
                      const SizedBox(height: AppSpacing.md),
                      ElevatedButton(
                        onPressed: () => controller.loadSummary(forceRefresh: true),
                        child: const Text('Retry Generation'),
                      ),
                    ],
                  ),
                ),
              ] else if (summary != null) ...[
                // 1. Clinical Overview Markdown Card
                DoubleBezelCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.aiAccent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.aiAccent, size: 18),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Longitudinal Health Overview',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            formatClinicalDate(summary.generatedAt),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        summary.summaryMarkdown,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                            ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // 2. Health Trends & Deep Linking (P3-12)
                if (summary.trends.isNotEmpty) ...[
                  Text(
                    'Identified Health Trends',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Tap a trend card to open the corresponding interactive vitals graph:',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...summary.trends.map((t) {
                    final isWorsening = t.direction == 'worsening';
                    final isImproving = t.direction == 'improving';
                    final color = isWorsening
                        ? AppColors.critical
                        : (isImproving ? AppColors.success : AppColors.info);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: DoubleBezelCard(
                        onTap: () {
                          // Deep-link to Vitals Screen tab
                          ref.read(patientNavIndexProvider.notifier).state = 2;
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isWorsening
                                    ? Icons.trending_up_rounded
                                    : (isImproving ? Icons.trending_down_rounded : Icons.trending_flat_rounded),
                                color: color,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        t.metric,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                      ),
                                      const Spacer(),
                                      ClinicalBadge(
                                        label: t.direction.toUpperCase(),
                                        backgroundColor: color.withValues(alpha: 0.15),
                                        textColor: color,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.significance,
                                    style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiaryLight),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // 3. Significant Clinical Key Events
                if (summary.keyEvents.isNotEmpty) ...[
                  Text(
                    'Key Clinical Milestones',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...summary.keyEvents.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: DoubleBezelCard(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.primaryTealSurface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_note_rounded, color: AppColors.primaryTeal, size: 20),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.title,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                  ),
                                  Text(
                                    '${e.category} • ${e.date}',
                                    style: const TextStyle(color: AppColors.textSecondaryLight, fontSize: 11),
                                  ),
                                ],
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
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // 4. Clinical Red Flags (if any)
                if (summary.redFlags.isNotEmpty) ...[
                  DoubleBezelCard(
                    borderColor: AppColors.critical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.warning_amber_rounded, color: AppColors.critical, size: 20),
                            SizedBox(width: AppSpacing.sm),
                            Text(
                              'Clinical Observations to Note',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.critical),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        ...summary.redFlags.map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(color: AppColors.critical, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text(
                                    r,
                                    style: const TextStyle(fontSize: 13, color: AppColors.textPrimaryLight),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // 5. Audit Trail & Metadata Footer (P3-14)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.canvasLight,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Audit & Reproducibility Metadata (RQ1)',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Model: ${summary.modelId} • Prompt: ${summary.promptVersion}\n'
                        'Context Hash: ${summary.inputHash.substring(0, 16)}...',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 11,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
