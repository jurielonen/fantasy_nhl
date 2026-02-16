import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/watchlist.dart';

class MoveToWatchlistSheet extends StatelessWidget {
  final List<Watchlist> watchlists;
  final String currentWatchlistId;
  final String playerName;

  const MoveToWatchlistSheet({
    super.key,
    required this.watchlists,
    required this.currentWatchlistId,
    required this.playerName,
  });

  @override
  Widget build(BuildContext context) {
    final targets =
        watchlists.where((w) => w.id != currentWatchlistId).toList();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              context.l10n.movePlayerTo(playerName),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (targets.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(context.l10n.movePlayerNoOther),
            )
          else
            ...targets.map(
              (wl) => ListTile(
                leading: const Icon(Icons.list_alt),
                title: Text(wl.name),
                subtitle: Text(context.l10n.commonPlayers(wl.playerIds.length)),
                onTap: () => Navigator.pop(context, wl),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
