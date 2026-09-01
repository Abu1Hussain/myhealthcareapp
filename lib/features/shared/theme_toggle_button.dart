library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/theme/app_motion.dart';
import 'package:myhealth_ai/app/theme/reduced_motion.dart';
import 'package:myhealth_ai/app/theme/theme_mode_controller.dart';

/// Compact light/dark toggle for app bars — a single tap flips the app's
/// effective brightness with an animated sun/moon crossfade + rotation.
class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isDark = mode == ThemeMode.dark ||
        (mode == ThemeMode.system && platformBrightness == Brightness.dark);
    final reduce = shouldReduceMotion(context);

    return IconButton(
      tooltip: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      onPressed: () => ref.read(themeModeProvider.notifier).toggle(platformBrightness),
      icon: AnimatedSwitcher(
        duration: reduce ? Duration.zero : AppMotion.themeSwitch,
        switchInCurve: AppMotion.easeOut,
        switchOutCurve: AppMotion.easeOut,
        transitionBuilder: (child, animation) {
          if (reduce) {
            return FadeTransition(opacity: animation, child: child);
          }
          return RotationTransition(
            turns: Tween<double>(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: AppMotion.easeOut),
            ),
            child: FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: AppMotion.easeOut),
                ),
                child: child,
              ),
            ),
          );
        },
        child: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          key: ValueKey(isDark),
        ),
      ),
    );
  }
}

/// Three-way Light / Dark / System selector for a settings screen.
class ThemeModeSelector extends ConsumerWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);

    return SegmentedButton<ThemeMode>(
      segments: const [
        ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode_rounded, size: 18), label: Text('Light')),
        ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode_rounded, size: 18), label: Text('Dark')),
        ButtonSegment(value: ThemeMode.system, icon: Icon(Icons.brightness_auto_rounded, size: 18), label: Text('Auto')),
      ],
      selected: {mode},
      onSelectionChanged: (selection) {
        ref.read(themeModeProvider.notifier).setMode(selection.first);
      },
    );
  }
}
