import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/player/data/dtos/stats_player_search_dto.dart';
import '../../features/player/data/dtos/stats_team_list_dto.dart';

part 'nhl_stats_api_client.g.dart';

@RestApi()
abstract class NhlStatsApiClient {
  factory NhlStatsApiClient(Dio dio, {String? baseUrl}) = _NhlStatsApiClient;

  @GET('/en/players')
  Future<StatsPlayerSearchDto> searchPlayers({
    @Query('cayenneExp') String? cayenneExp,
    @Query('sort') String? sort,
    @Query('dir') String? dir,
    @Query('start') int? start,
    @Query('limit') int limit = 100,
  });

  @GET('/en/team')
  Future<StatsTeamListDto> getTeams();
}
