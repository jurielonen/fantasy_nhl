import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/schedule_game.dart';

class ScheduleGameCard extends StatelessWidget {
  final ScheduleGame game;
  final List<String> homeWatchlistNames;
  final List<String> awayWatchlistNames;

  const ScheduleGameCard({
    super.key,
    required this.game,
    this.homeWatchlistNames = const [],
    this.awayWatchlistNames = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasWatchlistPlayers =
        homeWatchlistNames.isNotEmpty || awayWatchlistNames.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: hasWatchlistPlayers ? AppColors.accent.withValues(alpha: 0.05) : null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // Away team
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        game.awayTeamAbbrev,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (game.awayTeamName != null)
                        Text(
                          game.awayTeamName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                // Score / Time
                _GameStatusCenter(game: game),
                // Home team
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        game.homeTeamAbbrev,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (game.homeTeamName != null)
                        Text(
                          game.homeTeamName!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasWatchlistPlayers) ...[
              const SizedBox(height: 8),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _WatchlistNames(names: awayWatchlistNames),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: _WatchlistNames(
                      names: homeWatchlistNames,
                      align: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _GameStatusCenter extends StatelessWidget {
  final ScheduleGame game;

  const _GameStatusCenter({required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: switch (game.gameState) {
        GameState.live => _buildLive(context),
        GameState.final_ => _buildFinal(context),
        GameState.future => _buildFuture(context),
        GameState.off => _buildFuture(context),
      },
    );
  }

  Widget _buildLive(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            context.l10n.scheduleLive,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.success,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${game.awayScore ?? 0} - ${game.homeScore ?? 0}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFinal(BuildContext context) {
    return Column(
      children: [
        Text(
          context.l10n.scheduleFinal,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          '${game.awayScore ?? 0} - ${game.homeScore ?? 0}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFuture(BuildContext context) {
    return Text(
      _formatTime(context, game.startTimeUtc),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  String _formatTime(BuildContext context, String? utcTime) {
    if (utcTime == null) return context.l10n.scheduleTbd;
    try {
      final dt = DateTime.parse(utcTime).toLocal();
      final hour =
          dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return context.l10n.scheduleTbd;
    }
  }
}

class _WatchlistNames extends StatelessWidget {
  final List<String> names;
  final CrossAxisAlignment align;

  const _WatchlistNames({
    required this.names,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: align,
      children: names
          .map((n) => Text(
                n,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w500,
                ),
              ))
          .toList(),
    );
  }
}
