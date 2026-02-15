import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fantasy_nhl/core/network/nhl_stats_api_client.dart';
import 'package:fantasy_nhl/core/network/nhl_web_api_client.dart';
import 'package:fantasy_nhl/core/storage/local_storage_service.dart';
import 'package:fantasy_nhl/features/player/data/dtos/player_landing_dto.dart';
import 'package:fantasy_nhl/features/player/data/dtos/player_stats_dto.dart';
import 'package:fantasy_nhl/features/player/data/repositories/player_repository_impl.dart';
import 'package:fantasy_nhl/features/player/domain/entities/player_detail.dart';

class MockNhlWebApiClient extends Mock implements NhlWebApiClient {}

class MockNhlStatsApiClient extends Mock implements NhlStatsApiClient {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  late PlayerRepositoryImpl repository;
  late MockNhlWebApiClient mockWebClient;
  late MockNhlStatsApiClient mockStatsClient;
  late MockLocalStorageService mockStorage;

  setUp(() {
    mockWebClient = MockNhlWebApiClient();
    mockStatsClient = MockNhlStatsApiClient();
    mockStorage = MockLocalStorageService();

    repository = PlayerRepositoryImpl(
      webApiClient: mockWebClient,
      statsApiClient: mockStatsClient,
      storage: mockStorage,
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

  group('getPlayerDetail', () {
    test('returns cached data when cache is fresh', () async {
      // Arrange: cache is not expired, and has data
      when(() => mockStorage.isCacheExpired('player_detail:8478402'))
          .thenReturn(false);
      when(() => mockStorage.getString('cache:player_detail:8478402'))
          .thenReturn(jsonEncode(testDto.toJson()));

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

    test('fetches from API and caches when cache is expired', () async {
      // Arrange: cache is expired
      when(() => mockStorage.isCacheExpired('player_detail:8478402'))
          .thenReturn(true);
      when(() => mockWebClient.getPlayerLanding(8478402))
          .thenAnswer((_) async => testDto);
      when(() => mockStorage.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockStorage.setCacheTimestamp(any()))
          .thenAnswer((_) async {});
      when(() => mockStorage.setJson(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.getPlayerDetail(8478402);

      // Assert: API was called
      verify(() => mockWebClient.getPlayerLanding(8478402)).called(1);

      // Assert: result cached
      verify(() => mockStorage.setString(
            'cache:player_detail:8478402',
            any(),
          )).called(1);
      verify(() => mockStorage.setCacheTimestamp('player_detail:8478402'))
          .called(1);

      // Assert: basic player info also cached
      verify(() => mockStorage.setJson(
            'cache:player:8478402',
            any(),
          )).called(1);

      expect(result.player.id, 8478402);
      expect(result.player.fullName, 'Auston Matthews');
      expect(result.bio.birthCountry, 'USA');
      expect(result.bio.draftInfo?.overallPick, 1);
    });

    test('fetches from API when cache has no data', () async {
      // Arrange: cache not expired but returns null
      when(() => mockStorage.isCacheExpired('player_detail:8478402'))
          .thenReturn(false);
      when(() => mockStorage.getString('cache:player_detail:8478402'))
          .thenReturn(null);
      when(() => mockWebClient.getPlayerLanding(8478402))
          .thenAnswer((_) async => testDto);
      when(() => mockStorage.setString(any(), any()))
          .thenAnswer((_) async => true);
      when(() => mockStorage.setCacheTimestamp(any()))
          .thenAnswer((_) async {});
      when(() => mockStorage.setJson(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.getPlayerDetail(8478402);

      // Assert: fell through to API
      verify(() => mockWebClient.getPlayerLanding(8478402)).called(1);
      expect(result.player.firstName, 'Auston');
    });
  });
}
