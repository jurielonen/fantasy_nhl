import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../player/providers.dart';
import '../../../watchlist/presentation/providers/watchlist_providers.dart';
import '../../domain/entities/game_day.dart';
import '../../domain/entities/schedule_game.dart';
import '../../providers.dart';

part 'schedule_providers.g.dart';

// ── Selected date (null = today) ─────────────────────────────────────────────

@riverpod
class SelectedDate extends _$SelectedDate {
  @override
  String? build() => null;

  void select(String? date) => state = date;
}

// ── Game day data for selected date ──────────────────────────────────────────

@riverpod
Future<GameDay> gameDay(Ref ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.read(scheduleRepositoryProvider).getGameDay(date);
}

// ── Auto-refresh timer for live games ────────────────────────────────────────

@riverpod
void _liveRefresh(Ref ref) {
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
}

/// Watch this from the schedule screen to activate auto-refresh
/// when live games are detected.
@riverpod
void liveAutoRefresh(Ref ref) {
  ref.watch(_liveRefreshProvider);
}

// ── Watchlisted players grouped by team abbreviation ─────────────────────────

@riverpod
Future<Map<String, List<String>>> watchlistTeamNames(Ref ref) async {
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
}
