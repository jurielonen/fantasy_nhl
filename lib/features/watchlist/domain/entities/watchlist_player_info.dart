import '../../../player/domain/entities/game_log_entry.dart';
import '../../../player/domain/entities/player.dart';
import '../../../schedule/domain/entities/schedule_game.dart';

class WatchlistPlayerInfo {
  final Player player;
  final ScheduleGame? todayGame;
  final GameLogEntry? lastGameLog;
  final int? seasonPoints;
  final double? recentAvgPoints;

  const WatchlistPlayerInfo({
    required this.player,
    this.todayGame,
    this.lastGameLog,
    this.seasonPoints,
    this.recentAvgPoints,
  });
}

ScheduleGame? findGameForTeam(String? teamAbbrev, List<ScheduleGame> games) {
  if (teamAbbrev == null) return null;
  for (final game in games) {
    if (game.homeTeamAbbrev == teamAbbrev ||
        game.awayTeamAbbrev == teamAbbrev) {
      return game;
    }
  }
  return null;
}
