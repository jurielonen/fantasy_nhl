import 'dart:convert';

import '../../../../core/database/daos/api_cache_dao.dart';
import '../../../../core/database/daos/player_cache_dao.dart';
import '../../../../core/network/nhl_stats_api_client.dart';
import '../../../../core/network/nhl_web_api_client.dart';
import '../../domain/entities/game_log_entry.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/player_detail.dart';
import '../../domain/entities/stat_leader.dart';
import '../../domain/repositories/player_repository.dart';
import '../dtos/game_log_dto.dart';
import '../dtos/goalie_leaders_dto.dart';
import '../dtos/player_landing_dto.dart';
import '../dtos/roster_dto.dart';
import '../dtos/skater_leaders_dto.dart';
import '../dtos/spotlight_player_dto.dart';
import '../mappers/game_log_mapper.dart';
import '../mappers/player_mapper.dart';
import '../mappers/stat_leader_mapper.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final NhlWebApiClient _webApiClient;
  final NhlStatsApiClient _statsApiClient;
  final PlayerCacheDao _playerCacheDao;
  final ApiCacheDao _apiCacheDao;

  PlayerRepositoryImpl({
    required NhlWebApiClient webApiClient,
    required NhlStatsApiClient statsApiClient,
    required PlayerCacheDao playerCacheDao,
    required ApiCacheDao apiCacheDao,
  }) : _webApiClient = webApiClient,
       _statsApiClient = statsApiClient,
       _playerCacheDao = playerCacheDao,
       _apiCacheDao = apiCacheDao;

  @override
  Future<List<Player>> searchPlayers(String query) async {
    final dto = await _statsApiClient.searchPlayers(
      cayenneExp:
          'lastName likeIgnoreCase "%$query%" or '
          'firstName likeIgnoreCase "%$query%"',
      limit: 50,
    );
    return (dto.data ?? []).map((p) => p.toPlayer()).toList();
  }

  @override
  Future<PlayerDetail> getPlayerDetail(int id) async {
    final cacheKey = 'player_detail:$id';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = PlayerLandingDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toPlayerDetail();
    }

    final dto = await _webApiClient.getPlayerLanding(id);

    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 15);
    // Also cache basic player info for quick lookups
    await _playerCacheDao.upsert(dto.toPlayer().toCachedCompanion());

    return dto.toPlayerDetail();
  }

  @override
  Future<List<GameLogEntry>> getGameLog(int id) async {
    final cacheKey = 'game_log:$id';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final json = jsonDecode(cached.data) as Map<String, dynamic>;
      return (json['gameLog'] as List?)
              ?.map(
                (e) => GameLogEntryDto.fromJson(
                  e as Map<String, dynamic>,
                ).toEntity(),
              )
              .toList() ??
          [];
    }

    final dto = await _webApiClient.getCurrentGameLog(id);

    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 30);
    return dto.toEntities();
  }

  @override
  Future<List<Player>> getTeamRoster(String teamAbbrev) async {
    final cacheKey = 'roster:$teamAbbrev';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = RosterDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return _flattenRoster(dto);
    }

    final dto = await _webApiClient.getRoster(teamAbbrev);
    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 60);
    return _flattenRoster(dto);
  }

  List<Player> _flattenRoster(RosterDto dto) => [
    ...(dto.forwards ?? []).map((p) => p.toPlayer()),
    ...(dto.defensemen ?? []).map((p) => p.toPlayer()),
    ...(dto.goalies ?? []).map((p) => p.toPlayer()),
  ];

  @override
  Future<List<StatLeader>> getSkaterLeaders(
    String category, {
    int? limit,
  }) async {
    final cacheKey = 'skater_leaders:$category:${limit ?? -1}';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = SkaterLeadersDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toLeaders(category);
    }

    final dto = await _webApiClient.getSkaterLeaders(
      categories: category,
      limit: limit,
    );

    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 15);
    return dto.toLeaders(category);
  }

  @override
  Future<List<StatLeader>> getGoalieLeaders(
    String category, {
    int? limit,
  }) async {
    final cacheKey = 'goalie_leaders:$category:${limit ?? -1}';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = GoalieLeadersDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toLeaders(category);
    }

    final dto = await _webApiClient.getGoalieLeaders(
      categories: category,
      limit: limit,
    );

    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 15);
    return dto.toLeaders(category);
  }

  @override
  Future<List<Player>> getSpotlightPlayers() async {
    const cacheKey = 'spotlight';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final list = jsonDecode(cached.data) as List;
      return list
          .map(
            (e) => SpotlightPlayerDto.fromJson(
              e as Map<String, dynamic>,
            ).toPlayer(),
          )
          .toList();
    }

    final dtos = await _webApiClient.getPlayerSpotlight();
    await _apiCacheDao.set(
      cacheKey,
      jsonEncode(dtos.map((d) => d.toJson()).toList()),
      60,
    );
    return dtos.map((d) => d.toPlayer()).toList();
  }

  @override
  Future<Player?> getCachedPlayer(int id) async {
    final row = await _playerCacheDao.getById(id);
    return row?.toPlayer();
  }

  @override
  Future<Player> getPlayerBasicInfo(int id) async {
    final cached = await getCachedPlayer(id);
    if (cached != null) return cached;

    final detail = await getPlayerDetail(id);
    return detail.player;
  }
}
