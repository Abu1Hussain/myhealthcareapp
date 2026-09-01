library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_motion.dart';
import 'package:myhealth_ai/app/theme/reduced_motion.dart';

/// Waterfall reveal for list and grid items.
///
/// Items enter with a gentle opacity fade and subtle slide up.
/// Total animation duration is strictly capped at [AppMotion.staggerMaxDurationMs]
/// so even long feeds with 20+ items finish animating promptly.
/// When [shouldReduceMotion] is true, position movement is bypassed.
class StaggeredFadeSlide extends StatelessWidget {
  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.child,
    this.baseDelayMs = AppMotion.staggerStepMs,
    this.slideDistance = AppMotion.staggerSlideDistance,
  });

  final int index;
  final Widget child;
  final int baseDelayMs;
  final double slideDistance;

  @override
  Widget build(BuildContext context) {
    if (shouldReduceMotion(context)) {
      return child;
    }

    final durationMs = (AppMotion.staggerBaseMs + (index * baseDelayMs))
        .clamp(AppMotion.staggerBaseMs, AppMotion.staggerMaxDurationMs);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: durationMs),
      curve: AppMotion.easeOut,
      builder: (context, progress, child) {
        return Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, slideDistance * (1.0 - progress)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
