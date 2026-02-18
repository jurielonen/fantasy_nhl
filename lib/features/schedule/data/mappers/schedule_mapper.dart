import '../../domain/entities/game_day.dart';
import '../../domain/entities/schedule_game.dart';
import '../dtos/game_day_dto.dart';
import '../dtos/schedule_team_dto.dart';
import '../dtos/schedule_dto.dart';
import '../dtos/club_week_schedule_dto.dart';

// ── GameDayResponseDto → GameDay ────────────────────────────────────────────

extension GameDayResponseDtoMapper on GameDayResponseDto {
  GameDay toEntity() => GameDay(
        prevDate: prevDate,
        currentDate: currentDate ?? '',
        nextDate: nextDate,
        weekDays: (gameWeek ?? []).map((d) => d.toEntity()).toList(),
        games: (games ?? []).map((g) => g.toEntity()).toList(),
      );

  List<ScheduleGame> toGames() =>
      (games ?? []).map((g) => g.toEntity()).toList();
}

extension GameWeekDayDtoMapper on GameWeekDayDto {
  GameWeekDay toEntity() => GameWeekDay(
        date: date ?? '',
        dayAbbrev: dayAbbrev ?? '',
        numberOfGames: numberOfGames ?? 0,
      );
}

extension GameDtoMapper on GameDto {
  ScheduleGame toEntity() => ScheduleGame(
        gameId: id ?? 0,
        date: gameDate ?? '',
        startTimeUtc: startTimeUTC,
        venue: venue,
        gameState: GameState.fromApiString(gameState),
        awayTeam: awayTeam?.toEntity(),
        homeTeam: homeTeam?.toEntity(),
        clock: clock?.toEntity(),
        period: period,
        periodType: periodDescriptor?.periodType,
        maxRegulationPeriods: periodDescriptor?.maxRegulationPeriods,
        gameOutcomeLastPeriodType: gameOutcome?.lastPeriodType,
        goals: (goals ?? []).map((g) => g.toEntity()).toList(),
        neutralSite: neutralSite ?? false,
      );
}

extension GameTeamDtoMapper on GameTeamDto {
  GameTeam toEntity() => GameTeam(
        id: id,
        name: name ?? '',
        abbrev: abbrev ?? '',
        score: score,
        shotsOnGoal: sog,
        logoUrl: logo,
      );
}

extension GameClockDtoMapper on GameClockDto {
  GameClock toEntity() => GameClock(
        timeRemaining: timeRemaining ?? '00:00',
        secondsRemaining: secondsRemaining ?? 0,
        isRunning: running ?? false,
        inIntermission: inIntermission ?? false,
      );
}

extension GoalDtoMapper on GoalDto {
  GameGoal toEntity() => GameGoal(
        period: period ?? 0,
        timeInPeriod: timeInPeriod ?? '',
        scorerName: name ?? '${firstName ?? ''} ${lastName ?? ''}'.trim(),
        scorerMugshot: mugshot,
        teamAbbrev: teamAbbrev ?? '',
        assists: (assists ?? [])
            .map((a) => a.name ?? '')
            .where((n) => n.isNotEmpty)
            .toList(),
        awayScore: awayScore ?? 0,
        homeScore: homeScore ?? 0,
        strength: strength ?? 'ev',
        playerId: playerId,
        goalsToDate: goalsToDate,
        goalModifier: goalModifier,
      );
}

// ── Legacy mappers (ScheduleDto / ScheduleGameDto) ──────────────────────────

extension ScheduleGameDtoMapper on ScheduleGameDto {
  ScheduleGame toEntity() => ScheduleGame(
        gameId: id ?? 0,
        date: gameDate ?? '',
        startTimeUtc: startTimeUTC,
        venue: venue,
        gameState: GameState.fromApiString(gameState),
        awayTeam: awayTeam != null
            ? GameTeam(
                id: awayTeam!.id,
                name: awayTeam!.commonName ?? awayTeam!.name ?? '',
                abbrev: awayTeam!.abbrev ?? '',
                score: awayTeam!.score,
                shotsOnGoal: awayTeam!.sog,
                logoUrl: awayTeam!.logo,
              )
            : null,
        homeTeam: homeTeam != null
            ? GameTeam(
                id: homeTeam!.id,
                name: homeTeam!.commonName ?? homeTeam!.name ?? '',
                abbrev: homeTeam!.abbrev ?? '',
                score: homeTeam!.score,
                shotsOnGoal: homeTeam!.sog,
                logoUrl: homeTeam!.logo,
              )
            : null,
      );
}

extension ScheduleDtoMapper on ScheduleDto {
  List<ScheduleGame> toGames() => (gameWeek ?? [])
      .expand((day) => day.games ?? <ScheduleGameDto>[])
      .map((g) => g.toEntity())
      .toList();
}

extension ClubWeekScheduleDtoMapper on ClubWeekScheduleDto {
  List<ScheduleGame> toGames() =>
      (games ?? []).map((g) => g.toEntity()).toList();
}
