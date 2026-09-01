library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_motion.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';
import 'package:myhealth_ai/app/theme/reduced_motion.dart';

/// Loading placeholder at the real layout dimensions. Never a spinner.
///
/// Retuned onto the neutral ramp: on paper the wipe is a shift in ink
/// density, not a coloured sweep.
class SkeletalShimmer extends StatefulWidget {
  const SkeletalShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadius.md,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletalShimmer> createState() => _SkeletalShimmerState();
}

class _SkeletalShimmerState extends State<SkeletalShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  )..repeat();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.surfaceDark : AppColors.neutral200;
    final highlight = isDark ? AppColors.surfaceElevatedDark : AppColors.neutral300;

    if (shouldReduceMotion(context)) {
      return Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      );
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final v = _animation.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [base, highlight, base],
              stops: [
                (v - 0.3).clamp(0.0, 1.0),
                v.clamp(0.0, 1.0),
                (v + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
