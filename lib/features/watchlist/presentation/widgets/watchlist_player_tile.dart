import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/stat_formatter.dart';
import '../../../../shared/widgets/player_hero_context.dart';
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
    final colors = context.appColors;
    return Slidable(
      key: ValueKey(info.player.id),
      startActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) => onMove(),
            backgroundColor: colors.accent,
            foregroundColor: colors.textPrimary,
            icon: Icons.drive_file_move_outlined,
            label: context.l10n.watchlistMove,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        dismissible: DismissiblePane(onDismissed: onRemove),
        children: [
          SlidableAction(
            onPressed: (ctx) => onRemove(),
            backgroundColor: colors.error,
            foregroundColor: colors.textPrimary,
            icon: Icons.delete_outline,
            label: context.l10n.watchlistRemove,
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Hero(
                tag: PlayerHeroContext.watchlist.tag(info.player.id),
                child: _Avatar(
                  url: info.player.headshot,
                  name: info.player.firstName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      info.player.fullName,
                      style: context.tsPlayerName,
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
    final colors = context.appColors;
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: colors.surfaceVariant,
        child: Text(
          name.isNotEmpty ? name[0] : '?',
          style: context.tsBodyMedium,
        ),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: colors.surfaceVariant,
      backgroundImage: CachedNetworkImageProvider(url!),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: context.tsTableHeaderSecondary),
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
      return _noGameWidget(context);
    }

    return switch (game.gameState) {
      GameState.live => _liveGameWidget(context, game),
      GameState.final_ => _finalGameWidget(context, game),
      GameState.future => _futureGameWidget(context, game),
      GameState.off => _noGameWidget(context),
    };
  }

  Widget _liveGameWidget(BuildContext context, ScheduleGame game) {
    final colors = context.appColors;
    final score =
        '${game.awayTeamAbbrev} ${game.awayScore ?? 0} - '
        '${game.homeScore ?? 0} ${game.homeTeamAbbrev}';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colors.success.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            context.l10n.watchlistLive,
            style: context.tsBadgeLabel.copyWith(color: colors.success),
          ),
        ),
        const SizedBox(height: 2),
        Text(score, style: context.tsBodySmallStrong),
      ],
    );
  }

  Widget _finalGameWidget(BuildContext context, ScheduleGame game) {
    final colors = context.appColors;
    final score =
        '${game.awayTeamAbbrev} ${game.awayScore ?? 0} - '
        '${game.homeScore ?? 0} ${game.homeTeamAbbrev}';
    final log = info.lastGameLog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          context.l10n.watchlistFinalScore(score),
          style: context.tsCaptionSecondary,
        ),
        if (log != null)
          Text(
            _formatStatLine(log),
            style: context.tsBodySmallStrong.copyWith(color: colors.accent),
          ),
      ],
    );
  }

  Widget _futureGameWidget(BuildContext context, ScheduleGame game) {
    final teamAbbrev = info.player.teamAbbrev;
    final isHome = game.homeTeamAbbrev == teamAbbrev;
    final opponent = isHome ? game.awayTeamAbbrev : game.homeTeamAbbrev;
    final prefix = isHome ? 'vs' : '@';
    final time = _formatGameTime(game.startTimeUtc, context.localeName);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('$prefix $opponent', style: context.tsLabelMedium),
        Text(time, style: context.tsCaptionSecondary),
      ],
    );
  }

  Widget _noGameWidget(BuildContext context) {
    final log = info.lastGameLog;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(context.l10n.watchlistNoGameToday, style: context.tsCaption),
        if (log != null)
          Text(
            '${DateFormat.MMMd(context.localeName).format(log.date)}: ${_formatStatLine(log)}',
            style: context.tsCaptionSecondary,
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

  String _formatGameTime(DateTime? utcTime, String locale) {
    if (utcTime == null) return '';
    return DateFormat.jm(locale).format(utcTime.toLocal());
  }
}
