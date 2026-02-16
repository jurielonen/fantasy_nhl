import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../player/domain/entities/player.dart';
import '../../domain/entities/watchlist.dart';
import '../../providers.dart';
import 'watchlist_providers.dart';

Future<void> addToWatchlist(
  WidgetRef ref,
  BuildContext context,
  Player player,
) async {
  final repo = ref.read(watchlistRepositoryProvider);
  final existing = await repo.findWatchlistContainingPlayer(player.id);

  if (existing != null) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.fullName} already in "${existing.name}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  final watchlists = await repo.getWatchlists();
  if (watchlists.isEmpty) {
    await repo.ensureDefaultWatchlist();
    final updated = await repo.getWatchlists();
    if (updated.isEmpty) return;
    await repo.addPlayer(updated.first.id, player.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.fullName} added to "${updated.first.name}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    return;
  }

  if (watchlists.length == 1) {
    await repo.addPlayer(watchlists.first.id, player.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.fullName} added to "${watchlists.first.name}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _invalidateWatchlistPlayers(ref, watchlists.first.id);
    return;
  }

  if (!context.mounted) return;
  final chosen = await showModalBottomSheet<Watchlist>(
    context: context,
    builder: (ctx) => _AddToWatchlistSheet(
      watchlists: watchlists,
      playerName: player.fullName,
    ),
  );

  if (chosen != null) {
    await repo.addPlayer(chosen.id, player.id);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.fullName} added to "${chosen.name}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    _invalidateWatchlistPlayers(ref, chosen.id);
  }
}

void _invalidateWatchlistPlayers(WidgetRef ref, String watchlistId) {
  ref.invalidate(watchlistPlayersProvider(watchlistId));
}

class _AddToWatchlistSheet extends StatelessWidget {
  final List<Watchlist> watchlists;
  final String playerName;

  const _AddToWatchlistSheet({
    required this.watchlists,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Add $playerName to...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          ...watchlists.map(
            (wl) => ListTile(
              leading: const Icon(Icons.list_alt),
              title: Text(wl.name),
              subtitle: Text('${wl.playerIds.length} players'),
              onTap: () => Navigator.pop(context, wl),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
