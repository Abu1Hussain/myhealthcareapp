library;

import 'package:flutter/material.dart';

/// Waterfall reveal for list and grid items.
///
/// The old 25ms step was too tight to read as a cascade — items effectively
/// arrived together. 70ms with a spring-weighted curve reads as one
/// deliberate sweep down the list, which is what the motion was for.
class StaggeredFadeSlide extends StatelessWidget {
  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.child,
    this.baseDelayMs = 70,
    this.maxDelayMs = 420,
    this.slideDistance = 16.0,
  });

  final int index;
  final Widget child;
  final int baseDelayMs;
  final int maxDelayMs;
  final double slideDistance;

  static const Curve _curve = Cubic(0.19, 0.86, 0.24, 1);

  @override
  Widget build(BuildContext context) {
    final durationMs = 420 + (index * baseDelayMs).clamp(0, maxDelayMs);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: durationMs),
      curve: _curve,
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
