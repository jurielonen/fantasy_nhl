import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fantasy_nhl/core/database/app_database.dart';
import 'package:fantasy_nhl/core/database/daos/api_cache_dao.dart';
import 'package:fantasy_nhl/core/database/daos/player_cache_dao.dart';
import 'package:fantasy_nhl/core/network/nhl_stats_api_client.dart';
import 'package:fantasy_nhl/core/network/nhl_web_api_client.dart';
import 'package:fantasy_nhl/features/player/data/dtos/player_landing_dto.dart';
import 'package:fantasy_nhl/features/player/data/dtos/player_stats_dto.dart';
import 'package:fantasy_nhl/features/player/data/repositories/player_repository_impl.dart';
import 'package:fantasy_nhl/features/player/domain/entities/player_detail.dart';

class MockNhlWebApiClient extends Mock implements NhlWebApiClient {}

class MockNhlStatsApiClient extends Mock implements NhlStatsApiClient {}

class MockApiCacheDao extends Mock implements ApiCacheDao {}

class MockPlayerCacheDao extends Mock implements PlayerCacheDao {}

class FakeCachedPlayersCompanion extends Fake implements CachedPlayersCompanion {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeCachedPlayersCompanion());
  });
  late PlayerRepositoryImpl repository;
  late MockNhlWebApiClient mockWebClient;
  late MockNhlStatsApiClient mockStatsClient;
  late MockApiCacheDao mockApiCacheDao;
  late MockPlayerCacheDao mockPlayerCacheDao;

  setUp(() {
    mockWebClient = MockNhlWebApiClient();
    mockStatsClient = MockNhlStatsApiClient();
    mockApiCacheDao = MockApiCacheDao();
    mockPlayerCacheDao = MockPlayerCacheDao();

    repository = PlayerRepositoryImpl(
      webApiClient: mockWebClient,
      statsApiClient: mockStatsClient,
      playerCacheDao: mockPlayerCacheDao,
      apiCacheDao: mockApiCacheDao,
    );
  });

  final testDto = PlayerLandingDto(
    playerId: 8478402,
    isActive: true,
    currentTeamAbbrev: 'TOR',
    fullTeamName: 'Toronto Maple Leafs',
    firstName: 'Auston',
    lastName: 'Matthews',
    position: 'C',
    headshot: 'https://example.com/headshot.png',
    sweaterNumber: 34,
    heightInInches: 75,
    weightInPounds: 220,
    birthDate: '1997-09-17',
    birthCity: 'San Ramon',
    birthCountry: 'USA',
    shootsCatches: 'L',
    draftDetails: const DraftDetailsDto(
      year: 2016,
      teamAbbrev: 'ARI',
      round: 1,
      pickInRound: 1,
      overallPick: 1,
    ),
    featuredStats: const FeaturedStatsDto(
      season: 20242025,
      regularSeason: FeaturedStatsRegularSeasonDto(
        subSeason: SubSeasonStatsDto(
          gamesPlayed: 50,
          goals: 30,
          assists: 25,
          points: 55,
          plusMinus: 10,
        ),
      ),
    ),
  );

  // Helper: build a fresh (non-expired) ApiCacheRow
  ApiCacheRow freshCacheRow(String key, Map<String, dynamic> data) =>
      ApiCacheRow(
        cacheKey: key,
        data: jsonEncode(data),
        fetchedAt: DateTime.now().toIso8601String(),
        ttlMinutes: 15,
      );

  group('getPlayerDetail', () {
    test('returns cached data when cache is fresh', () async {
      // Arrange
      final cacheRow =
          freshCacheRow('player_detail:8478402', testDto.toJson());
      when(() => mockApiCacheDao.get('player_detail:8478402'))
          .thenAnswer((_) async => cacheRow);
      when(() => mockApiCacheDao.isExpired(cacheRow)).thenReturn(false);

      // Act
      final result = await repository.getPlayerDetail(8478402);

      // Assert: API was NOT called
      verifyNever(() => mockWebClient.getPlayerLanding(any()));

      expect(result, isA<PlayerDetail>());
      expect(result.player.firstName, 'Auston');
      expect(result.player.lastName, 'Matthews');
      expect(result.player.teamAbbrev, 'TOR');
      expect(result.currentSeasonStats, isA<SkaterSeasonStats>());
      final stats = result.currentSeasonStats as SkaterSeasonStats;
      expect(stats.goals, 30);
      expect(stats.points, 55);
    });

    test('fetches from API and caches when no cached data', () async {
      // Arrange: no cache entry
      when(() => mockApiCacheDao.get('player_detail:8478402'))
          .thenAnswer((_) async => null);
      when(() => mockWebClient.getPlayerLanding(8478402))
          .thenAnswer((_) async => testDto);
      when(() => mockApiCacheDao.set(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => mockPlayerCacheDao.upsert(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getPlayerDetail(8478402);

      // Assert: API was called
      verify(() => mockWebClient.getPlayerLanding(8478402)).called(1);

      // Assert: result cached in api_cache
      verify(() => mockApiCacheDao.set('player_detail:8478402', any(), 15))
          .called(1);

      // Assert: basic player info also cached
      verify(() => mockPlayerCacheDao.upsert(any())).called(1);

      expect(result.player.id, 8478402);
      expect(result.player.fullName, 'Auston Matthews');
      expect(result.bio.birthCountry, 'USA');
      expect(result.bio.draftInfo?.overallPick, 1);
    });

    test('fetches from API when cache is expired', () async {
      // Arrange: expired cache entry
      final expiredRow = ApiCacheRow(
        cacheKey: 'player_detail:8478402',
        data: jsonEncode(testDto.toJson()),
        fetchedAt:
            DateTime.now().subtract(const Duration(hours: 1)).toIso8601String(),
        ttlMinutes: 15,
      );
      when(() => mockApiCacheDao.get('player_detail:8478402'))
          .thenAnswer((_) async => expiredRow);
      when(() => mockApiCacheDao.isExpired(expiredRow)).thenReturn(true);
      when(() => mockWebClient.getPlayerLanding(8478402))
          .thenAnswer((_) async => testDto);
      when(() => mockApiCacheDao.set(any(), any(), any()))
          .thenAnswer((_) async {});
      when(() => mockPlayerCacheDao.upsert(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getPlayerDetail(8478402);

      // Assert: fell through to API
      verify(() => mockWebClient.getPlayerLanding(8478402)).called(1);
      expect(result.player.firstName, 'Auston');
    });
  });
}
