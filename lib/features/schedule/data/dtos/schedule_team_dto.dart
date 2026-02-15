import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'schedule_team_dto.freezed.dart';
part 'schedule_team_dto.g.dart';

/// Shared team block used in schedule games, scores, and scoreboard responses.
@freezed
abstract class ScheduleTeamDto with _$ScheduleTeamDto {
  const factory ScheduleTeamDto({
    int? id,
    String? abbrev,
    String? logo,
    @LocalizedStringConverter() String? name,
    @LocalizedStringConverter() String? commonName,
    @LocalizedStringConverter() String? placeName,
    int? score,
    int? sog,
  }) = _ScheduleTeamDto;

  factory ScheduleTeamDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleTeamDtoFromJson(json);
}

/// Shared game block used in schedule and scores responses.
@freezed
abstract class ScheduleGameDto with _$ScheduleGameDto {
  const factory ScheduleGameDto({
    int? id,
    int? season,
    int? gameType,
    String? gameDate,
    String? startTimeUTC,
    String? gameState,
    ScheduleTeamDto? homeTeam,
    ScheduleTeamDto? awayTeam,
    Map<String, dynamic>? periodDescriptor,
    @LocalizedStringConverter() String? venue,
  }) = _ScheduleGameDto;

  factory ScheduleGameDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleGameDtoFromJson(json);
}
