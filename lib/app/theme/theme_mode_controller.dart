library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _kThemeModeKey = 'app_theme_mode';

/// Persists and exposes the user's chosen [ThemeMode].
///
/// Defaults to [ThemeMode.system] on first run, then remembers whatever
/// the user picks (light/dark/system) across restarts via
/// [SharedPreferences] — the same mechanism the app already uses for
/// session persistence.
class ThemeModeController extends StateNotifier<ThemeMode> {
  ThemeModeController() : super(ThemeMode.system) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kThemeModeKey);
      switch (saved) {
        case 'light':
          state = ThemeMode.light;
        case 'dark':
          state = ThemeMode.dark;
        case 'system':
          state = ThemeMode.system;
      }
    } catch (_) {
      // Keep the system default if preferences are unavailable.
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kThemeModeKey, mode.name);
    } catch (_) {
      // Non-fatal: the in-memory state still updates for this session.
    }
  }

  /// Toggles between explicit light and dark, resolving [ThemeMode.system]
  /// against the current platform brightness first so a single tap always
  /// does the intuitive thing regardless of the starting mode.
  Future<void> toggle(Brightness platformBrightness) async {
    final isCurrentlyDark = state == ThemeMode.dark ||
        (state == ThemeMode.system && platformBrightness == Brightness.dark);
    await setMode(isCurrentlyDark ? ThemeMode.light : ThemeMode.dark);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeController, ThemeMode>((ref) {
  return ThemeModeController();
});
