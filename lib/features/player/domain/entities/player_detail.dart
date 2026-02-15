import 'player.dart';

class PlayerDetail {
  final Player player;
  final PlayerBio bio;
  final PlayerSeasonStats? currentSeasonStats;
  final PlayerSeasonStats? careerStats;
  final List<PlayerSeasonRecord> seasonBySeasonStats;

  const PlayerDetail({
    required this.player,
    required this.bio,
    this.currentSeasonStats,
    this.careerStats,
    this.seasonBySeasonStats = const [],
  });
}

class PlayerBio {
  final int? heightInInches;
  final int? weightInPounds;
  final String? birthDate;
  final String? birthCity;
  final String? birthCountry;
  final String? shootsCatches;
  final DraftInfo? draftInfo;

  const PlayerBio({
    this.heightInInches,
    this.weightInPounds,
    this.birthDate,
    this.birthCity,
    this.birthCountry,
    this.shootsCatches,
    this.draftInfo,
  });
}

class DraftInfo {
  final int year;
  final String? teamAbbrev;
  final int round;
  final int pickInRound;
  final int overallPick;

  const DraftInfo({
    required this.year,
    this.teamAbbrev,
    required this.round,
    required this.pickInRound,
    required this.overallPick,
  });
}

// -- Stats (sealed for skater/goalie distinction) --

sealed class PlayerSeasonStats {
  int get gamesPlayed;
}

class SkaterSeasonStats implements PlayerSeasonStats {
  @override
  final int gamesPlayed;
  final int goals;
  final int assists;
  final int points;
  final int plusMinus;
  final int pim;
  final int gameWinningGoals;
  final int otGoals;
  final int shots;
  final double? shootingPctg;
  final String? avgToi;
  final double? faceoffPctg;
  final int? ppGoals;
  final int? shGoals;

  const SkaterSeasonStats({
    required this.gamesPlayed,
    this.goals = 0,
    this.assists = 0,
    this.points = 0,
    this.plusMinus = 0,
    this.pim = 0,
    this.gameWinningGoals = 0,
    this.otGoals = 0,
    this.shots = 0,
    this.shootingPctg,
    this.avgToi,
    this.faceoffPctg,
    this.ppGoals,
    this.shGoals,
  });
}

class GoalieSeasonStats implements PlayerSeasonStats {
  @override
  final int gamesPlayed;
  final int wins;
  final int losses;
  final int otLosses;
  final double gaa;
  final double savePctg;
  final int shutouts;

  const GoalieSeasonStats({
    required this.gamesPlayed,
    this.wins = 0,
    this.losses = 0,
    this.otLosses = 0,
    this.gaa = 0.0,
    this.savePctg = 0.0,
    this.shutouts = 0,
  });
}

class PlayerSeasonRecord {
  final int season;
  final int gameTypeId;
  final String? leagueAbbrev;
  final String? teamName;
  final PlayerSeasonStats stats;

  const PlayerSeasonRecord({
    required this.season,
    required this.gameTypeId,
    this.leagueAbbrev,
    this.teamName,
    required this.stats,
  });
}
