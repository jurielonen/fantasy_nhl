import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../domain/entities/game_log_entry.dart';

class GameLogTab extends StatelessWidget {
  final AsyncValue<List<GameLogEntry>> gameLogAsync;
  final VoidCallback? onRetry;

  const GameLogTab({super.key, required this.gameLogAsync, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return gameLogAsync.when(
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, _) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ShimmerLoader(height: 48),
          ),
          childCount: 10,
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        child: AppErrorWidget(
          message: context.l10n.gameLogFailedToLoad,
          onRetry: onRetry,
        ),
      ),
      data: (entries) {
        if (entries.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                context.l10n.gameLogEmpty,
                style: context.tsBodyMedium,
              ),
            ),
          );
        }

        final isGoalie = entries.first.isGoalie;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index == 0) {
              return _GameLogHeader(isGoalie: isGoalie);
            }
            final entry = entries[index - 1];
            return _GameLogRow(entry: entry, isGoalie: isGoalie);
          }, childCount: entries.length + 1),
        );
      },
    );
  }
}

class _GameLogHeader extends StatelessWidget {
  final bool isGoalie;
  const _GameLogHeader({required this.isGoalie});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.appColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(context.l10n.gameLogDate, style: context.tsTableHeader),
          ),
          SizedBox(
            width: 56,
            child: Text(context.l10n.gameLogOpp, style: context.tsTableHeader),
          ),
          if (isGoalie) ...[
            SizedBox(
              width: 32,
              child: Text(
                context.l10n.gameLogDec,
                style: context.tsTableHeader,
              ),
            ),
            SizedBox(
              width: 32,
              child: Text('GA', style: context.tsTableHeader),
            ),
            SizedBox(
              width: 32,
              child: Text('SV', style: context.tsTableHeader),
            ),
            Expanded(
              child: Text(
                'SV%',
                style: context.tsTableHeader,
                textAlign: TextAlign.right,
              ),
            ),
          ] else ...[
            SizedBox(
              width: 56,
              child: Text('G-A-P', style: context.tsTableHeader),
            ),
            SizedBox(
              width: 32,
              child: Text('+/-', style: context.tsTableHeader),
            ),
            SizedBox(
              width: 32,
              child: Text('SOG', style: context.tsTableHeader),
            ),
            SizedBox(
              width: 48,
              child: Text('TOI', style: context.tsTableHeader),
            ),
            Expanded(
              child: Text(
                'PIM',
                style: context.tsTableHeader,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _GameLogRow extends StatelessWidget {
  final GameLogEntry entry;
  final bool isGoalie;

  const _GameLogRow({required this.entry, required this.isGoalie});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bgColor = _getRowColor(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              _formatDate(entry.date, context.localeName),
              style: context.tsLabelSmall,
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '${entry.homeAway == "A" ? "@" : "vs"} ${entry.opponentAbbrev}',
              style: AppTextStyles.bodySmallMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          if (isGoalie) ..._goalieStats(colors) else ..._skaterStats(colors),
        ],
      ),
    );
  }

  List<Widget> _skaterStats(AppThemeExtension colors) {
    final gap =
        '${entry.goals ?? 0}-${entry.assists ?? 0}-${entry.points ?? 0}';
    final pm = entry.plusMinus ?? 0;
    final pmStr = pm > 0 ? '+$pm' : '$pm';

    return [
      SizedBox(
        width: 56,
        child: Text(
          gap,
          style: AppTextStyles.bodySmallStrong.copyWith(
            color: (entry.points ?? 0) > 0 ? colors.accent : colors.textPrimary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          pmStr,
          style: AppTextStyles.bodySmall.copyWith(
            color: pm > 0
                ? colors.success
                : pm < 0
                ? colors.error
                : colors.textSecondary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '${entry.shots ?? 0}',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
      ),
      SizedBox(
        width: 48,
        child: Text(
          entry.toi ?? '-',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          '${entry.pim ?? 0}',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
          textAlign: TextAlign.right,
        ),
      ),
    ];
  }

  List<Widget> _goalieStats(AppThemeExtension colors) {
    final saves = (entry.shotsAgainst ?? 0) - (entry.goalsAgainst ?? 0);
    final svPct = entry.savePctg;

    return [
      SizedBox(
        width: 32,
        child: Text(
          entry.decision ?? '-',
          style: AppTextStyles.bodySmallStrong.copyWith(
            color: entry.decision == 'W'
                ? colors.success
                : entry.decision == 'L'
                ? colors.error
                : colors.textSecondary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '${entry.goalsAgainst ?? 0}',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '$saves',
          style: AppTextStyles.bodySmall.copyWith(color: colors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          svPct != null ? '.${(svPct * 1000).round()}' : '-',
          style: AppTextStyles.bodySmallStrong.copyWith(
            color: svPct != null && svPct >= 0.930
                ? colors.success
                : svPct != null && svPct < 0.880
                ? colors.error
                : colors.textPrimary,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ];
  }

  Color? _getRowColor(AppThemeExtension colors) {
    if (isGoalie) {
      final svPct = entry.savePctg;
      if (svPct != null && svPct >= 0.930) {
        return colors.success.withValues(alpha: 0.08);
      }
      if (svPct != null && svPct < 0.880) {
        return colors.error.withValues(alpha: 0.08);
      }
    } else {
      final pts = entry.points ?? 0;
      final pm = entry.plusMinus ?? 0;
      if (pts >= 3) return colors.success.withValues(alpha: 0.08);
      if (pts == 0 && pm < 0) {
        return colors.error.withValues(alpha: 0.08);
      }
    }
    return null;
  }

  String _formatDate(DateTime date, String locale) =>
      DateFormat.MMMd(locale).format(date);
}
