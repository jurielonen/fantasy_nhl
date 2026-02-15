import 'dart:convert';

import '../../../../core/network/nhl_stats_api_client.dart';
import '../../../../core/network/nhl_web_api_client.dart';
import '../../../../core/storage/local_storage_service.dart';
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
  final LocalStorageService _storage;

  PlayerRepositoryImpl({
    required NhlWebApiClient webApiClient,
    required NhlStatsApiClient statsApiClient,
    required LocalStorageService storage,
  })  : _webApiClient = webApiClient,
        _statsApiClient = statsApiClient,
        _storage = storage;

  @override
  Future<List<Player>> searchPlayers(String query) async {
    final dto = await _statsApiClient.searchPlayers(
      cayenneExp: 'lastName likeIgnoreCase "%$query%" or '
          'firstName likeIgnoreCase "%$query%"',
      limit: 50,
    );
    return (dto.data ?? []).map((p) => p.toPlayer()).toList();
  }

  @override
  Future<PlayerDetail> getPlayerDetail(int id) async {
    final cacheKey = 'player_detail:$id';

    if (!_storage.isCacheExpired(cacheKey)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = PlayerLandingDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toPlayerDetail();
      }
    }

    final dto = await _webApiClient.getPlayerLanding(id);

    // Cache the full DTO for detail views
    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    // Also cache basic player info for quick lookups
    final model = dto.toPlayer().toCachedModel();
    await _storage.setJson('cache:player:$id', model.toJson());

    return dto.toPlayerDetail();
  }

  @override
  Future<List<GameLogEntry>> getGameLog(int id) async {
    final cacheKey = 'game_log:$id';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 30)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        return (json['gameLog'] as List?)
                ?.map((e) =>
                    GameLogEntryDto.fromJson(e as Map<String, dynamic>)
                        .toEntity())
                .toList() ??
            [];
      }
    }

    final dto = await _webApiClient.getCurrentGameLog(id);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toEntities();
  }

  @override
  Future<List<Player>> getTeamRoster(String teamAbbrev) async {
    final cacheKey = 'roster:$teamAbbrev';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 60)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = RosterDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return _flattenRoster(dto);
      }
    }

    final dto = await _webApiClient.getRoster(teamAbbrev);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

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

    if (!_storage.isCacheExpired(cacheKey)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        // Re-parse from cached raw JSON
        final json = jsonDecode(cached) as Map<String, dynamic>;
        final dto = SkaterLeadersDto.fromJson(json);
        return dto.toLeaders(category);
      }
    }

    final dto = await _webApiClient.getSkaterLeaders(
      categories: category,
      limit: limit,
    );

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toLeaders(category);
  }

  @override
  Future<List<StatLeader>> getGoalieLeaders(
    String category, {
    int? limit,
  }) async {
    final cacheKey = 'goalie_leaders:$category:${limit ?? -1}';

    if (!_storage.isCacheExpired(cacheKey)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        final dto = GoalieLeadersDto.fromJson(json);
        return dto.toLeaders(category);
      }
    }

    final dto = await _webApiClient.getGoalieLeaders(
      categories: category,
      limit: limit,
    );

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toLeaders(category);
  }

  @override
  Future<List<Player>> getSpotlightPlayers() async {
    final cacheKey = 'spotlight';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 60)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final list = jsonDecode(cached) as List;
        return list
            .map((e) =>
                SpotlightPlayerDto.fromJson(e as Map<String, dynamic>)
                    .toPlayer())
            .toList();
      }
    }

    final dtos = await _webApiClient.getPlayerSpotlight();

    await _storage.setString(
      'cache:$cacheKey',
      jsonEncode(dtos.map((d) => d.toJson()).toList()),
    );
    await _storage.setCacheTimestamp(cacheKey);

    return dtos.map((d) => d.toPlayer()).toList();
  }
}
