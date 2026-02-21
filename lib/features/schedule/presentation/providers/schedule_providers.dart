import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../player/providers.dart';
import '../../../watchlist/presentation/providers/watchlist_providers.dart';
import '../../domain/entities/game_day.dart';
import '../../domain/entities/schedule_game.dart';
import '../../providers.dart';

// ── Selected date (null = today) ─────────────────────────────────────────────

class SelectedDateNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, String?>(
  SelectedDateNotifier.new,
);

// ── Game day data for selected date ──────────────────────────────────────────

final gameDayProvider = FutureProvider<GameDay>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.read(scheduleRepositoryProvider).getGameDay(date);
});

// ── Auto-refresh timer for live games ────────────────────────────────────────

final _liveRefreshProvider = Provider.autoDispose<void>((ref) {
  final gameDayAsync = ref.watch(gameDayProvider);
  final hasLive = gameDayAsync.whenOrNull(
    data: (gd) => gd.games.any((g) => g.gameState == GameState.live),
  );

  if (hasLive == true) {
    final timer = Timer.periodic(const Duration(seconds: 60), (_) {
      ref.invalidate(gameDayProvider);
    });
    ref.onDispose(timer.cancel);
  }
});

/// Watch this from the schedule screen to activate auto-refresh
/// when live games are detected.
final liveAutoRefreshProvider = Provider.autoDispose<void>((ref) {
  ref.watch(_liveRefreshProvider);
});

// ── Watchlisted players grouped by team abbreviation ─────────────────────────

final watchlistTeamNamesProvider = FutureProvider<Map<String, List<String>>>((
  ref,
) async {
  final watchlistsAsync = ref.watch(watchlistsProvider);
  final playerRepo = ref.read(playerRepositoryProvider);

  final watchlists = watchlistsAsync.value;
  if (watchlists == null) return {};

  final result = <String, List<String>>{};
  for (final wl in watchlists) {
    for (final playerId in wl.playerIds) {
      final player = await playerRepo.getCachedPlayer(playerId);
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
});
