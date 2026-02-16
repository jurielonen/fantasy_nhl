import 'dart:convert';

import '../../../../core/network/nhl_web_api_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/schedule_game.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../dtos/club_week_schedule_dto.dart';
import '../dtos/schedule_dto.dart';
import '../dtos/scores_dto.dart';
import '../mappers/schedule_mapper.dart';

class ScheduleRepositoryImpl implements ScheduleRepository {
  final NhlWebApiClient _webApiClient;
  final LocalStorageService _storage;

  ScheduleRepositoryImpl({
    required NhlWebApiClient webApiClient,
    required LocalStorageService storage,
  })  : _webApiClient = webApiClient,
        _storage = storage;

  @override
  Future<List<ScheduleGame>> getTodaySchedule() async {
    final cacheKey = 'schedule:today';

    // Short TTL — schedule data changes frequently on game day
    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 5)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = ScheduleDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toGames();
      }
    }

    final dto = await _webApiClient.getTodaySchedule();

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getScheduleByDate(String date) async {
    final cacheKey = 'schedule:$date';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 5)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = ScheduleDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toGames();
      }
    }

    final dto = await _webApiClient.getScheduleByDate(date);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getTeamWeekSchedule(String teamAbbrev) async {
    final cacheKey = 'club_schedule:$teamAbbrev';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 30)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = ClubWeekScheduleDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toGames();
      }
    }

    final dto = await _webApiClient.getClubWeekSchedule(teamAbbrev);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getTodayScores() async {
    final cacheKey = 'scores:today';

    // Very short TTL for live score data
    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 2)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = ScoresDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toGames();
      }
    }

    final dto = await _webApiClient.getTodayScores();

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toGames();
  }

  @override
  Future<List<ScheduleGame>> getScoresByDate(String date) async {
    final cacheKey = 'scores:$date';

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 2)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = ScoresDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toGames();
      }
    }

    final dto = await _webApiClient.getScoresByDate(date);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

    return dto.toGames();
  }
}
