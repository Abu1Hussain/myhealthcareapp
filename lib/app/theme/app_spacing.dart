library;

import 'package:flutter/material.dart';

/// MyHealth AI spacing & radius design tokens.
///
/// Consistent spacing prevents magic numbers throughout the codebase
/// (flutter-dart-code-review §3: spacing uses design tokens, not magic numbers).
/// Generous padding following DESIGN.md §4 and high-end-visual-design §4C.


abstract final class AppSpacing {
  // ── Base scale (4pt grid) ──────────────────────────────────────────
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double huge = 40.0;
  static const double massive = 48.0;

  // ── Section spacing (generous, premium feel) ───────────────────────
  static const double sectionGap = 64.0;
  static const double pagePadding = 24.0;
  static const double pageHorizontal = 20.0;

  // ── Card internals ─────────────────────────────────────────────────
  static const double cardPadding = 20.0;
  static const double cardGap = 16.0;
}

abstract final class AppRadius {
  // ── Border radii ───────────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double full = 999.0; // pill shape
  
  // ── Card radius (DESIGN.md §4: generously rounded 2.5rem ≈ 40px) ──
  static const double card = 20.0;
}

abstract final class AppElevation {
  // ── Shadows (DESIGN.md §2: diffused, never harsh) ──────────────────
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D000000), // rgba(0,0,0,0.05)
      blurRadius: 40,
      offset: Offset(0, 20),
      spreadRadius: -15,
    ),
  ];

  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x08000000), // rgba(0,0,0,0.03)
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: -4,
    ),
  ];

  static const List<BoxShadow> floatingShadow = [
    BoxShadow(
      color: Color(0x14000000), // rgba(0,0,0,0.08)
      blurRadius: 60,
      offset: Offset(0, 24),
      spreadRadius: -12,
    ),
  ];
}
