import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/player_list_tile.dart';
import '../../../watchlist/presentation/providers/add_to_watchlist_action.dart';
import '../providers/explore_providers.dart';

class SearchResultsList extends ConsumerWidget {
  final void Function(int playerId)? onPlayerTap;

  const SearchResultsList({super.key, this.onPlayerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(searchQueryProvider);
    if (query.trim().length < 2) return const SizedBox.shrink();

    final resultsAsync = ref.watch(searchResultsProvider);

    return resultsAsync.when(
      data: (players) {
        if (players.isEmpty) {
          return EmptyState(
            icon: Icons.search_off,
            title: context.l10n.exploreSearchNoResults,
            subtitle: context.l10n.exploreSearchNoResultsHint,
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return PlayerListTile(
              player: player,
              onTap: () => onPlayerTap?.call(player.id),
              onAddToWatchlist: () =>
                  addToWatchlist(ref, context, player),
              onRemoveFromWatchlist: () =>
                  removeFromWatchlist(ref, context, player),
            );
          },
        );
      },
      loading: () => Column(
        children: List.generate(
          5,
          (index) => const ShimmerPlayerListTile(),
        ),
      ),
      error: (error, stack) => AppErrorWidget(
        message: context.l10n.exploreSearchFailed(error.toString()),
        onRetry: () => ref.invalidate(searchResultsProvider),
      ),
    );
  }
}
