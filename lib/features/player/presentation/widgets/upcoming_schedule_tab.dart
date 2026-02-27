import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
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
                style: TextStyle(color: AppColors.textSecondary),
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

  int _daysDiff(String date1, String date2) {
    try {
      final d1 = DateTime.parse(date1);
      final d2 = DateTime.parse(date2);
      return (d2.difference(d1).inDays).abs();
    } catch (_) {
      return 999;
    }
  }
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
    final isHome = game.homeTeamAbbrev == teamAbbrev;
    final opponent = isHome ? game.awayTeamAbbrev : game.homeTeamAbbrev;
    final prefix = isHome ? 'vs' : '@';
    final timeStr = _formatTime(game.startTimeUtc);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 0.5)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(game.date), style: AppTextStyles.labelLarge),
                if (timeStr != null)
                  Text(timeStr, style: AppTextStyles.labelSmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 24,
            alignment: Alignment.center,
            child: Text(
              prefix,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isHome ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(opponent, style: AppTextStyles.titleMedium)),
          if (isBackToBack)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.5),
                ),
              ),
              child: Text(
                context.l10n.scheduleBackToBack,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.warning,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${weekdays[d.weekday - 1]}, ${months[d.month]} ${d.day}';
    } catch (_) {
      return date;
    }
  }

  String? _formatTime(String? utc) {
    if (utc == null) return null;
    try {
      final dt = DateTime.parse(utc).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final amPm = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $amPm';
    } catch (_) {
      return null;
    }
  }
}
