import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_router.dart';

import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/player_hero_context.dart';
import '../../../shared/widgets/player_list_tile.dart';
import '../../watchlist/presentation/providers/add_to_watchlist_action.dart';
import 'providers/explore_providers.dart';

class TeamRosterScreen extends ConsumerWidget {
  final String teamAbbrev;

  const TeamRosterScreen({super.key, required this.teamAbbrev});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rosterAsync = ref.watch(teamRosterProvider(teamAbbrev));

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.teamRosterTitle(teamAbbrev))),
      body: rosterAsync.when(
        data: (players) {
          if (players.isEmpty) {
            return Center(child: Text(context.l10n.teamRosterEmpty));
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(teamRosterProvider(teamAbbrev));
            },
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return PlayerListTile(
                  player: player,
                  heroContext: PlayerHeroContext.teamRoster,
                  trailingStat: player.position,
                  trailingLabel: player.sweaterNumber != null
                      ? '#${player.sweaterNumber}'
                      : null,
                  onTap: () => PlayerDetailRoute(
                    playerId: player.id,
                    $extra: PlayerDetailExtra(
                      heroContext: PlayerHeroContext.teamRoster,
                      player: player,
                    ),
                  ).push(context),
                  onAddToWatchlist: () =>
                      addToWatchlist(ref, context, player),
                  onRemoveFromWatchlist: () =>
                      removeFromWatchlist(ref, context, player),
                );
              },
            ),
          );
        },
        loading: () => ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => const ShimmerPlayerListTile(),
        ),
        error: (error, stack) => AppErrorWidget(
          message: context.l10n.teamRosterError(error.toString()),
          onRetry: () => ref.invalidate(teamRosterProvider(teamAbbrev)),
        ),
      ),
    );
  }
}
