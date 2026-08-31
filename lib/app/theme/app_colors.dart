import 'package:flutter/material.dart';

/// MyHealth AI color system.
///
/// Clinical palette: surgical teal accent for health context, warm neutrals
/// for surfaces, zinc-based grays for text hierarchy (DESIGN.md §2).
/// No pure black — off-black Zinc-950 only (DESIGN.md §9 anti-patterns).
/// No oversaturated neons (high-end-visual-design §2 banned).
abstract final class AppColors {
  // ── Primary Accent: Surgical Teal ──────────────────────────────────
  static const Color primaryTeal = Color(0xFF0D9488);       // teal-600
  static const Color primaryTealLight = Color(0xFF14B8A6);  // teal-500
  static const Color primaryTealDark = Color(0xFF0F766E);   // teal-700
  static const Color primaryTealSurface = Color(0xFFF0FDFA); // teal-50

  // ── Semantic: Status colors ────────────────────────────────────────
  static const Color success = Color(0xFF10B981);     // emerald-500
  static const Color warning = Color(0xFFF59E0B);     // amber-500
  static const Color critical = Color(0xFFEF4444);    // red-500
  static const Color info = Color(0xFF3B82F6);        // blue-500

  // ── Surfaces (Light) ───────────────────────────────────────────────
  static const Color canvasLight = Color(0xFFF9FAFB);       // warm neutral bg
  static const Color surfaceLight = Color(0xFFFFFFFF);      // card fill
  static const Color surfaceElevatedLight = Color(0xFFF3F4F6); // subtle elevation

  // ── Surfaces (Dark) ────────────────────────────────────────────────
  static const Color canvasDark = Color(0xFF0F172A);        // slate-900
  static const Color surfaceDark = Color(0xFF1E293B);       // slate-800
  static const Color surfaceElevatedDark = Color(0xFF334155); // slate-700

  // ── Text (Light mode) ──────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF18181B);  // zinc-950 (off-black)
  static const Color textSecondaryLight = Color(0xFF71717A); // zinc-500
  static const Color textTertiaryLight = Color(0xFF94A3B8);  // slate-400

  // ── Text (Dark mode) ───────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF4F4F5);   // zinc-100
  static const Color textSecondaryDark = Color(0xFFA1A1AA);  // zinc-400
  static const Color textTertiaryDark = Color(0xFF64748B);   // slate-500

  // ── Borders & Dividers ─────────────────────────────────────────────
  static const Color borderLight = Color(0xFFE2E8F0);  // slate-200
  static const Color borderDark = Color(0xFF334155);    // slate-700

  // ── Risk bands (for no-show & clinical risk badges) ────────────────
  static const Color riskLow = Color(0xFF10B981);
  static const Color riskMedium = Color(0xFFF59E0B);
  static const Color riskHigh = Color(0xFFEF4444);

  // ── AI surface accent ──────────────────────────────────────────────
  static const Color aiAccent = Color(0xFF8B5CF6);      // violet-500 (AI marker)
  static const Color aiSurfaceLight = Color(0xFFF5F3FF); // violet-50
  static const Color aiSurfaceDark = Color(0xFF1E1B4B);  // indigo-950
  static const Color aiBorderLight = Color(0xFFE2E8F0);
  static const Color aiBorderDark = Color(0xFF4C1D95);
}
