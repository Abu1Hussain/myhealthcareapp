library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';

/// Machined double-bezel card container following high-end-visual-design skill §4A,
/// apple-design fluid tactile feedback, and DESIGN.md §4.
class DoubleBezelCard extends StatefulWidget {
  const DoubleBezelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;

  /// Optional solid color-coded stripe along the card's leading edge —
  /// used for at-a-glance triage priority (e.g. appointment urgency)
  /// without overloading the status badges already inside the card.
  final Color? accentColor;

  @override
  State<DoubleBezelCard> createState() => _DoubleBezelCardState();
}

class _DoubleBezelCardState extends State<DoubleBezelCard> with SingleTickerProviderStateMixin {
  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 180),
    lowerBound: 0.982,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBg = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final defaultBorder = isDark ? AppColors.borderDark : AppColors.borderLight;

    final outerShell = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight,
        borderRadius: BorderRadius.circular(AppRadius.card + 4),
        border: Border.all(
          color: (widget.borderColor ?? defaultBorder).withValues(alpha: 0.5),
        ),
        boxShadow: AppElevation.cardShadow,
      ),
      padding: const EdgeInsets.all(3.0), // Outer bezel offset
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? defaultBg,
          ),
          child: widget.accentColor == null
              ? Padding(padding: widget.padding, child: widget.child)
              : IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(width: 4, color: widget.accentColor),
                      Expanded(
                        child: Padding(padding: widget.padding, child: widget.child),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );

    if (widget.onTap == null) return outerShell;

    return GestureDetector(
      onTapDown: (_) => _pressController.animateTo(0.982, curve: Curves.easeOutQuad),
      onTapUp: (_) {
        _pressController.animateTo(1.0, curve: Curves.easeOutBack);
        widget.onTap?.call();
      },
      onTapCancel: () => _pressController.animateTo(1.0, curve: Curves.easeOutBack),
      child: ScaleTransition(
        scale: _pressController,
        child: outerShell,
      ),
    );
  }
}

