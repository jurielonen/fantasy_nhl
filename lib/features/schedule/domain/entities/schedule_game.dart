enum GameState {
  future,
  live,
  final_,
  off;

  static GameState fromApiString(String? value) {
    return switch (value?.toUpperCase()) {
      'FUT' || 'PRE' => GameState.future,
      'LIVE' || 'CRIT' => GameState.live,
      'FINAL' || 'OFF' => GameState.final_,
      _ => GameState.future,
    };
  }
}

class ScheduleGame {
  final int gameId;
  final String date;
  final String? startTimeUtc;
  final String homeTeamAbbrev;
  final String awayTeamAbbrev;
  final String? homeTeamName;
  final String? awayTeamName;
  final String? homeTeamLogo;
  final String? awayTeamLogo;
  final int? homeScore;
  final int? awayScore;
  final GameState gameState;

  const ScheduleGame({
    required this.gameId,
    required this.date,
    this.startTimeUtc,
    required this.homeTeamAbbrev,
    required this.awayTeamAbbrev,
    this.homeTeamName,
    this.awayTeamName,
    this.homeTeamLogo,
    this.awayTeamLogo,
    this.homeScore,
    this.awayScore,
    required this.gameState,
  });
}
