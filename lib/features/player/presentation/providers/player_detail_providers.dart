import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../schedule/domain/entities/schedule_game.dart';
import '../../../schedule/providers.dart';
import '../../domain/entities/game_log_entry.dart';
import '../../domain/entities/player_detail.dart';
import '../../providers.dart';

part 'player_detail_providers.g.dart';

// ── Player Detail ────────────────────────────────────────────────────────────

@riverpod
Future<PlayerDetail> playerDetail(Ref ref, int playerId) {
  return ref.read(playerRepositoryProvider).getPlayerDetail(playerId);
}

// ── Game Log ─────────────────────────────────────────────────────────────────

@riverpod
Future<List<GameLogEntry>> playerGameLog(Ref ref, int playerId) {
  return ref.read(playerRepositoryProvider).getGameLog(playerId);
}

// ── Upcoming Schedule ────────────────────────────────────────────────────────

@riverpod
Future<List<ScheduleGame>> playerUpcomingSchedule(Ref ref, String teamAbbrev) {
  return ref.read(scheduleRepositoryProvider).getTeamWeekSchedule(teamAbbrev);
}

// ── Stat Trend Metric Toggle ─────────────────────────────────────────────────

@riverpod
class SelectedStatTrend extends _$SelectedStatTrend {
  @override
  String build() => 'points';

  void select(String metric) => state = metric;
}
