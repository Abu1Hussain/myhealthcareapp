library;

import 'package:flutter/material.dart';

/// Staggered waterfall reveal container for list and grid items.
///
/// Implements DESIGN.md §8 (Motion intent: waterfall entry with dynamic stagger)
/// and the animate skill guidelines for smooth UI mounting.
class StaggeredFadeSlide extends StatelessWidget {
  const StaggeredFadeSlide({
    super.key,
    required this.index,
    required this.child,
    this.baseDelayMs = 25,
    this.maxDelayMs = 350,
    this.slideDistance = 14.0,
  });

  final int index;
  final Widget child;
  final int baseDelayMs;
  final int maxDelayMs;
  final double slideDistance;

  @override
  Widget build(BuildContext context) {
    final computedDurationMs = 240 + (index * baseDelayMs).clamp(0, maxDelayMs);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: computedDurationMs),
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) {
        return Opacity(
          opacity: progress,
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
