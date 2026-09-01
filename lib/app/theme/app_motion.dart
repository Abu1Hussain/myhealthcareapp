library;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

/// Centralized motion tokens for MyHealth AI — Broadsheet motion design.
///
/// Motion in Broadsheet is purposeful, fast, and restrained. UI animations stay
/// strictly under 300ms, entrances use strong ease-out curves, and list cascades
/// are capped to never block user interaction.
abstract final class AppMotion {
  // ── Curves ──────────────────────────────────────────────────────────
  /// Strong ease-out for UI entrances, reveals, and dialogs.
  /// Starts fast and settles smoothly.
  static const Curve easeOut = Cubic(0.23, 1.0, 0.32, 1.0);

  /// Strong ease-in-out for on-screen movement and morphing.
  static const Curve easeInOut = Cubic(0.77, 0.0, 0.175, 1.0);

  /// Smooth organic sinusoidal curve for subtle perpetual pulses.
  static const Curve easePulse = Curves.easeInOutSine;

  /// Tactile press down — instantaneous responsiveness.
  static const Curve easePress = Curves.easeOutQuad;

  /// Tactile press release — subtle spring settle.
  static const Curve easePressRelease = Curves.easeOutBack;

  // ── Durations ────────────────────────────────────────────────────────
  /// Press down tactile response time.
  static const Duration pressFeedback = Duration(milliseconds: 110);

  /// Press release tactile return time.
  static const Duration pressFeedbackReverse = Duration(milliseconds: 200);

  /// Micro-transitions: tooltips, small icons, quick toggles.
  static const Duration micro = Duration(milliseconds: 160);

  /// Standard UI transitions: dropdowns, tabs, segmented controls.
  static const Duration regular = Duration(milliseconds: 200);

  /// Theme toggle switcher transition.
  static const Duration themeSwitch = Duration(milliseconds: 280);

  /// Dialogs and modal sheets entrance.
  static const Duration modal = Duration(milliseconds: 280);

  /// Shimmer loading sweep cycle.
  static const Duration shimmer = Duration(milliseconds: 1600);

  /// Critical indicator pulse cycle.
  static const Duration pulse = Duration(milliseconds: 1900);

  // ── Stagger Constants ────────────────────────────────────────────────
  /// Base duration for the first item in a cascade.
  static const int staggerBaseMs = 380;

  /// Step delay per list item.
  static const int staggerStepMs = 60;

  /// Hard cap on list animation duration so long feeds never feel sluggish.
  static const int staggerMaxDurationMs = 680;

  /// Slide distance for staggered item entrances.
  static const double staggerSlideDistance = 14.0;
}
