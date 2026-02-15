import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'player_stats_dto.freezed.dart';
part 'player_stats_dto.g.dart';

/// Shared stat block used by featured stats, career totals, and season totals.
/// Contains both skater and goalie fields — all nullable for defensive parsing.
@freezed
abstract class SubSeasonStatsDto with _$SubSeasonStatsDto {
  const factory SubSeasonStatsDto({
    int? gamesPlayed,
    // Skater
    int? goals,
    int? assists,
    int? points,
    int? plusMinus,
    int? pim,
    int? gameWinningGoals,
    int? otGoals,
    int? shots,
    double? shootingPctg,
    String? avgToi,
    double? faceoffPctg,
    int? powerPlayGoals,
    int? shorthandedGoals,
    // Goalie
    int? wins,
    int? losses,
    int? otLosses,
    double? goalsAgainstAvg,
    double? savePctg,
    int? shutouts,
  }) = _SubSeasonStatsDto;

  factory SubSeasonStatsDto.fromJson(Map<String, dynamic> json) =>
      _$SubSeasonStatsDtoFromJson(json);
}

@freezed
abstract class FeaturedStatsDto with _$FeaturedStatsDto {
  const factory FeaturedStatsDto({
    int? season,
    FeaturedStatsRegularSeasonDto? regularSeason,
  }) = _FeaturedStatsDto;

  factory FeaturedStatsDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedStatsDtoFromJson(json);
}

@freezed
abstract class FeaturedStatsRegularSeasonDto
    with _$FeaturedStatsRegularSeasonDto {
  const factory FeaturedStatsRegularSeasonDto({
    SubSeasonStatsDto? subSeason,
    SubSeasonStatsDto? career,
  }) = _FeaturedStatsRegularSeasonDto;

  factory FeaturedStatsRegularSeasonDto.fromJson(Map<String, dynamic> json) =>
      _$FeaturedStatsRegularSeasonDtoFromJson(json);
}

@freezed
abstract class CareerTotalsDto with _$CareerTotalsDto {
  const factory CareerTotalsDto({
    SubSeasonStatsDto? regularSeason,
    SubSeasonStatsDto? playoffs,
  }) = _CareerTotalsDto;

  factory CareerTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$CareerTotalsDtoFromJson(json);
}

@freezed
abstract class SeasonTotalDto with _$SeasonTotalDto {
  const factory SeasonTotalDto({
    int? season,
    int? gameTypeId,
    String? leagueAbbrev,
    @LocalizedStringConverter() String? teamName,
    int? sequence,
    int? gamesPlayed,
    // Skater
    int? goals,
    int? assists,
    int? points,
    int? plusMinus,
    int? pim,
    int? gameWinningGoals,
    int? otGoals,
    int? shots,
    double? shootingPctg,
    int? powerPlayGoals,
    int? shorthandedGoals,
    String? avgToi,
    double? faceoffPctg,
    // Goalie
    int? wins,
    int? losses,
    int? otLosses,
    double? goalsAgainstAvg,
    double? savePctg,
    int? shutouts,
    int? gamesStarted,
  }) = _SeasonTotalDto;

  factory SeasonTotalDto.fromJson(Map<String, dynamic> json) =>
      _$SeasonTotalDtoFromJson(json);
}

@freezed
abstract class DraftDetailsDto with _$DraftDetailsDto {
  const factory DraftDetailsDto({
    int? year,
    String? teamAbbrev,
    int? round,
    int? pickInRound,
    int? overallPick,
  }) = _DraftDetailsDto;

  factory DraftDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$DraftDetailsDtoFromJson(json);
}
