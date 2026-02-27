import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'game_day_dto.freezed.dart';
part 'game_day_dto.g.dart';

@freezed
abstract class GameDayResponseDto with _$GameDayResponseDto {
  const factory GameDayResponseDto({
    String? prevDate,
    String? currentDate,
    String? nextDate,
    List<GameWeekDayDto>? gameWeek,
    List<GameDto>? games,
  }) = _GameDayResponseDto;

  factory GameDayResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GameDayResponseDtoFromJson(json);
}

@freezed
abstract class GameWeekDayDto with _$GameWeekDayDto {
  const factory GameWeekDayDto({
    String? date,
    String? dayAbbrev,
    int? numberOfGames,
  }) = _GameWeekDayDto;

  factory GameWeekDayDto.fromJson(Map<String, dynamic> json) =>
      _$GameWeekDayDtoFromJson(json);
}

@freezed
abstract class GameDto with _$GameDto {
  const factory GameDto({
    int? id,
    int? season,
    int? gameType,
    String? gameDate,
    @LocalizedStringConverter() String? venue,
    String? startTimeUTC,
    String? easternUTCOffset,
    String? venueUTCOffset,
    String? gameState,
    String? gameScheduleState,
    GameTeamDto? awayTeam,
    GameTeamDto? homeTeam,
    String? gameCenterLink,
    GameClockDto? clock,
    bool? neutralSite,
    String? venueTimezone,
    int? period,
    PeriodDescriptorDto? periodDescriptor,
    GameOutcomeDto? gameOutcome,
    List<GoalDto>? goals,
  }) = _GameDto;

  factory GameDto.fromJson(Map<String, dynamic> json) =>
      _$GameDtoFromJson(json);
}

@freezed
abstract class GameTeamDto with _$GameTeamDto {
  const factory GameTeamDto({
    int? id,
    @LocalizedStringConverter() String? name,
    String? abbrev,
    int? score,
    int? sog,
    String? logo,
  }) = _GameTeamDto;

  factory GameTeamDto.fromJson(Map<String, dynamic> json) =>
      _$GameTeamDtoFromJson(json);
}

@freezed
abstract class GameClockDto with _$GameClockDto {
  const factory GameClockDto({
    String? timeRemaining,
    int? secondsRemaining,
    bool? running,
    bool? inIntermission,
  }) = _GameClockDto;

  factory GameClockDto.fromJson(Map<String, dynamic> json) =>
      _$GameClockDtoFromJson(json);
}

@freezed
abstract class PeriodDescriptorDto with _$PeriodDescriptorDto {
  const factory PeriodDescriptorDto({
    int? number,
    String? periodType,
    int? maxRegulationPeriods,
  }) = _PeriodDescriptorDto;

  factory PeriodDescriptorDto.fromJson(Map<String, dynamic> json) =>
      _$PeriodDescriptorDtoFromJson(json);
}

@freezed
abstract class GameOutcomeDto with _$GameOutcomeDto {
  const factory GameOutcomeDto({String? lastPeriodType}) = _GameOutcomeDto;

  factory GameOutcomeDto.fromJson(Map<String, dynamic> json) =>
      _$GameOutcomeDtoFromJson(json);
}

@freezed
abstract class GoalDto with _$GoalDto {
  const factory GoalDto({
    int? period,
    PeriodDescriptorDto? periodDescriptor,
    String? timeInPeriod,
    int? playerId,
    @LocalizedStringConverter() String? name,
    @LocalizedStringConverter() String? firstName,
    @LocalizedStringConverter() String? lastName,
    String? goalModifier,
    List<AssistDto>? assists,
    String? mugshot,
    String? teamAbbrev,
    int? goalsToDate,
    int? awayScore,
    int? homeScore,
    String? strength,
  }) = _GoalDto;

  factory GoalDto.fromJson(Map<String, dynamic> json) =>
      _$GoalDtoFromJson(json);
}

@freezed
abstract class AssistDto with _$AssistDto {
  const factory AssistDto({
    int? playerId,
    @LocalizedStringConverter() String? name,
    int? assistsToDate,
  }) = _AssistDto;

  factory AssistDto.fromJson(Map<String, dynamic> json) =>
      _$AssistDtoFromJson(json);
}
