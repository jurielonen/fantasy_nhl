class GameLogEntry {
  final int gameId;
  final DateTime date;
  final String opponent;
  final String opponentAbbrev;
  final String homeAway;
  final String? toi;

  // Skater stats
  final int? goals;
  final int? assists;
  final int? points;
  final int? plusMinus;
  final int? shots;
  final int? pim;
  final int? ppGoals;
  final int? shGoals;
  final int? gwGoals;

  // Goalie stats
  final String? decision;
  final int? shotsAgainst;
  final int? goalsAgainst;
  final double? savePctg;

  const GameLogEntry({
    required this.gameId,
    required this.date,
    required this.opponent,
    required this.opponentAbbrev,
    required this.homeAway,
    this.toi,
    this.goals,
    this.assists,
    this.points,
    this.plusMinus,
    this.shots,
    this.pim,
    this.ppGoals,
    this.shGoals,
    this.gwGoals,
    this.decision,
    this.shotsAgainst,
    this.goalsAgainst,
    this.savePctg,
  });

  bool get isGoalie => decision != null;
}
