import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
