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

class GameTeam {
  final int? id;
  final String name;
  final String abbrev;
  final int? score;
  final int? shotsOnGoal;
  final String? logoUrl;

  const GameTeam({
    this.id,
    this.name = '',
    required this.abbrev,
    this.score,
    this.shotsOnGoal,
    this.logoUrl,
  });
}

class GameClock {
  final String timeRemaining;
  final int secondsRemaining;
  final bool isRunning;
  final bool inIntermission;

  const GameClock({
    this.timeRemaining = '00:00',
    this.secondsRemaining = 0,
    this.isRunning = false,
    this.inIntermission = false,
  });
}

class GameGoal {
  final int period;
  final String timeInPeriod;
  final String scorerName;
  final String? scorerMugshot;
  final String teamAbbrev;
  final List<String> assists;
  final int awayScore;
  final int homeScore;
  final String strength;
  final int? playerId;
  final int? goalsToDate;
  final String? goalModifier;

  const GameGoal({
    required this.period,
    required this.timeInPeriod,
    required this.scorerName,
    this.scorerMugshot,
    required this.teamAbbrev,
    this.assists = const [],
    required this.awayScore,
    required this.homeScore,
    this.strength = 'ev',
    this.playerId,
    this.goalsToDate,
    this.goalModifier,
  });
}

class ScheduleGame {
  final int gameId;
  final DateTime date;
  final DateTime? startTimeUtc;
  final String? venue;
  final GameState gameState;
  final GameTeam? awayTeam;
  final GameTeam? homeTeam;
  final GameClock? clock;
  final int? period;
  final String? periodType;
  final int? maxRegulationPeriods;
  final String? gameOutcomeLastPeriodType;
  final List<GameGoal> goals;
  final bool neutralSite;

  const ScheduleGame({
    required this.gameId,
    required this.date,
    this.startTimeUtc,
    this.venue,
    required this.gameState,
    this.awayTeam,
    this.homeTeam,
    this.clock,
    this.period,
    this.periodType,
    this.maxRegulationPeriods,
    this.gameOutcomeLastPeriodType,
    this.goals = const [],
    this.neutralSite = false,
  });

  // Backward-compatible getters for existing consumers (watchlist, etc.)
  String get homeTeamAbbrev => homeTeam?.abbrev ?? '';
  String get awayTeamAbbrev => awayTeam?.abbrev ?? '';
  String? get homeTeamName => homeTeam?.name;
  String? get awayTeamName => awayTeam?.name;
  String? get homeTeamLogo => homeTeam?.logoUrl;
  String? get awayTeamLogo => awayTeam?.logoUrl;
  int? get homeScore => homeTeam?.score;
  int? get awayScore => awayTeam?.score;
}
