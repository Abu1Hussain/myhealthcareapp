import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MyHealth AI typography scale.
///
/// Uses Outfit for all UI text — DESIGN.md §3 bans Inter for premium contexts.
/// high-end-visual-design skill §2 bans Inter, Roboto, Arial, Open Sans.
/// Track-tight display heads, relaxed body leading (1.65).
abstract final class AppTypography {
  // ── Display (hero headings) ────────────────────────────────────────
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.outfit(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        height: 1.1,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.15,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle displaySmall(BuildContext context) => GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Headings ───────────────────────────────────────────────────────
  static TextStyle headlineLarge(BuildContext context) => GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.25,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineMedium(BuildContext context) => GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.3,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle headlineSmall(BuildContext context) => GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: Theme.of(context).colorScheme.onSurface,
      );

  // ── Body ───────────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.65,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.6,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // ── Labels & Captions ──────────────────────────────────────────────
  static TextStyle labelLarge(BuildContext context) => GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle labelMedium(BuildContext context) => GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle labelSmall(BuildContext context) => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.8,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // ── Mono (metadata, timestamps, clinical data) ─────────────────────
  static TextStyle mono(BuildContext context) => GoogleFonts.jetBrainsMono(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  static TextStyle monoSmall(BuildContext context) => GoogleFonts.jetBrainsMono(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  // ── Eyebrow / Badge text ───────────────────────────────────────────
  static TextStyle eyebrow(BuildContext context) => GoogleFonts.outfit(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.0,
        height: 1.4,
        color: Theme.of(context).colorScheme.primary,
      );
}
