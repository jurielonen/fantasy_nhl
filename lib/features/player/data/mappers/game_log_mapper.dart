import '../../domain/entities/game_log_entry.dart';
import '../dtos/game_log_dto.dart';

extension GameLogEntryDtoMapper on GameLogEntryDto {
  GameLogEntry toEntity() => GameLogEntry(
        gameId: gameId ?? 0,
        date: gameDate ?? '',
        opponent: commonName ?? '',
        opponentAbbrev: opponentAbbrev ?? '',
        homeAway: homeRoadFlg ?? 'H',
        toi: toi,
        goals: goals,
        assists: assists,
        points: points,
        plusMinus: plusMinus,
        shots: shots,
        pim: pim,
        ppGoals: powerPlayGoals,
        shGoals: shorthandedGoals,
        gwGoals: gameWinningGoals,
        decision: decision,
        shotsAgainst: shotsAgainst,
        goalsAgainst: goalsAgainst,
        savePctg: savePctg,
      );
}

extension GameLogDtoMapper on GameLogDto {
  List<GameLogEntry> toEntities() =>
      (gameLog ?? []).map((e) => e.toEntity()).toList();
}
