import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/player/data/dtos/player_landing_dto.dart';
import '../../features/player/data/dtos/game_log_dto.dart';
import '../../features/player/data/dtos/spotlight_player_dto.dart';
import '../../features/player/data/dtos/skater_leaders_dto.dart';
import '../../features/player/data/dtos/goalie_leaders_dto.dart';
import '../../features/player/data/dtos/roster_dto.dart';
import '../../features/schedule/data/dtos/standings_dto.dart';
import '../../features/schedule/data/dtos/schedule_dto.dart';
import '../../features/schedule/data/dtos/club_week_schedule_dto.dart';
import '../../features/schedule/data/dtos/game_day_dto.dart';
import '../../features/schedule/data/dtos/scoreboard_dto.dart';

part 'nhl_web_api_client.g.dart';

@RestApi()
abstract class NhlWebApiClient {
  factory NhlWebApiClient(Dio dio, {String? baseUrl}) = _NhlWebApiClient;

  // Player endpoints
  @GET('/v1/player/{playerId}/landing')
  Future<PlayerLandingDto> getPlayerLanding(
    @Path('playerId') int playerId,
  );

  @GET('/v1/player/{playerId}/game-log/now')
  Future<GameLogDto> getCurrentGameLog(
    @Path('playerId') int playerId,
  );

  @GET('/v1/player/{playerId}/game-log/{season}/{gameType}')
  Future<GameLogDto> getGameLog(
    @Path('playerId') int playerId,
    @Path('season') String season,
    @Path('gameType') int gameType,
  );

  @GET('/v1/player-spotlight')
  Future<List<SpotlightPlayerDto>> getPlayerSpotlight();

  // Stat leaders
  @GET('/v1/skater-stats-leaders/current')
  Future<SkaterLeadersDto> getSkaterLeaders({
    @Query('categories') String? categories,
    @Query('limit') int? limit,
  });

  @GET('/v1/goalie-stats-leaders/current')
  Future<GoalieLeadersDto> getGoalieLeaders({
    @Query('categories') String? categories,
    @Query('limit') int? limit,
  });

  // Team / roster
  @GET('/v1/roster/{team}/current')
  Future<RosterDto> getRoster(
    @Path('team') String team,
  );

  // Standings
  @GET('/v1/standings/now')
  Future<StandingsDto> getStandings();

  // Schedule
  @GET('/v1/schedule/now')
  Future<ScheduleDto> getTodaySchedule();

  @GET('/v1/club-schedule/{team}/week/now')
  Future<ClubWeekScheduleDto> getClubWeekSchedule(
    @Path('team') String team,
  );

  // Scores
  @GET('/v1/score/now')
  Future<GameDayResponseDto> getTodayScores();

  @GET('/v1/score/{date}')
  Future<GameDayResponseDto> getScoresByDate(@Path('date') String date);

  @GET('/v1/scoreboard/now')
  Future<ScoreboardDto> getScoreboard();
}
