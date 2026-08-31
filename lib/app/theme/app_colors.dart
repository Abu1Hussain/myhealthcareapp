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

  // ── Badge text-on-tint shades ────────────────────────────────────────
  // ClinicalBadge renders small (11px) text on a ~12.5%-alpha fill of the
  // matching accent color. Small text needs a real WCAG AA ratio of
  // >=4.5:1 against what actually renders (the accent composited onto the
  // card surface), not against the accent color alone — the plain accent
  // constants above fall short of that (verified: e.g. success/warning
  // land at ~2.0-2.5:1 on their own light-mode tint). These pairs were
  // derived by adjusting lightness until the *composited* tint reaches
  // >=4.5:1, checked separately for light and dark surfaces since the two
  // directions (darken vs. lighten) diverge.
  static const Color successTextLight = Color(0xFF0A7753);   // 4.64:1 on its own light tint
  static const Color successTextDark = Color(0xFF10B981);    // 4.70:1 on its own dark tint
  static const Color warningTextLight = Color(0xFF945F06);   // 4.54:1
  static const Color warningTextDark = Color(0xFFF59E0B);    // 5.48:1
  static const Color criticalTextLight = Color(0xFFCB1111);  // 4.65:1
  static const Color criticalTextDark = Color(0xFFF37878);   // 4.50:1
  static const Color infoTextLight = Color(0xFF0B5FE9);      // 4.56:1
  static const Color infoTextDark = Color(0xFF6CA1F8);       // 4.55:1
  static const Color primaryTextLight = Color(0xFF0A736A);   // 4.77:1
  static const Color primaryTextDark = Color(0xFF10B5A6);    // 4.64:1
  static const Color aiTextLight = Color(0xFF763FF4);        // 4.60:1
  static const Color aiTextDark = Color(0xFFB191F9);         // 4.66:1
}
