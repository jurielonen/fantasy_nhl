import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/stat_formatter.dart';
import '../../../player/domain/entities/game_log_entry.dart';
import '../../../schedule/domain/entities/schedule_game.dart';
import '../../domain/entities/watchlist_player_info.dart';

class WatchlistPlayerTile extends StatelessWidget {
  final WatchlistPlayerInfo info;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMove;

  const WatchlistPlayerTile({
    super.key,
    required this.info,
    required this.onTap,
    required this.onRemove,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(info.player.id),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onMove(),
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            icon: Icons.drive_file_move_outlined,
            label: 'Move',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(onDismissed: onRemove),
        children: [
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Remove',
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _Avatar(url: info.player.headshot, name: info.player.firstName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      info.player.fullName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (info.player.teamAbbrev != null) ...[
                          _Badge(info.player.teamAbbrev!),
                          const SizedBox(width: 6),
                        ],
                        _Badge(info.player.position),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _GameStatusWidget(info: info),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final String name;

  const _Avatar({this.url, required this.name});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.surfaceVariant,
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.surfaceVariant,
      backgroundImage: CachedNetworkImageProvider(url!),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _GameStatusWidget extends StatelessWidget {
  final WatchlistPlayerInfo info;

  const _GameStatusWidget({required this.info});

  @override
  Widget build(BuildContext context) {
    final game = info.todayGame;

    if (game == null) {
      return _noGameWidget();
    }

    return switch (game.gameState) {
      GameState.live => _liveGameWidget(game),
      GameState.final_ => _finalGameWidget(game),
      GameState.future => _futureGameWidget(game),
      GameState.off => _noGameWidget(),
    };
  }

  Widget _liveGameWidget(ScheduleGame game) {
    final score = '${game.awayTeamAbbrev} ${game.awayScore ?? 0} - '
        '${game.homeScore ?? 0} ${game.homeTeamAbbrev}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'LIVE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          score,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _finalGameWidget(ScheduleGame game) {
    final score = '${game.awayTeamAbbrev} ${game.awayScore ?? 0} - '
        '${game.homeScore ?? 0} ${game.homeTeamAbbrev}';
    final log = info.lastGameLog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Final: $score',
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        if (log != null)
          Text(
            _formatStatLine(log),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            ),
          ),
      ],
    );
  }

  Widget _futureGameWidget(ScheduleGame game) {
    final teamAbbrev = info.player.teamAbbrev;
    final isHome = game.homeTeamAbbrev == teamAbbrev;
    final opponent = isHome ? game.awayTeamAbbrev : game.homeTeamAbbrev;
    final prefix = isHome ? 'vs' : '@';
    final time = _formatGameTime(game.startTimeUtc);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$prefix $opponent',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          time,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _noGameWidget() {
    final log = info.lastGameLog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'No game today',
          style: TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),
        if (log != null)
          Text(
            '${log.date}: ${_formatStatLine(log)}',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
      ],
    );
  }

  String _formatStatLine(GameLogEntry log) {
    if (log.isGoalie) {
      final sv = log.savePctg != null
          ? StatFormatter.savePercentage(log.savePctg!)
          : '-';
      return '${log.decision ?? ''} ${log.shotsAgainst ?? 0}SA $sv';
    }
    return '${log.goals ?? 0}G ${log.assists ?? 0}A ${log.points ?? 0}P';
  }

  String _formatGameTime(String? utcTime) {
    if (utcTime == null) return '';
    try {
      final dt = DateTime.parse(utcTime).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }
}
