import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myhealth_ai/app/router.dart';
import 'package:myhealth_ai/app/theme/app_theme.dart';
import 'package:myhealth_ai/app/theme/theme_mode_controller.dart';

/// Root application widget watching Riverpod router.
class MyHealthApp extends ConsumerWidget {
  const MyHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'MyHealth AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
