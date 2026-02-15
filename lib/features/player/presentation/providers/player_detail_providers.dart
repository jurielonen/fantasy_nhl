import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../schedule/providers.dart';
import '../../domain/entities/game_log_entry.dart';
import '../../domain/entities/player_detail.dart';
import '../../providers.dart';
import '../../../schedule/domain/entities/schedule_game.dart';

// ── Player Detail ────────────────────────────────────────────────────────────

final playerDetailProvider =
    FutureProvider.family<PlayerDetail, int>((ref, playerId) {
  return ref.read(playerRepositoryProvider).getPlayerDetail(playerId);
});

// ── Game Log ─────────────────────────────────────────────────────────────────

final playerGameLogProvider =
    FutureProvider.family<List<GameLogEntry>, int>((ref, playerId) {
  return ref.read(playerRepositoryProvider).getGameLog(playerId);
});

// ── Upcoming Schedule ────────────────────────────────────────────────────────

final playerUpcomingScheduleProvider =
    FutureProvider.family<List<ScheduleGame>, String>((ref, teamAbbrev) {
  return ref.read(scheduleRepositoryProvider).getTeamWeekSchedule(teamAbbrev);
});

// ── Stat Trend Metric Toggle ─────────────────────────────────────────────────

class SelectedStatTrendNotifier extends Notifier<String> {
  @override
  String build() => 'points';

  void select(String metric) => state = metric;
}

final selectedStatTrendProvider =
    NotifierProvider<SelectedStatTrendNotifier, String>(
  SelectedStatTrendNotifier.new,
);
