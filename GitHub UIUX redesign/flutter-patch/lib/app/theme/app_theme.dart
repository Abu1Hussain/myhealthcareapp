import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myhealth_ai/app/theme/app_colors.dart';
import 'package:myhealth_ai/app/theme/app_spacing.dart';

/// MyHealth AI theme builder — Broadsheet.
///
/// Paper ground, ink text, cyan as the single interactive accent, 2px radii
/// and hairline dividers. Filled surfaces are used sparingly: hierarchy
/// comes from the serif scale and from whitespace.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.cyanInk,
      brightness: Brightness.light,
      primary: AppColors.cyanInk,
      onPrimary: AppColors.paper,
      secondary: AppColors.accent700,
      onSecondary: AppColors.paper,
      surface: AppColors.paper,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      surfaceContainerHighest: AppColors.paperSurface,
      error: AppColors.magentaInk,
      onError: AppColors.paper,
      outline: AppColors.borderLight,
    );

    return _buildTheme(colorScheme, Brightness.light);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.cyanInk,
      brightness: Brightness.dark,
      primary: AppColors.accent400,
      onPrimary: AppColors.canvasDark,
      secondary: AppColors.accent300,
      onSecondary: AppColors.canvasDark,
      surface: AppColors.canvasDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      surfaceContainerHighest: AppColors.surfaceDark,
      error: AppColors.accent2400,
      onError: AppColors.canvasDark,
      outline: AppColors.borderDark,
    );

    return _buildTheme(colorScheme, Brightness.dark);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = GoogleFonts.sourceSerif4TextTheme(
      isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    final surfaceFill = isDark ? AppColors.surfaceDark : AppColors.paperSurface;
    final hairline = colorScheme.onSurface.withValues(alpha: 0.16);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark ? AppColors.canvasDark : AppColors.paper,
      splashFactory: InkSparkle.splashFactory,

      // ── AppBar — a masthead, not a bar ─────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: AppSpacing.lg,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.4,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 22),
      ),

      // ── Cards — flat blocks, hairline edge, no float ───────────────
      cardTheme: CardThemeData(
        color: surfaceFill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Inputs — label above, surface fill, accent focus rule ──────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: hairline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: hairline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        labelStyle: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: textTheme.bodySmall?.copyWith(
          fontSize: 12,
          color: colorScheme.primary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
        ),
      ),

      // ── Primary action — solid accent fill, tactile press ──────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return isDark ? AppColors.accent300 : AppColors.accent700;
            }
            if (states.contains(WidgetState.hovered)) {
              return isDark ? AppColors.accent300 : AppColors.accent600;
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(colorScheme.onPrimary),
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
          textStyle: WidgetStatePropertyAll(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ),

      // ── Secondary action — hairline outline, ink label ─────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
          overlayColor: WidgetStatePropertyAll(
            colorScheme.onSurface.withValues(alpha: 0.07),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(0, 46)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
          side: WidgetStatePropertyAll(BorderSide(color: hairline)),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            isDark ? AppColors.accent300 : AppColors.accent700,
          ),
          overlayColor: WidgetStatePropertyAll(
            AppColors.cyanInk.withValues(alpha: 0.10),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          ),
          minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(colorScheme.onSurface),
          minimumSize: const WidgetStatePropertyAll(Size(44, 44)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          ),
        ),
      ),

      // ── Bottom navigation — paper, hairline top rule ───────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.canvasDark : AppColors.paper,
        selectedItemColor: isDark ? AppColors.accent300 : AppColors.accent700,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? AppColors.canvasDark : AppColors.paper,
        elevation: 0,
        indicatorColor: AppColors.cyanInk.withValues(alpha: 0.12),
        selectedIconTheme: IconThemeData(
          color: isDark ? AppColors.accent300 : AppColors.accent700,
        ),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
        selectedLabelTextStyle: textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.accent300 : AppColors.accent700,
        ),
        unselectedLabelTextStyle: textTheme.labelSmall,
      ),

      // ── Filter chips — squared, tinted from the ramp ───────────────
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: isDark ? AppColors.accent800 : AppColors.accent100,
        labelStyle: textTheme.labelMedium?.copyWith(fontSize: 13),
        secondaryLabelStyle: textTheme.labelMedium?.copyWith(
          fontSize: 13,
          color: isDark ? AppColors.accent200 : AppColors.accent800,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: hairline),
        ),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: AppSpacing.xs),
        titleTextStyle: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        subtitleTextStyle: textTheme.bodySmall,
        iconColor: colorScheme.onSurfaceVariant,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.surface),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: surfaceFill,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        titleTextStyle: textTheme.headlineMedium,
        contentTextStyle: textTheme.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.canvasDark : AppColors.paper,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearMinHeight: 3,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
