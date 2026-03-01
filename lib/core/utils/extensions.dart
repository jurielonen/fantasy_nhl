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

  // Group A — table/list column headers (11px w600)
  TextStyle get tsTableHeader =>
      AppTextStyles.tableHeader.copyWith(color: appColors.textTertiary);
  TextStyle get tsTableHeaderSecondary =>
      AppTextStyles.tableHeader.copyWith(color: appColors.textSecondary);

  // Group B — small body text (12px)
  TextStyle get tsBodySmall =>
      AppTextStyles.bodySmall.copyWith(color: appColors.textPrimary);
  TextStyle get tsBodySmallSecondary =>
      AppTextStyles.bodySmall.copyWith(color: appColors.textSecondary);
  TextStyle get tsBodySmallTertiary =>
      AppTextStyles.bodySmall.copyWith(color: appColors.textTertiary);
  TextStyle get tsBodySmallMedium =>
      AppTextStyles.bodySmallMedium.copyWith(color: appColors.textPrimary);
  TextStyle get tsBodySmallStrong =>
      AppTextStyles.bodySmallStrong.copyWith(color: appColors.textPrimary);
  TextStyle get tsBodySmallStrongSecondary =>
      AppTextStyles.bodySmallStrong.copyWith(color: appColors.textSecondary);

  // Group C — captions (11px normal)
  TextStyle get tsCaption =>
      AppTextStyles.caption.copyWith(color: appColors.textTertiary);
  TextStyle get tsCaptionSecondary =>
      AppTextStyles.caption.copyWith(color: appColors.textSecondary);

  // Group D — badge labels (10px bold) — color applied at call-site via copyWith
  TextStyle get tsBadgeLabel =>
      AppTextStyles.badgeLabel.copyWith(color: appColors.accent);

  // Group E — player name in tiles (15px w600)
  TextStyle get tsPlayerName =>
      AppTextStyles.playerName.copyWith(color: appColors.textPrimary);

  // Group F — score display (20px bold, textPrimary)
  TextStyle get tsScoreDisplay =>
      AppTextStyles.statValue.copyWith(color: appColors.textPrimary);

  // Group G — section title bold (18px bold)
  TextStyle get tsTitleLargeBold =>
      AppTextStyles.titleLargeBold.copyWith(color: appColors.textPrimary);

  // Chart axis ticks (9px)
  TextStyle get tsChartAxisLabel =>
      AppTextStyles.chartAxisLabel.copyWith(color: appColors.textTertiary);

  // Micro label (10px w500) — e.g. SOG separator
  TextStyle get tsMicroLabel =>
      AppTextStyles.microLabel.copyWith(color: appColors.textTertiary);

  // Chip label (11px bold) — e.g. day abbreviation in date chip
  TextStyle get tsChipLabel =>
      AppTextStyles.chipLabel.copyWith(color: appColors.textSecondary);

  // Label medium (13px w600) — e.g. future game opponent, category tabs
  TextStyle get tsLabelMedium =>
      AppTextStyles.labelMedium.copyWith(color: appColors.textPrimary);

  // Headshot circle fallback letter (32px bold)
  TextStyle get tsHeadshotFallback =>
      AppTextStyles.headshotFallback.copyWith(color: appColors.textSecondary);

  // Small stat value (16px bold) — e.g. trailing stat in player list tile
  TextStyle get tsStatValueSmall =>
      AppTextStyles.statValueSmall.copyWith(color: appColors.accent);
}
