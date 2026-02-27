import 'dart:convert';

import '../../../../core/database/daos/api_cache_dao.dart';
import '../../../../core/network/nhl_web_api_client.dart';
import '../../domain/entities/game_day.dart';
import '../../domain/entities/schedule_game.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../dtos/club_week_schedule_dto.dart';
import '../dtos/game_day_dto.dart';
import '../dtos/schedule_dto.dart';
import '../mappers/schedule_mapper.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final NhlWebApiClient _webApiClient;
  final ApiCacheDao _apiCacheDao;

  ScheduleRepositoryImpl({
    required NhlWebApiClient webApiClient,
    required ApiCacheDao apiCacheDao,
  }) : _webApiClient = webApiClient,
       _apiCacheDao = apiCacheDao;

  @override
  Future<GameDay> getGameDay(String? date) async {
    final cacheKey = date == null ? 'gameday:now' : 'gameday:$date';
    final ttl = _gameDayTtl(date);

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = GameDayResponseDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toEntity();
    }

    final dto = date == null
        ? await _webApiClient.getTodayScores()
        : await _webApiClient.getScoresByDate(date);

    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), ttl);
    return dto.toEntity();
  }

  /// 5 min TTL for today, 60 min for past dates, 15 min for future dates.
  int _gameDayTtl(String? date) {
    if (date == null) return 5;
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (date == today) return 5;
    return date.compareTo(today) < 0 ? 60 : 15;
  }

  @override
  Future<List<ScheduleGame>> getTodaySchedule() async {
    const cacheKey = 'schedule:today';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = ScheduleDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toGames();
    }

    final dto = await _webApiClient.getTodaySchedule();
    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 5);
    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getTeamWeekSchedule(String teamAbbrev) async {
    final cacheKey = 'club_schedule:$teamAbbrev';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = ClubWeekScheduleDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toGames();
    }

    final dto = await _webApiClient.getClubWeekSchedule(teamAbbrev);
    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 30);
    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getTodayScores() async {
    const cacheKey = 'scores:today';

    final cached = await _apiCacheDao.get(cacheKey);
    if (cached != null && !_apiCacheDao.isExpired(cached)) {
      final dto = GameDayResponseDto.fromJson(
        jsonDecode(cached.data) as Map<String, dynamic>,
      );
      return dto.toGames();
    }

    final dto = await _webApiClient.getTodayScores();
    await _apiCacheDao.set(cacheKey, jsonEncode(dto.toJson()), 2);
    return dto.toGames();
  }
}
