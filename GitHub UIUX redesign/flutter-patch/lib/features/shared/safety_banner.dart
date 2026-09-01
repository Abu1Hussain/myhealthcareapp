library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/context_colors.dart';

/// Mandatory clinical safety notice, shown on every AI surface.
///
/// Reworded from shorthand into a sentence a patient can actually parse,
/// and recoloured: it now sits on the surface tint in ink, with the cyan
/// carried only by the mark. The banner is the one place the app makes a
/// promise, so it reads as text, not as a warning chip.
class SafetyBanner extends StatelessWidget {
  const SafetyBanner({
    super.key,
    this.message =
        'AI summaries assist, never diagnose. Every generated line is reviewed '
        'by your clinician before it enters your record.',
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: context.aiSurface,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.verified_outlined,
            size: 18,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.accent300
                : AppColors.accent700,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
