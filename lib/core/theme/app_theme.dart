import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_theme_extension.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: AppColors.background,
      primaryContainer: AppColors.accentDim.withValues(alpha: 0.2),
      onPrimaryContainer: AppColors.accent,
      secondary: AppColors.accentDim,
      onSecondary: AppColors.background,
      secondaryContainer: AppColors.surfaceVariant,
      onSecondaryContainer: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      surfaceContainer: AppColors.surfaceVariant,
      surfaceContainerHigh: AppColors.surfaceVariant,
      outline: AppColors.border,
      outlineVariant: AppColors.border.withValues(alpha: 0.5),
      error: AppColors.error,
      onError: AppColors.textPrimary,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.background,
      inversePrimary: AppColors.accentDim,
      scrim: Colors.black,
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      extensions: [AppThemeExtension.dark as ThemeExtension<dynamic>],
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accent.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            );
          }
          return const TextStyle(fontSize: 12, color: AppColors.textTertiary);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accent);
          }
          return const IconThemeData(color: AppColors.textTertiary);
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.textTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.accent.withValues(alpha: 0.2),
        labelStyle: const TextStyle(color: AppColors.textPrimary),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: AppColors.accentDim,
      onPrimary: Colors.white,
      primaryContainer: AppColors.accentDim.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.accentDim,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.lightSurfaceVariant,
      onSecondaryContainer: AppColors.lightTextPrimary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      surfaceContainerHighest: AppColors.lightSurfaceVariant,
      surfaceContainer: AppColors.lightSurfaceVariant,
      surfaceContainerHigh: AppColors.lightSurfaceVariant,
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorder.withValues(alpha: 0.5),
      error: AppColors.error,
      onError: Colors.white,
      inverseSurface: AppColors.lightTextPrimary,
      onInverseSurface: AppColors.lightSurface,
      inversePrimary: AppColors.accentDim,
      scrim: Colors.black,
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      extensions: [AppThemeExtension.light as ThemeExtension<dynamic>],
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.lightSurface,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.lightSurface,
        indicatorColor: AppColors.accentDim.withValues(alpha: 0.15),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accentDim,
            );
          }
          return const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentDim);
          }
          return const IconThemeData(color: AppColors.lightTextSecondary);
        }),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(color: AppColors.lightTextTertiary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurfaceVariant,
        selectedColor: AppColors.accentDim.withValues(alpha: 0.15),
        labelStyle: const TextStyle(color: AppColors.lightTextPrimary),
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
