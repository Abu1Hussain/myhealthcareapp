library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/core/utils/date_utils.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/shared/broadsheet_bits.dart';
import 'package:myhealth_ai/features/shared/safety_banner.dart';
import 'package:myhealth_ai/features/shared/skeletal_shimmer.dart';
import 'package:myhealth_ai/features/shared/staggered_fade_slide.dart';
import 'package:myhealth_ai/features/vitals/vitals_screen.dart';

/// The AI reading.
///
/// Prose first, at reading size. The old screen led with a violet-marked
/// card, three badge colours and a chevron list; the model's actual
/// sentences were the smallest thing on it.
class AiSummaryScreen extends ConsumerWidget {
  const AiSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(aiSummaryControllerProvider);
    final controller = ref.read(aiSummaryControllerProvider.notifier);
    final summary = state.summary;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, size: 20),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: state.isLoading
                        ? null
                        : () => controller.loadSummary(forceRefresh: true),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: const Text('Regenerate'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Eyebrow('AI reading', accent: true),
              const SizedBox(height: 6),
              Text(
                'Your record,\nin one page',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 34,
                  letterSpacing: -1.1,
                  height: 1.05,
                ),
              ),
              if (summary != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Generated ${formatClinicalDate(summary.generatedAt)} at '
                  '${formatTime24h(summary.generatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              const SafetyBanner(),
              const SizedBox(height: AppSpacing.xxl),

              if (state.isLoading) ...[
                const SkeletalShimmer(width: double.infinity, height: 22),
                const SizedBox(height: AppSpacing.sm),
                const SkeletalShimmer(width: double.infinity, height: 22),
                const SizedBox(height: AppSpacing.sm),
                const SkeletalShimmer(width: 220, height: 22),
                const SizedBox(height: AppSpacing.xxl),
                const SkeletalShimmer(width: double.infinity, height: 120),
              ] else if (state.errorMessage != null) ...[
                const SectionHead(title: 'The summary could not be built', emphasis: true),
                const SizedBox(height: AppSpacing.md),
                Text(state.errorMessage!, style: theme.textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton(
                  onPressed: () => controller.loadSummary(forceRefresh: true),
                  child: const Text('Try again'),
                ),
              ] else if (summary != null) ...[
                // ── The prose ─────────────────────────────────────────
                StaggeredFadeSlide(
                  index: 0,
                  child: Text(
                    summary.summaryMarkdown,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontSize: 16.5,
                      height: 1.62,
                    ),
                  ),
                ),

                // ── Trends ───────────────────────────────────────────
                if (summary.trends.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  const SectionHead(title: 'Trends the model found'),
                  for (var i = 0; i < summary.trends.length; i++)
                    StaggeredFadeSlide(
                      index: i + 1,
                      child: _TrendRow(
                        metric: summary.trends[i].metric,
                        direction: summary.trends[i].direction,
                        significance: summary.trends[i].significance,
                      ),
                    ),
                ],

                // ── Milestones ───────────────────────────────────────
                if (summary.keyEvents.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  const SectionHead(title: 'Milestones in the record'),
                  for (final e in summary.keyEvents)
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 92,
                                child: Text(
                                  e.date,
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
                                      e.title,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(e.category, style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ),
                              if (e.importance == 'High')
                                Text(
                                  'notable',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.brightness == Brightness.dark
                                        ? AppColors.accent2300
                                        : AppColors.accent2700,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const RowRule(),
                      ],
                    ),
                ],

                // ── Red flags ────────────────────────────────────────
                if (summary.redFlags.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.xxl),
                  const SectionHead(
                    title: 'Bring these up at your next visit',
                    emphasis: true,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final r in summary.redFlags)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 7, right: AppSpacing.sm),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.magentaInk,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              r,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 15,
                                height: 1.55,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],

                // ── Provenance ───────────────────────────────────────
                const SizedBox(height: AppSpacing.xxxl),
                Container(
                  padding: const EdgeInsets.only(top: AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.16),
                      ),
                    ),
                  ),
                  child: Text(
                    'Model ${summary.modelId} · prompt ${summary.promptVersion}\n'
                    'Context hash ${summary.inputHash.length > 16 ? summary.inputHash.substring(0, 16) : summary.inputHash}…',
                    style: theme.textTheme.labelSmall?.copyWith(
                      height: 1.6,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
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

/// A trend as a sentence, with direction stated in words. The arrow is a
/// small mark, not a coloured badge; only a worsening trend takes magenta.
class _TrendRow extends StatelessWidget {
  const _TrendRow({
    required this.metric,
    required this.direction,
    required this.significance,
  });

  final String metric;
  final String direction;
  final String significance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final worsening = direction == 'worsening';
    final improving = direction == 'improving';

    final ink = worsening
        ? (isDark ? AppColors.accent2300 : AppColors.accent2700)
        : (improving
            ? (isDark ? AppColors.accent300 : AppColors.accent700)
            : theme.colorScheme.onSurfaceVariant);

    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const VitalsScreen()),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  worsening
                      ? Icons.trending_up_rounded
                      : (improving ? Icons.trending_down_rounded : Icons.trending_flat_rounded),
                  size: 22,
                  color: ink,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$metric — $direction',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(significance, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: isDark ? AppColors.accent300 : AppColors.accent700,
                  ),
                ),
              ],
            ),
          ),
        ),
        const RowRule(),
      ],
    );
  }
}
