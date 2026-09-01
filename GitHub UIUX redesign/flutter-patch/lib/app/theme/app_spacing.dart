library;

import 'package:flutter/material.dart';

/// Spacing, radius and elevation tokens — Broadsheet.
///
/// The system's own 1.25x scale (5 / 10 / 15 / 20 / 30 / 40) replaces the
/// old 4pt grid, and radii collapse to 1 / 2 / 4: this is printed matter,
/// not a stack of rounded cards. Member names are unchanged so existing
/// screens keep compiling.
abstract final class AppSpacing {
  static const double xxs = 2.5;
  static const double xs = 5.0;
  static const double sm = 10.0;
  static const double md = 15.0;
  static const double lg = 20.0;
  static const double xl = 25.0;
  static const double xxl = 30.0;
  static const double xxxl = 40.0;
  static const double huge = 50.0;
  static const double massive = 60.0;

  // ── Page rhythm ────────────────────────────────────────────────────
  static const double sectionGap = 40.0;
  static const double pagePadding = 20.0;
  static const double pageHorizontal = 20.0;

  // ── Row internals ──────────────────────────────────────────────────
  static const double cardPadding = 15.0;
  static const double cardGap = 15.0;

  /// Vertical padding for a hairline-separated list row.
  static const double rowVertical = 15.0;
}

abstract final class AppRadius {
  static const double xs = 1.0;
  static const double sm = 1.0;
  static const double md = 2.0;
  static const double lg = 4.0;
  static const double xl = 4.0;
  static const double xxl = 4.0;

  /// Kept for avatars and any genuinely circular affordance.
  static const double full = 999.0;

  static const double card = 2.0;
}

abstract final class AppElevation {
  /// Broadsheet --shadow-sm. The page is paper; almost nothing floats.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x242D2B2B),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> subtleShadow = [];

  /// --shadow-md, for the one genuinely floating layer (dialogs, sheets).
  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x292D2B2B),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];
}
