library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';
import 'package:myhealth_ai/features/family/family_controller.dart';

/// Persistent context strip shown across patient screens whenever a
/// guardian is acting on a dependent's record instead of their own — so
/// it's never ambiguous whose vitals, appointments, or timeline is on
/// screen. Renders nothing when the guardian is viewing their own record.
class ManagingDependentBanner extends ConsumerWidget {
  const ManagingDependentBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dependent = ref.watch(managedDependentProvider);
    if (dependent == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.aiSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.aiAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.family_restroom_rounded, size: 18, color: AppColors.aiAccent),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Managing ${dependent.fullName}\'s account',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.aiAccent),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          TextButton(
            onPressed: () => ref.read(managedDependentProvider.notifier).state = null,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Back to my account', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
