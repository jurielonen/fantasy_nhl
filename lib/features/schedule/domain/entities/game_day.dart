import 'schedule_game.dart';

class GameDay {
  final DateTime? prevDate;
  final DateTime currentDate;
  final DateTime? nextDate;
  final List<GameWeekDay> weekDays;
  final List<ScheduleGame> games;

  const GameDay({
    this.prevDate,
    required this.currentDate,
    this.nextDate,
    this.weekDays = const [],
    this.games = const [],
  });
}

class GameWeekDay {
  final DateTime date;
  final String dayAbbrev;
  final int numberOfGames;

  const GameWeekDay({
    required this.date,
    required this.dayAbbrev,
    this.numberOfGames = 0,
  });
}
