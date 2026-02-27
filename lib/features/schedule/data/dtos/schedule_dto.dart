import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/date_time_converter.dart';
import 'schedule_team_dto.dart';

part 'schedule_dto.freezed.dart';
part 'schedule_dto.g.dart';

@freezed
abstract class ScheduleDto with _$ScheduleDto {
  const factory ScheduleDto({
    @NullableDateTimeConverter() DateTime? nextStartDate,
    @NullableDateTimeConverter() DateTime? previousStartDate,
    List<ScheduleDayDto>? gameWeek,
  }) = _ScheduleDto;

  factory ScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDtoFromJson(json);
}

@freezed
abstract class ScheduleDayDto with _$ScheduleDayDto {
  const factory ScheduleDayDto({
    @NullableDateTimeConverter() DateTime? date,
    String? dayAbbrev,
    int? numberOfGames,
    List<ScheduleGameDto>? games,
  }) = _ScheduleDayDto;

  factory ScheduleDayDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDayDtoFromJson(json);
}
