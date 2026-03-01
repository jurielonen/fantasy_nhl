import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../schedule/domain/entities/schedule_game.dart';

class UpcomingScheduleTab extends StatelessWidget {
  final AsyncValue<List<ScheduleGame>> scheduleAsync;
  final String teamAbbrev;
  final VoidCallback? onRetry;

  const UpcomingScheduleTab({
    super.key,
    required this.scheduleAsync,
    required this.teamAbbrev,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return scheduleAsync.when(
      loading: () => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, _) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ShimmerLoader(height: 56),
          ),
          childCount: 5,
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        child: AppErrorWidget(
          message: context.l10n.scheduleUpcomingError,
          onRetry: onRetry,
        ),
      ),
      data: (games) {
        final upcoming = games
            .where((g) => g.gameState == GameState.future)
            .take(7)
            .toList();

        if (upcoming.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Text(
                context.l10n.scheduleUpcomingEmpty,
                style: context.tsBodyMedium,
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final game = upcoming[index];
            final isB2B = _isBackToBack(upcoming, index);
            return _ScheduleRow(
              game: game,
              teamAbbrev: teamAbbrev,
              isBackToBack: isB2B,
            );
          }, childCount: upcoming.length),
        );
      },
    );
  }

  bool _isBackToBack(List<ScheduleGame> games, int index) {
    if (index == 0 && games.length > 1) {
      return _daysDiff(games[0].date, games[1].date) == 1;
    }
    if (index > 0) {
      return _daysDiff(games[index - 1].date, games[index].date) == 1;
    }
    return false;
  }

  int _daysDiff(DateTime date1, DateTime date2) =>
      (date2.difference(date1).inDays).abs();
}

class _ScheduleRow extends StatelessWidget {
  final ScheduleGame game;
  final String teamAbbrev;
  final bool isBackToBack;

  const _ScheduleRow({
    required this.game,
    required this.teamAbbrev,
    required this.isBackToBack,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final locale = context.localeName;
    final isHome = game.homeTeamAbbrev == teamAbbrev;
    final opponent = isHome ? game.awayTeamAbbrev : game.homeTeamAbbrev;
    final prefix = isHome ? 'vs' : '@';
    final timeStr = _formatTime(game.startTimeUtc, locale);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(game.date, locale),
                  style: context.tsLabelLarge,
                ),
                if (timeStr != null) Text(timeStr, style: context.tsLabelSmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            alignment: Alignment.center,
            child: Text(
              prefix,
              style: context.tsBodySmallMedium.copyWith(
                color: isHome ? colors.textPrimary : colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(opponent, style: context.tsTitleMedium)),
          if (isBackToBack)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: colors.warning.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                context.l10n.scheduleBackToBack,
                style: context.tsBadgeLabel.copyWith(color: colors.warning),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date, String locale) =>
      DateFormat('EEE, MMM d', locale).format(date);

  String? _formatTime(DateTime? utc, String locale) {
    if (utc == null) return null;
    return DateFormat.jm(locale).format(utc.toLocal());
  }
}
