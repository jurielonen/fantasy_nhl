import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import 'providers/schedule_providers.dart';
import 'widgets/date_selector.dart';
import 'widgets/schedule_game_card.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activate auto-refresh when live games are detected
    ref.watch(liveAutoRefreshProvider);

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
    final gameDayAsync = ref.watch(gameDayProvider);
    // Use empty map while loading — watchlist names are best-effort overlays
    final watchlistNames =
        ref.watch(watchlistTeamNamesProvider).asData?.value ?? const {};

    return gameDayAsync.when(
      loading: () => _buildShimmer(),
      error: (err, _) => AppErrorWidget(
        message: context.l10n.scheduleFailedToLoad,
        onRetry: () => ref.invalidate(gameDayProvider),
      ),
      data: (gameDay) {
        final games = gameDay.games;

        if (games.isEmpty) {
          return EmptyState(
            icon: Icons.calendar_today,
            title: context.l10n.scheduleNoGames,
            subtitle: context.l10n.scheduleNoGamesHint,
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(gameDayProvider);
            await ref.read(gameDayProvider.future);
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

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: 6,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: ShimmerLoader(height: 80),
      ),
    );
  }
}
