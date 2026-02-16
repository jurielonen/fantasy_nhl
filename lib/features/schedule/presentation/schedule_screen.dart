import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../player/providers.dart';
import '../../watchlist/presentation/providers/watchlist_providers.dart';
import 'providers/schedule_providers.dart';
import 'widgets/date_selector.dart';
import 'widgets/schedule_game_card.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.scheduleTitle)),
      body: Column(
        children: [
          const DateSelector(),
          const Divider(height: 1),
          Expanded(child: _GameList()),
        ],
      ),
    );
  }
}

class _GameList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamesAsync = ref.watch(scheduleGamesWithScoresProvider);

    return gamesAsync.when(
      loading: () => _buildShimmer(),
      error: (err, _) => AppErrorWidget(
        message: context.l10n.scheduleFailedToLoad,
        onRetry: () => ref.invalidate(scheduleGamesWithScoresProvider),
      ),
      data: (games) {
        if (games.isEmpty) {
          return EmptyState(
            icon: Icons.calendar_today,
            title: context.l10n.scheduleNoGames,
            subtitle: context.l10n.scheduleNoGamesHint,
          );
        }

        // Gather watchlist player names per team
        final watchlistNames = _getWatchlistTeamNames(ref);

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(scheduleDateGamesProvider);
            ref.invalidate(scheduleDateScoresProvider);
            await ref.read(scheduleGamesWithScoresProvider.future);
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: games.length,
            itemBuilder: (context, index) {
              final game = games[index];
              return ScheduleGameCard(
                game: game,
                homeWatchlistNames:
                    watchlistNames[game.homeTeamAbbrev] ?? const [],
                awayWatchlistNames:
                    watchlistNames[game.awayTeamAbbrev] ?? const [],
              );
            },
          ),
        );
      },
    );
  }

  /// Cross-references watchlist players with team abbreviations
  /// Returns a map of teamAbbrev → list of player names on watchlist
  Map<String, List<String>> _getWatchlistTeamNames(WidgetRef ref) {
    final watchlistsAsync = ref.watch(watchlistsProvider);
    final playerRepo = ref.read(
      playerRepositoryProvider,
    );

    final result = <String, List<String>>{};

    final watchlists = watchlistsAsync.value;
    if (watchlists == null) return result;

    for (final wl in watchlists) {
      for (final playerId in wl.playerIds) {
        final player = playerRepo.getCachedPlayer(playerId);
        if (player == null) continue;
        final team = player.teamAbbrev;
        if (team == null) continue;
        result.putIfAbsent(team, () => []);
        if (!result[team]!.contains(player.fullName)) {
          result[team]!.add(player.fullName);
        }
      }
    }

    return result;
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 6,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ShimmerLoader(height: 80),
      ),
    );
  }
}
