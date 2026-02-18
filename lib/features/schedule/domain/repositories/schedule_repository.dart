import '../entities/game_day.dart';
import '../entities/schedule_game.dart';

abstract class ScheduleRepository {
  Future<GameDay> getGameDay(String? date);
  Future<List<ScheduleGame>> getTodaySchedule();
  Future<List<ScheduleGame>> getTeamWeekSchedule(String teamAbbrev);
  Future<List<ScheduleGame>> getTodayScores();
}
