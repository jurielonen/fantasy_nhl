import '../../domain/entities/schedule_game.dart';
import '../dtos/schedule_team_dto.dart';
import '../dtos/schedule_dto.dart';
import '../dtos/scores_dto.dart';
import '../dtos/club_week_schedule_dto.dart';

extension ScheduleGameDtoMapper on ScheduleGameDto {
  ScheduleGame toEntity() => ScheduleGame(
        gameId: id ?? 0,
        date: gameDate ?? '',
        startTimeUtc: startTimeUTC,
        homeTeamAbbrev: homeTeam?.abbrev ?? '',
        awayTeamAbbrev: awayTeam?.abbrev ?? '',
        homeTeamName: homeTeam?.commonName ?? homeTeam?.name,
        awayTeamName: awayTeam?.commonName ?? awayTeam?.name,
        homeTeamLogo: homeTeam?.logo,
        awayTeamLogo: awayTeam?.logo,
        homeScore: homeTeam?.score,
        awayScore: awayTeam?.score,
        gameState: GameState.fromApiString(gameState),
      );
}

extension ScheduleDtoMapper on ScheduleDto {
  List<ScheduleGame> toGames() => (gameWeek ?? [])
      .expand((day) => day.games ?? <ScheduleGameDto>[])
      .map((g) => g.toEntity())
      .toList();
}

extension ScoresDtoMapper on ScoresDto {
  List<ScheduleGame> toGames() =>
      (games ?? []).map((g) => g.toEntity()).toList();
}

extension ClubWeekScheduleDtoMapper on ClubWeekScheduleDto {
  List<ScheduleGame> toGames() =>
      (games ?? []).map((g) => g.toEntity()).toList();
}
