import '../entities/schedule_game.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleGame>> getTodaySchedule();
  Future<List<ScheduleGame>> getTeamWeekSchedule(String teamAbbrev);
  Future<List<ScheduleGame>> getTodayScores();
}
