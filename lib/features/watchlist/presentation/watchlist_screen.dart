import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../schedule/domain/entities/schedule_game.dart';
import '../domain/entities/watchlist.dart';
import '../domain/entities/watchlist_player_info.dart';
import '../providers.dart';
import 'providers/watchlist_providers.dart';
import 'widgets/move_to_watchlist_sheet.dart';
import 'widgets/watchlist_empty_state.dart';
import 'widgets/watchlist_player_tile.dart';
import 'widgets/watchlist_selector.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedWatchlist = ref.watch(selectedWatchlistProvider);
    final sortType = ref.watch(watchlistSortProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
        actions: [
          PopupMenuButton<WatchlistSortType>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: (type) {
              ref.read(watchlistSortProvider.notifier).select(type);
              if (selectedWatchlist != null) {
                ref.invalidate(
                    watchlistPlayersProvider(selectedWatchlist.id));
              }
            },
            itemBuilder: (_) => [
              _sortItem(WatchlistSortType.custom, 'Custom Order', sortType),
              _sortItem(WatchlistSortType.name, 'Name', sortType),
              _sortItem(WatchlistSortType.position, 'Position', sortType),
              _sortItem(WatchlistSortType.points, 'Points (Season)', sortType),
              _sortItem(
                  WatchlistSortType.recentPerformance, 'Recent Form', sortType),
              _sortItem(WatchlistSortType.gameTime, 'Game Time', sortType),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const WatchlistSelector(),
          const Divider(height: 1, color: AppColors.border),
          Expanded(child: _buildBody(selectedWatchlist)),
        ],
      ),
    );
  }

  PopupMenuItem<WatchlistSortType> _sortItem(
    WatchlistSortType type,
    String label,
    WatchlistSortType current,
  ) {
    return PopupMenuItem(
      value: type,
      child: Row(
        children: [
          if (type == current)
            const Icon(Icons.check, size: 18, color: AppColors.accent)
          else
            const SizedBox(width: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildBody(Watchlist? selectedWatchlist) {
    if (selectedWatchlist == null) {
      return const WatchlistEmptyState();
    }

    final playersAsync =
        ref.watch(watchlistPlayersProvider(selectedWatchlist.id));

    return playersAsync.when(
      loading: () => ListView.builder(
        itemCount: 6,
        itemBuilder: (_, _) => const _ShimmerTile(),
      ),
      error: (error, _) => AppErrorWidget(
        message: 'Failed to load watchlist',
        onRetry: () =>
            ref.invalidate(watchlistPlayersProvider(selectedWatchlist.id)),
      ),
      data: (players) {
        if (players.isEmpty) {
          return const WatchlistEmptyState();
        }

        final hasLiveGames = players.any(
          (p) => p.todayGame?.gameState == GameState.live,
        );

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(todayScheduleProvider);
            ref.invalidate(todayScoresProvider);
            ref.invalidate(watchlistPlayersProvider(selectedWatchlist.id));
          },
          child: _PlayerList(
            players: players,
            watchlist: selectedWatchlist,
            hasLiveGames: hasLiveGames,
            onPlayerTap: (id) => context.push('/player/$id'),
            onRemovePlayer: (playerId) =>
                _removePlayer(selectedWatchlist, playerId),
            onMovePlayer: (playerId) =>
                _movePlayer(selectedWatchlist, playerId),
            onReorder: (oldIndex, newIndex) =>
                _reorder(selectedWatchlist, players, oldIndex, newIndex),
          ),
        );
      },
    );
  }

  Future<void> _removePlayer(Watchlist watchlist, int playerId) async {
    final repo = ref.read(watchlistRepositoryProvider);
    await repo.removePlayer(watchlist.id, playerId);
    ref.invalidate(watchlistPlayersProvider(watchlist.id));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Player removed'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            await repo.addPlayer(watchlist.id, playerId);
            ref.invalidate(watchlistPlayersProvider(watchlist.id));
          },
        ),
      ),
    );
  }

  Future<void> _movePlayer(Watchlist watchlist, int playerId) async {
    final watchlistsAsync = ref.read(watchlistsProvider);
    final allWatchlists = watchlistsAsync.value ?? [];

    if (allWatchlists.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Create another watchlist first'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final playerInfo = ref
        .read(watchlistPlayersProvider(watchlist.id))
        .value
        ?.where((p) => p.player.id == playerId)
        .firstOrNull;

    final target = await showModalBottomSheet<Watchlist>(
      context: context,
      builder: (_) => MoveToWatchlistSheet(
        watchlists: allWatchlists,
        currentWatchlistId: watchlist.id,
        playerName: playerInfo?.player.fullName ?? 'Player',
      ),
    );

    if (target != null) {
      await ref
          .read(watchlistRepositoryProvider)
          .movePlayer(watchlist.id, target.id, playerId);
      ref.invalidate(watchlistPlayersProvider(watchlist.id));
      ref.invalidate(watchlistPlayersProvider(target.id));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved to "${target.name}"'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _reorder(
    Watchlist watchlist,
    List<WatchlistPlayerInfo> players,
    int oldIndex,
    int newIndex,
  ) {
    HapticFeedback.mediumImpact();
    if (newIndex > oldIndex) newIndex--;

    final ids = players.map((p) => p.player.id).toList();
    final id = ids.removeAt(oldIndex);
    ids.insert(newIndex, id);

    ref.read(watchlistRepositoryProvider).reorderPlayers(watchlist.id, ids);
    ref.invalidate(watchlistPlayersProvider(watchlist.id));
  }
}

class _PlayerList extends StatelessWidget {
  final List<WatchlistPlayerInfo> players;
  final Watchlist watchlist;
  final bool hasLiveGames;
  final void Function(int playerId) onPlayerTap;
  final void Function(int playerId) onRemovePlayer;
  final void Function(int playerId) onMovePlayer;
  final void Function(int oldIndex, int newIndex) onReorder;

  const _PlayerList({
    required this.players,
    required this.watchlist,
    required this.hasLiveGames,
    required this.onPlayerTap,
    required this.onRemovePlayer,
    required this.onMovePlayer,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      itemCount: players.length,
      onReorder: onReorder,
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 4,
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          child: child,
        );
      },
      itemBuilder: (context, index) {
        final info = players[index];
        return WatchlistPlayerTile(
          key: ValueKey(info.player.id),
          info: info,
          onTap: () => onPlayerTap(info.player.id),
          onRemove: () => onRemovePlayer(info.player.id),
          onMove: () => onMovePlayer(info.player.id),
        );
      },
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  const _ShimmerTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const ShimmerLoader(width: 44, height: 44, borderRadius: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerLoader(width: 140, height: 14),
                SizedBox(height: 6),
                ShimmerLoader(width: 80, height: 12),
              ],
            ),
          ),
          const ShimmerLoader(width: 60, height: 14),
        ],
      ),
    );
  }
}
