library;

import 'package:flutter/material.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';

/// Adaptive semantic color accessors for [BuildContext].
///
/// Many tokens in [AppColors] are split into explicit `xLight` / `xDark`
/// variants. Reaching for the `Light` variant directly from a screen is a
/// common source of bugs — the color silently stops adapting to dark mode.
/// These getters resolve the correct value for the active [Brightness] so
/// every screen respects the system theme consistently.
extension AdaptiveColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  /// Primary body/title text. Mirrors [ColorScheme.onSurface].
  Color get textPrimary => Theme.of(this).colorScheme.onSurface;

  /// Secondary/description text. Mirrors [ColorScheme.onSurfaceVariant].
  Color get textSecondary => Theme.of(this).colorScheme.onSurfaceVariant;

  /// Tertiary text — timestamps, disabled labels, placeholder icons.
  Color get textTertiary =>
      _isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight;

  /// Hairline borders & dividers. Mirrors [ColorScheme.outline].
  Color get borderColor => Theme.of(this).colorScheme.outline;

  /// Card/container fill. Mirrors [ColorScheme.surface].
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// Subtly-elevated fill used for chips, inset rows, and bezel shells.
  Color get surfaceElevated =>
      _isDark ? AppColors.surfaceElevatedDark : AppColors.surfaceElevatedLight;

  /// Page canvas background, also useful for inset content wells inside cards.
  Color get canvasColor => _isDark ? AppColors.canvasDark : AppColors.canvasLight;

  /// AI-surface tint used behind AI-generated content and safety banners.
  Color get aiSurface => _isDark ? AppColors.aiSurfaceDark : AppColors.aiSurfaceLight;

  /// Border color paired with [aiSurface].
  Color get aiBorder => _isDark ? AppColors.aiBorderDark : AppColors.aiBorderLight;
}
