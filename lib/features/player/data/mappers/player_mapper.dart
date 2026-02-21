import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/player_detail.dart';
import '../dtos/player_landing_dto.dart';
import '../dtos/player_stats_dto.dart';
import '../dtos/roster_dto.dart';
import '../dtos/spotlight_player_dto.dart';
import '../dtos/stats_player_search_dto.dart';

// -- PlayerLandingDto → Player / PlayerDetail --

extension PlayerLandingDtoMapper on PlayerLandingDto {
  Player toPlayer() => Player(
        id: playerId ?? 0,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        teamAbbrev: currentTeamAbbrev,
        teamName: fullTeamName,
        position: position ?? 'C',
        sweaterNumber: sweaterNumber,
        headshot: headshot,
        isActive: isActive ?? true,
      );

  PlayerDetail toPlayerDetail() => PlayerDetail(
        player: toPlayer(),
        bio: PlayerBio(
          heightInInches: heightInInches,
          weightInPounds: weightInPounds,
          birthDate: birthDate,
          birthCity: birthCity,
          birthCountry: birthCountry,
          shootsCatches: shootsCatches,
          draftInfo: draftDetails?._toDraftInfo(),
        ),
        currentSeasonStats: _mapStats(
          featuredStats?.regularSeason?.subSeason,
          position,
        ),
        careerStats: _mapStats(
          careerTotals?.regularSeason,
          position,
        ),
        seasonBySeasonStats: (seasonTotals ?? [])
            .map((s) => s._toSeasonRecord(position))
            .toList(),
      );
}

extension on DraftDetailsDto {
  DraftInfo _toDraftInfo() => DraftInfo(
        year: year ?? 0,
        teamAbbrev: teamAbbrev,
        round: round ?? 0,
        pickInRound: pickInRound ?? 0,
        overallPick: overallPick ?? 0,
      );
}

extension on SeasonTotalDto {
  PlayerSeasonRecord _toSeasonRecord(String? position) => PlayerSeasonRecord(
        season: season ?? 0,
        gameTypeId: gameTypeId ?? 2,
        leagueAbbrev: leagueAbbrev,
        teamName: teamName,
        stats: _mapSeasonTotalStats(position),
      );

  PlayerSeasonStats _mapSeasonTotalStats(String? position) {
    if (position == 'G') {
      return GoalieSeasonStats(
        gamesPlayed: gamesPlayed ?? 0,
        wins: wins ?? 0,
        losses: losses ?? 0,
        otLosses: otLosses ?? 0,
        gaa: goalsAgainstAvg ?? 0.0,
        savePctg: savePctg ?? 0.0,
        shutouts: shutouts ?? 0,
      );
    }
    return SkaterSeasonStats(
      gamesPlayed: gamesPlayed ?? 0,
      goals: goals ?? 0,
      assists: assists ?? 0,
      points: points ?? 0,
      plusMinus: plusMinus ?? 0,
      pim: pim ?? 0,
      gameWinningGoals: gameWinningGoals ?? 0,
      otGoals: otGoals ?? 0,
      shots: shots ?? 0,
      shootingPctg: shootingPctg,
      avgToi: avgToi,
      faceoffPctg: faceoffPctg,
      ppGoals: powerPlayGoals,
      shGoals: shorthandedGoals,
    );
  }
}

PlayerSeasonStats? _mapStats(SubSeasonStatsDto? stats, String? position) {
  if (stats == null) return null;
  if (position == 'G') {
    return GoalieSeasonStats(
      gamesPlayed: stats.gamesPlayed ?? 0,
      wins: stats.wins ?? 0,
      losses: stats.losses ?? 0,
      otLosses: stats.otLosses ?? 0,
      gaa: stats.goalsAgainstAvg ?? 0.0,
      savePctg: stats.savePctg ?? 0.0,
      shutouts: stats.shutouts ?? 0,
    );
  }
  return SkaterSeasonStats(
    gamesPlayed: stats.gamesPlayed ?? 0,
    goals: stats.goals ?? 0,
    assists: stats.assists ?? 0,
    points: stats.points ?? 0,
    plusMinus: stats.plusMinus ?? 0,
    pim: stats.pim ?? 0,
    gameWinningGoals: stats.gameWinningGoals ?? 0,
    otGoals: stats.otGoals ?? 0,
    shots: stats.shots ?? 0,
    shootingPctg: stats.shootingPctg,
    avgToi: stats.avgToi,
    faceoffPctg: stats.faceoffPctg,
    ppGoals: stats.powerPlayGoals,
    shGoals: stats.shorthandedGoals,
  );
}

// -- RosterPlayerDto → Player --

extension RosterPlayerDtoMapper on RosterPlayerDto {
  Player toPlayer() => Player(
        id: id ?? 0,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        position: positionCode ?? 'C',
        sweaterNumber: sweaterNumber,
        headshot: headshot,
      );
}

// -- SpotlightPlayerDto → Player --

extension SpotlightPlayerDtoMapper on SpotlightPlayerDto {
  Player toPlayer() {
    final parts = (name ?? '').split(' ');
    return Player(
      id: playerId ?? 0,
      firstName: parts.isNotEmpty ? parts.first : '',
      lastName: parts.length > 1 ? parts.sublist(1).join(' ') : '',
      teamAbbrev: teamTriCode,
      position: position ?? 'C',
      sweaterNumber: sweaterNumber,
      headshot: headshot,
    );
  }
}

// -- StatsPlayerDto → Player --

extension StatsPlayerDtoMapper on StatsPlayerDto {
  Player toPlayer() => Player(
        id: playerId ?? 0,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        teamAbbrev: currentTeamAbbrev,
        teamName: currentTeamName,
        position: positionCode ?? 'C',
        sweaterNumber: sweaterNumber,
        headshot: headshot,
        isActive: isActive ?? true,
      );
}

// -- CachedPlayerRow ↔ Player (Drift) --

extension CachedPlayerRowMapper on CachedPlayerRow {
  Player toPlayer() => Player(
        id: id,
        firstName: firstName,
        lastName: lastName,
        teamAbbrev: teamAbbrev,
        teamName: teamName,
        position: position,
        sweaterNumber: sweaterNumber,
        headshot: headshot,
        isActive: isActive,
      );
}

extension PlayerToStorage on Player {
  CachedPlayersCompanion toCachedCompanion() => CachedPlayersCompanion.insert(
        id: Value(id),
        firstName: firstName,
        lastName: lastName,
        teamAbbrev: Value(teamAbbrev),
        teamName: Value(teamName),
        position: position,
        sweaterNumber: Value(sweaterNumber),
        headshot: Value(headshot),
        isActive: Value(isActive),
      );
}
