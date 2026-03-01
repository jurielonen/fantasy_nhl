import 'package:flutter/material.dart';

import 'app_colors.dart';

@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  final Color background;
  final Color surface;
  final Color surfaceVariant;
  final Color accent;
  final Color accentDim;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color success;
  final Color warning;
  final Color error;
  final Color border;

  const AppThemeExtension({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.accent,
    required this.accentDim,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.success,
    required this.warning,
    required this.error,
    required this.border,
  });

  static const dark = AppThemeExtension(
    background: AppColors.background,
    surface: AppColors.surface,
    surfaceVariant: AppColors.surfaceVariant,
    accent: AppColors.accent,
    accentDim: AppColors.accentDim,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    border: AppColors.border,
  );

  static const light = AppThemeExtension(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    surfaceVariant: AppColors.lightSurfaceVariant,
    accent: AppColors.accentDim,
    accentDim: AppColors.accentDim,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    textTertiary: AppColors.lightTextTertiary,
    success: AppColors.lightSuccess,
    warning: AppColors.lightWarning,
    error: AppColors.error,
    border: AppColors.lightBorder,
  );

  @override
  AppThemeExtension copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? accent,
    Color? accentDim,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? success,
    Color? warning,
    Color? error,
    Color? border,
  }) {
    return AppThemeExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      accent: accent ?? this.accent,
      accentDim: accentDim ?? this.accentDim,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      border: border ?? this.border,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDim: Color.lerp(accentDim, other.accentDim, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
