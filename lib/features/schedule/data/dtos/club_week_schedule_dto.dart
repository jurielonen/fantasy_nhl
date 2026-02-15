import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_team_dto.dart';

part 'club_week_schedule_dto.freezed.dart';
part 'club_week_schedule_dto.g.dart';

@freezed
abstract class ClubWeekScheduleDto with _$ClubWeekScheduleDto {
  const factory ClubWeekScheduleDto({
    List<ScheduleGameDto>? games,
  }) = _ClubWeekScheduleDto;

  factory ClubWeekScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ClubWeekScheduleDtoFromJson(json);
}
