import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
                style: TextStyle(color: AppColors.textSecondary),
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
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(context.l10n.gameLogDate, style: _headerStyle),
          ),
          SizedBox(
            width: 56,
            child: Text(context.l10n.gameLogOpp, style: _headerStyle),
          ),
          if (isGoalie) ...[
            SizedBox(
              width: 32,
              child: Text(context.l10n.gameLogDec, style: _headerStyle),
            ),
            const SizedBox(width: 32, child: Text('GA', style: _headerStyle)),
            const SizedBox(width: 32, child: Text('SV', style: _headerStyle)),
            const Expanded(
              child: Text(
                'SV%',
                style: _headerStyle,
                textAlign: TextAlign.right,
              ),
            ),
          ] else ...[
            const SizedBox(
              width: 56,
              child: Text('G-A-P', style: _headerStyle),
            ),
            const SizedBox(width: 32, child: Text('+/-', style: _headerStyle)),
            const SizedBox(width: 32, child: Text('SOG', style: _headerStyle)),
            const SizedBox(width: 48, child: Text('TOI', style: _headerStyle)),
            const Expanded(
              child: Text(
                'PIM',
                style: _headerStyle,
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
    final bgColor = _getRowColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: const Border(
          bottom: BorderSide(color: AppColors.border, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              _formatDate(entry.date, context.localeName),
              style: AppTextStyles.labelSmall,
            ),
          ),
          SizedBox(
            width: 56,
            child: Text(
              '${entry.homeAway == "A" ? "@" : "vs"} ${entry.opponentAbbrev}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isGoalie) ..._goalieStats() else ..._skaterStats(),
        ],
      ),
    );
  }

  List<Widget> _skaterStats() {
    final gap =
        '${entry.goals ?? 0}-${entry.assists ?? 0}-${entry.points ?? 0}';
    final pm = entry.plusMinus ?? 0;
    final pmStr = pm > 0 ? '+$pm' : '$pm';

    return [
      SizedBox(
        width: 56,
        child: Text(
          gap,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: (entry.points ?? 0) > 0
                ? AppColors.accent
                : AppColors.textPrimary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          pmStr,
          style: TextStyle(
            fontSize: 12,
            color: pm > 0
                ? AppColors.success
                : pm < 0
                ? AppColors.error
                : AppColors.textSecondary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '${entry.shots ?? 0}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      SizedBox(
        width: 48,
        child: Text(
          entry.toi ?? '-',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          '${entry.pim ?? 0}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.right,
        ),
      ),
    ];
  }

  List<Widget> _goalieStats() {
    final saves = (entry.shotsAgainst ?? 0) - (entry.goalsAgainst ?? 0);
    final svPct = entry.savePctg;

    return [
      SizedBox(
        width: 32,
        child: Text(
          entry.decision ?? '-',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: entry.decision == 'W'
                ? AppColors.success
                : entry.decision == 'L'
                ? AppColors.error
                : AppColors.textSecondary,
          ),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '${entry.goalsAgainst ?? 0}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      SizedBox(
        width: 32,
        child: Text(
          '$saves',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ),
      Expanded(
        child: Text(
          svPct != null ? '.${(svPct * 1000).round()}' : '-',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: svPct != null && svPct >= 0.930
                ? AppColors.success
                : svPct != null && svPct < 0.880
                ? AppColors.error
                : AppColors.textPrimary,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    ];
  }

  Color? _getRowColor() {
    if (isGoalie) {
      final svPct = entry.savePctg;
      if (svPct != null && svPct >= 0.930) {
        return AppColors.success.withValues(alpha: 0.08);
      }
      if (svPct != null && svPct < 0.880) {
        return AppColors.error.withValues(alpha: 0.08);
      }
    } else {
      final pts = entry.points ?? 0;
      final pm = entry.plusMinus ?? 0;
      if (pts >= 3) return AppColors.success.withValues(alpha: 0.08);
      if (pts == 0 && pm < 0) return AppColors.error.withValues(alpha: 0.08);
    }
    return null;
  }

  String _formatDate(DateTime date, String locale) =>
      DateFormat.MMMd(locale).format(date);
}

const _headerStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.w600,
  color: AppColors.textTertiary,
);
