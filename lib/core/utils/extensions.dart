import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_theme_extension.dart';
import '../../l10n/app_localizations.dart';

extension StringX on String {
  String get capitalized =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

extension BuildContextL10n on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String get localeName => l10n.localeName;
}

extension AppThemeX on BuildContext {
  AppThemeExtension get appColors =>
      Theme.of(this).extension<AppThemeExtension>()!;
}

extension AppTextStylesX on BuildContext {
  TextStyle get tsHeadlineLarge =>
      AppTextStyles.headlineLarge.copyWith(color: appColors.textPrimary);
  TextStyle get tsHeadlineMedium =>
      AppTextStyles.headlineMedium.copyWith(color: appColors.textPrimary);
  TextStyle get tsTitleLarge =>
      AppTextStyles.titleLarge.copyWith(color: appColors.textPrimary);
  TextStyle get tsTitleMedium =>
      AppTextStyles.titleMedium.copyWith(color: appColors.textPrimary);
  TextStyle get tsBodyLarge =>
      AppTextStyles.bodyLarge.copyWith(color: appColors.textPrimary);
  TextStyle get tsBodyMedium =>
      AppTextStyles.bodyMedium.copyWith(color: appColors.textSecondary);
  TextStyle get tsLabelLarge =>
      AppTextStyles.labelLarge.copyWith(color: appColors.textPrimary);
  TextStyle get tsLabelSmall =>
      AppTextStyles.labelSmall.copyWith(color: appColors.textTertiary);
  TextStyle get tsStatValue =>
      AppTextStyles.statValue.copyWith(color: appColors.accent);
  TextStyle get tsStatLabel =>
      AppTextStyles.statLabel.copyWith(color: appColors.textTertiary);
}
