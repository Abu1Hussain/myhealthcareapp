import 'package:flutter/material.dart';

/// MyHealth AI colour system — Broadsheet.
///
/// Two inks on paper. Cyan carries every interactive element; magenta is the
/// rarer second spot colour and is reserved for genuine clinical alarm.
/// Everything that used to be a semantic hue (success, warning, info, risk
/// bands) now resolves to a step on the neutral ramp, so status reads as
/// weight rather than as another colour competing for attention.
///
/// The legacy member names (primaryTeal, success, aiAccent…) are kept
/// deliberately: they are referenced across 24 screens, and repointing the
/// values here recolours the whole app without touching call sites.
abstract final class AppColors {
  // ── Broadsheet ground and ink ──────────────────────────────────────
  static const Color paper = Color(0xFFF3F2F2);
  static const Color paperSurface = Color(0xFFEAE9E9);
  static const Color ink = Color(0xFF201E1D);
  static const Color cyanInk = Color(0xFF0088B0);
  static const Color magentaInk = Color(0xFFD6006C);

  // ── Neutral ramp (OKLCH, one shared lightness scale) ───────────────
  static const Color neutral100 = Color(0xFFF8F4F4);
  static const Color neutral200 = Color(0xFFEAE7E7);
  static const Color neutral300 = Color(0xFFD7D3D3);
  static const Color neutral400 = Color(0xFFBAB6B6);
  static const Color neutral500 = Color(0xFF9B9797);
  static const Color neutral600 = Color(0xFF7D7979);
  static const Color neutral700 = Color(0xFF605D5D);
  static const Color neutral800 = Color(0xFF444141);
  static const Color neutral900 = Color(0xFF2D2B2B);

  // ── Accent ramp — cyan, the interactive ink ────────────────────────
  static const Color accent100 = Color(0xFFE9F8FF);
  static const Color accent200 = Color(0xFFCBEEFF);
  static const Color accent300 = Color(0xFF99E0FF);
  static const Color accent400 = Color(0xFF62C5EE);
  static const Color accent500 = Color(0xFF38A6CF);
  static const Color accent600 = Color(0xFF1186AC);
  static const Color accent700 = Color(0xFF006786);
  static const Color accent800 = Color(0xFF004961);
  static const Color accent900 = Color(0xFF0A303E);

  // ── Second accent ramp — magenta, alarm only ───────────────────────
  static const Color accent2100 = Color(0xFFFFF1F4);
  static const Color accent2200 = Color(0xFFFFDEE6);
  static const Color accent2300 = Color(0xFFFFC0D0);
  static const Color accent2400 = Color(0xFFFF90B1);
  static const Color accent2500 = Color(0xFFFF458E);
  static const Color accent2600 = Color(0xFFD82071);
  static const Color accent2700 = Color(0xFFAA0B56);
  static const Color accent2800 = Color(0xFF790E3D);
  static const Color accent2900 = Color(0xFF4B1528);

  // ── Primary accent (legacy names, cyan values) ─────────────────────
  static const Color primaryTeal = cyanInk;
  static const Color primaryTealLight = accent500;
  static const Color primaryTealDark = accent700;
  static const Color primaryTealSurface = accent100;

  // ── Semantic status ────────────────────────────────────────────────
  // Only 'critical' takes the second ink. The rest are grey: a completed
  // appointment and a pending task do not need to compete with an alarm.
  static const Color success = neutral600;
  static const Color warning = neutral700;
  static const Color critical = magentaInk;
  static const Color info = neutral600;

  // ── Surfaces (light) ───────────────────────────────────────────────
  static const Color canvasLight = paper;
  static const Color surfaceLight = paper;
  static const Color surfaceElevatedLight = paperSurface;

  // ── Surfaces (dark) ────────────────────────────────────────────────
  // Broadsheet publishes no dark ground; this is a documented extension —
  // the same ramp read from the other end.
  static const Color canvasDark = Color(0xFF1B1A19);
  static const Color surfaceDark = Color(0xFF262322);
  static const Color surfaceElevatedDark = Color(0xFF322F2E);

  // ── Text (light) ───────────────────────────────────────────────────
  static const Color textPrimaryLight = ink;
  static const Color textSecondaryLight = neutral700;
  static const Color textTertiaryLight = neutral500;

  // ── Text (dark) ────────────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF1EEED);
  static const Color textSecondaryDark = neutral400;
  static const Color textTertiaryDark = neutral600;

  // ── Borders and dividers ───────────────────────────────────────────
  static const Color borderLight = Color(0xFFD5D2D1);
  static const Color borderDark = Color(0xFF3D3A39);

  // ── Risk bands — one tonal wedge, not three hues ───────────────────
  static const Color riskLow = neutral300;
  static const Color riskMedium = neutral500;
  static const Color riskHigh = neutral800;

  // ── AI surfaces ────────────────────────────────────────────────────
  // No violet. AI provenance is stated in words and in the audit footer;
  // it does not need a colour of its own.
  static const Color aiAccent = accent700;
  static const Color aiSurfaceLight = paperSurface;
  static const Color aiSurfaceDark = Color(0xFF262322);
  static const Color aiBorderLight = borderLight;
  static const Color aiBorderDark = borderDark;

  // ── Badge text-on-tint pairs ───────────────────────────────────────
  // Every badge is now a 100-step ground carrying 800-step ink (inverted
  // in dark mode), which clears WCAG AA for 11px text with room to spare —
  // so the hand-tuned per-hue shades this section used to hold are gone.
  static const Color successTextLight = neutral800;
  static const Color successTextDark = neutral300;
  static const Color warningTextLight = neutral900;
  static const Color warningTextDark = neutral300;
  static const Color criticalTextLight = accent2800;
  static const Color criticalTextDark = accent2300;
  static const Color infoTextLight = neutral800;
  static const Color infoTextDark = neutral300;
  static const Color primaryTextLight = accent800;
  static const Color primaryTextDark = accent300;
  static const Color aiTextLight = accent800;
  static const Color aiTextDark = accent300;
}
