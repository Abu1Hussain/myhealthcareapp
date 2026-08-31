library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_controller.dart';
import 'package:myhealth_ai/features/ai_summary/ai_summary_screen.dart';
import 'package:myhealth_ai/features/shared/double_bezel_card.dart';

/// Compact AI Health Summary preview card embedded on Patient Home screen.
class AiSummaryCard extends ConsumerWidget {
  const AiSummaryCard({super.key, this.patientId});

  final dynamic patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aiSummaryControllerProvider);

    return DoubleBezelCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const AiSummaryScreen()),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.aiAccent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome_rounded, color: AppColors.aiAccent, size: 24),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'AI Health Summary',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: context.aiSurface,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: const Text(
                        'AI Generated',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.aiAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  state.isLoading
                      ? 'Analyzing timeline records...'
                      : (state.summary != null
                          ? '${state.summary!.trends.length} trends • ${state.summary!.keyEvents.length} milestones'
                          : 'Tap to generate automated clinical summary'),
                  style: TextStyle(color: context.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: context.textTertiary),
        ],
      ),
    );
  }
}
