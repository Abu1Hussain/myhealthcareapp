import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MyHealth AI type scale — Broadsheet.
///
/// Source Serif 4 sets everything: headings, body, labels and clinical
/// figures. The system forbids introducing a sans-serif for interface
/// chrome — the serif *is* the chrome — so the former Outfit / JetBrains
/// Mono pairing is gone.
///
/// [mono] and [monoSmall] survive by name because screens call them, but
/// they now return the serif with tabular figures, which columns just as
/// cleanly as a monospace face.
abstract final class AppTypography {
  static const List<FontFeature> _tabular = [FontFeature.tabularFigures()];

  // ── Display ────────────────────────────────────────────────────────
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 46,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.4,
        height: 1.05,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 36,
        fontWeight: FontWeight.w600,
        letterSpacing: -1.0,
        height: 1.08,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle displaySmall(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.7,
        height: 1.12,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Headings ───────────────────────────────────────────────────────
  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
        height: 1.15,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.2,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineSmall(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.25,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Body ───────────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.55,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// The serif's true italic — pull quotes, AI prose, clinical emphasis.
  /// Never a synthesised oblique.
  static TextStyle bodyItalic(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.italic,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Labels ─────────────────────────────────────────────────────────
  static TextStyle labelLarge(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.35,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.35,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // ── Clinical figures (was monospace) ───────────────────────────────
  static TextStyle mono(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.45,
        fontFeatures: _tabular,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle monoSmall(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 11.5,
        fontWeight: FontWeight.w400,
        height: 1.4,
        fontFeatures: _tabular,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// Large tabular figure for a screen's one headline number.
  static TextStyle figure(BuildContext context, {double size = 44}) =>
      GoogleFonts.sourceSerif4(
        fontSize: size,
        fontWeight: FontWeight.w600,
        height: 1.02,
        letterSpacing: -1.0,
        fontFeatures: _tabular,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Eyebrow / section kicker ───────────────────────────────────────
  static TextStyle eyebrow(BuildContext context) => GoogleFonts.sourceSerif4(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        height: 1.35,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );
}
