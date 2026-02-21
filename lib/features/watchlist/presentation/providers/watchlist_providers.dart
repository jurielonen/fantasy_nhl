import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../player/domain/entities/game_log_entry.dart';
import '../../../player/domain/entities/player_detail.dart';
import '../../../player/providers.dart';
import '../../../schedule/domain/entities/schedule_game.dart';
import '../../../schedule/providers.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/entities/watchlist_player_info.dart';
import '../../providers.dart';

// ── Sort type ────────────────────────────────────────────────────────────────

enum WatchlistSortType { custom, name, position, points, recentPerformance, gameTime }

// ── All watchlists (reactive via Drift stream) ───────────────────────────────

final watchlistsProvider = StreamProvider<List<Watchlist>>((ref) async* {
  final repo = ref.watch(watchlistRepositoryProvider);
  await repo.ensureDefaultWatchlist();
  yield* repo.watchlistChanges;
});

// ── Selected watchlist ───────────────────────────────────────────────────────

class SelectedWatchlistIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

final selectedWatchlistIdProvider =
    NotifierProvider<SelectedWatchlistIdNotifier, String?>(
  SelectedWatchlistIdNotifier.new,
);

final selectedWatchlistProvider = Provider<Watchlist?>((ref) {
  final watchlistsAsync = ref.watch(watchlistsProvider);
  final selectedId = ref.watch(selectedWatchlistIdProvider);

  return watchlistsAsync.whenOrNull(
    data: (watchlists) {
      if (watchlists.isEmpty) return null;
      if (selectedId != null) {
        final match = watchlists.where((w) => w.id == selectedId);
        if (match.isNotEmpty) return match.first;
      }
      Future.microtask(() {
        ref.read(selectedWatchlistIdProvider.notifier).select(
              watchlists.first.id,
            );
      });
      return watchlists.first;
    },
  );
});

// ── Today's schedule & scores ────────────────────────────────────────────────

final todayScheduleProvider = FutureProvider<List<ScheduleGame>>((ref) {
  return ref.read(scheduleRepositoryProvider).getTodaySchedule();
});

final todayScoresProvider = FutureProvider<List<ScheduleGame>>((ref) {
  return ref.read(scheduleRepositoryProvider).getTodayScores();
});

// ── Sort preference ──────────────────────────────────────────────────────────

class WatchlistSortNotifier extends Notifier<WatchlistSortType> {
  @override
  WatchlistSortType build() => WatchlistSortType.custom;

  void select(WatchlistSortType type) => state = type;
}

final watchlistSortProvider =
    NotifierProvider<WatchlistSortNotifier, WatchlistSortType>(
  WatchlistSortNotifier.new,
);

// ── Watchlist players (enriched) ─────────────────────────────────────────────

final watchlistPlayersProvider =
    FutureProvider.family<List<WatchlistPlayerInfo>, String>(
  (ref, watchlistId) async {
    final repo = ref.watch(watchlistRepositoryProvider);
    final playerRepo = ref.read(playerRepositoryProvider);
    final watchlist = await repo.getWatchlist(watchlistId);
    if (watchlist == null) return [];

    final scheduleGames = await ref
        .read(todayScheduleProvider.future)
        .catchError((_) => <ScheduleGame>[]);
    final scoreGames = await ref
        .read(todayScoresProvider.future)
        .catchError((_) => <ScheduleGame>[]);

    // Merge scores into schedule (scores have updated gameState/scores)
    final gamesWithScores = <ScheduleGame>[];
    for (final sg in scheduleGames) {
      final scoreMatch = scoreGames.where((s) => s.gameId == sg.gameId);
      gamesWithScores.add(scoreMatch.isNotEmpty ? scoreMatch.first : sg);
    }

    final results = <WatchlistPlayerInfo>[];
    for (final playerId in watchlist.playerIds) {
      final player = await playerRepo.getPlayerBasicInfo(playerId);
      final todayGame = findGameForTeam(player.teamAbbrev, gamesWithScores);

      GameLogEntry? lastLog;
      int? seasonPts;
      double? recentAvg;
      try {
        final logs = await playerRepo.getGameLog(playerId);
        if (logs.isNotEmpty) {
          lastLog = logs.first;
          final recent = logs.take(5).toList();
          if (!logs.first.isGoalie) {
            recentAvg = recent.isEmpty
                ? null
                : recent.fold<int>(0, (sum, e) => sum + (e.points ?? 0)) /
                    recent.length;
          }
        }
      } catch (_) {
        // Game log not available/cached — skip
      }

      try {
        final detail = await playerRepo.getPlayerDetail(playerId);
        final stats = detail.currentSeasonStats;
        if (stats is SkaterSeasonStats) {
          seasonPts = stats.points;
        }
      } catch (_) {
        // Detail not available/cached — skip
      }

      results.add(WatchlistPlayerInfo(
        player: player,
        todayGame: todayGame,
        lastGameLog: lastLog,
        seasonPoints: seasonPts,
        recentAvgPoints: recentAvg,
      ));
    }

    final sortType = ref.read(watchlistSortProvider);
    _sortPlayers(results, sortType);

    return results;
  },
);

void _sortPlayers(List<WatchlistPlayerInfo> players, WatchlistSortType sort) {
  switch (sort) {
    case WatchlistSortType.custom:
      break;
    case WatchlistSortType.name:
      players.sort(
          (a, b) => a.player.lastName.compareTo(b.player.lastName));
    case WatchlistSortType.position:
      const order = {'C': 0, 'LW': 1, 'RW': 2, 'D': 3, 'G': 4};
      players.sort((a, b) => (order[a.player.position] ?? 5)
          .compareTo(order[b.player.position] ?? 5));
    case WatchlistSortType.points:
      players.sort(
          (a, b) => (b.seasonPoints ?? 0).compareTo(a.seasonPoints ?? 0));
    case WatchlistSortType.recentPerformance:
      players.sort((a, b) =>
          (b.recentAvgPoints ?? 0).compareTo(a.recentAvgPoints ?? 0));
    case WatchlistSortType.gameTime:
      players.sort((a, b) {
        final aTime = a.todayGame?.startTimeUtc ?? '';
        final bTime = b.todayGame?.startTimeUtc ?? '';
        if (aTime.isEmpty && bTime.isEmpty) return 0;
        if (aTime.isEmpty) return 1;
        if (bTime.isEmpty) return -1;
        return aTime.compareTo(bTime);
      });
  }
}
