import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'standings_dto.freezed.dart';
part 'standings_dto.g.dart';

@freezed
abstract class StandingsDto with _$StandingsDto {
  const factory StandingsDto({
    List<StandingsTeamDto>? standings,
  }) = _StandingsDto;

  factory StandingsDto.fromJson(Map<String, dynamic> json) =>
      _$StandingsDtoFromJson(json);
}

@freezed
abstract class StandingsTeamDto with _$StandingsTeamDto {
  const factory StandingsTeamDto({
    String? teamAbbrev,
    @LocalizedStringConverter() String? teamName,
    int? gamesPlayed,
    int? wins,
    int? losses,
    int? otLosses,
    int? points,
    String? divisionName,
    String? conferenceName,
    int? divisionSequence,
    int? conferenceSequence,
    int? leagueSequence,
    String? streakCode,
    int? streakCount,
  }) = _StandingsTeamDto;

  factory StandingsTeamDto.fromJson(Map<String, dynamic> json) =>
      _$StandingsTeamDtoFromJson(json);
}
