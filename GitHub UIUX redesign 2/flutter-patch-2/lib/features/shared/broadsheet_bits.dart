library;

import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';

/// Small structural pieces shared by the redesigned screens.
///
/// Broadsheet organises a page with rules, whitespace and the serif scale.
/// These are the three pieces that repeat often enough to be worth naming.

/// A section heading with the system's hairline rule beneath it, and an
/// optional trailing action or note on the same baseline.
class SectionHead extends StatelessWidget {
  const SectionHead({
    super.key,
    required this.title,
    this.trailing,
    this.rule = true,
    this.emphasis = false,
  });

  final String title;
  final Widget? trailing;
  final bool rule;

  /// Print the rule in the second ink — reserved for a section the reader
  /// must not skip (clinical observations, red flags).
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 6),
      decoration: rule
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: emphasis
                      ? AppColors.magentaInk
                      : theme.colorScheme.onSurface,
                ),
              ),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
                color: emphasis
                    ? (theme.brightness == Brightness.dark
                        ? AppColors.accent2300
                        : AppColors.accent2700)
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// An all-caps kicker above a heading or block.
class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key, this.accent = false});

  final String text;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Text(
      text.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: accent
            ? (isDark ? AppColors.accent300 : AppColors.accent700)
            : theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// A large tabular figure with its unit and a line of context beside it —
/// the one moment of scale on a screen.
class FigureBlock extends StatelessWidget {
  const FigureBlock({
    super.key,
    required this.value,
    this.unit,
    this.context_,
    this.size = 56,
  });

  final String value;
  final String? unit;
  final String? context_;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: theme.textTheme.displayMedium?.copyWith(
            fontSize: size,
            fontWeight: FontWeight.w600,
            height: 1.0,
            letterSpacing: -1.6,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (unit != null)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(unit!, style: theme.textTheme.bodyMedium),
          ),
        if (context_ != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.md, bottom: 6),
              child: Text(
                context_!,
                style: theme.textTheme.bodySmall?.copyWith(height: 1.45),
              ),
            ),
          ),
      ],
    );
  }
}

/// Hairline separating two rows in a list. Ten per cent ink: present, quiet.
class RowRule extends StatelessWidget {
  const RowRule({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10),
    );
  }
}
