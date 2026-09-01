library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';

/// A block of content on the page.
///
/// The name is kept because 24 screens import it; the double bezel is not.
/// Broadsheet structures a page with whitespace and hairline rules rather
/// than with bordered, shadowed boxes, so by default this renders flat on
/// the paper ground with a hairline rule beneath it.
///
/// Pass [filled] for a genuinely discrete item — a listing, a modal body —
/// where the surface tint earns its place. [borderColor] still draws a full
/// hairline border when a caller wants one, and [accentColor] still paints
/// the leading triage stripe.
class DoubleBezelCard extends StatefulWidget {
  const DoubleBezelCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.symmetric(vertical: AppSpacing.md),
    this.margin,
    this.onTap,
    this.borderColor,
    this.backgroundColor,
    this.accentColor,
    this.filled = false,
    this.rule = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final Color? backgroundColor;

  /// Leading stripe for at-a-glance triage priority.
  final Color? accentColor;

  /// Fill with the surface tint instead of sitting flat on the paper.
  final bool filled;

  /// Draw the hairline rule beneath the block. Off for a filled block,
  /// which already reads as discrete.
  final bool rule;

  @override
  State<DoubleBezelCard> createState() => _DoubleBezelCardState();
}

class _DoubleBezelCardState extends State<DoubleBezelCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _press = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 110),
    reverseDuration: const Duration(milliseconds: 200),
    lowerBound: 0.988,
    upperBound: 1.0,
    value: 1.0,
  );

  bool _hovered = false;

  @override
  void dispose() {
    _press.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hairline = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.10);
    final showFill = widget.filled || widget.backgroundColor != null;

    final fill = widget.backgroundColor ??
        (widget.filled
            ? (isDark ? AppColors.surfaceDark : AppColors.paperSurface)
            : Colors.transparent);

    final hoverTint = widget.onTap == null || !_hovered
        ? null
        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.035);

    Widget content = Padding(padding: widget.padding, child: widget.child);

    if (widget.accentColor != null) {
      content = IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: widget.accentColor),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Padding(padding: widget.padding, child: widget.child)),
          ],
        ),
      );
    }

    final block = Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        color: hoverTint ?? fill,
        borderRadius: showFill
            ? BorderRadius.circular(AppRadius.card)
            : BorderRadius.zero,
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!)
            : (widget.rule && !showFill
                ? Border(bottom: BorderSide(color: hairline))
                : null),
      ),
      child: content,
    );

    if (widget.onTap == null) return block;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _press.animateTo(0.988, curve: Curves.easeOutQuad),
        onTapUp: (_) {
          _press.animateTo(1.0, curve: Curves.easeOutBack);
          widget.onTap?.call();
        },
        onTapCancel: () => _press.animateTo(1.0, curve: Curves.easeOutBack),
        child: ScaleTransition(scale: _press, child: block),
      ),
    );
  }
}
