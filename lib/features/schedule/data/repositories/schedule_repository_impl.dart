import 'dart:convert';

import '../../../../core/network/nhl_web_api_client.dart';
import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/game_day.dart';
import '../../domain/entities/schedule_game.dart';
import '../../domain/repositories/schedule_repository.dart';
import '../dtos/club_week_schedule_dto.dart';
import '../dtos/game_day_dto.dart';
import '../dtos/schedule_dto.dart';
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
  Future<GameDay> getGameDay(String? date) async {
    final cacheKey = date == null ? 'gameday:now' : 'gameday:$date';
    final ttl = _gameDayTtl(date);

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: ttl)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = GameDayResponseDto.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
        return dto.toEntity();
      }
    }

    final dto = date == null
        ? await _webApiClient.getTodayScores()
        : await _webApiClient.getScoresByDate(date);

    await _storage.setString('cache:$cacheKey', jsonEncode(dto.toJson()));
    await _storage.setCacheTimestamp(cacheKey);

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
    final cacheKey = 'schedule:today';

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

    if (!_storage.isCacheExpired(cacheKey, ttlMinutes: 2)) {
      final cached = _storage.getString('cache:$cacheKey');
      if (cached != null) {
        final dto = GameDayResponseDto.fromJson(
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
}
