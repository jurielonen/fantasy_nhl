import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_team_dto.dart';

part 'scoreboard_dto.freezed.dart';
part 'scoreboard_dto.g.dart';

@freezed
abstract class ScoreboardDto with _$ScoreboardDto {
  const factory ScoreboardDto({
    String? focusedDate,
    List<ScoreboardDateDto>? gamesByDate,
  }) = _ScoreboardDto;

  factory ScoreboardDto.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardDtoFromJson(json);
}

@freezed
abstract class ScoreboardDateDto with _$ScoreboardDateDto {
  const factory ScoreboardDateDto({
    String? date,
    List<ScheduleGameDto>? games,
  }) = _ScoreboardDateDto;

  factory ScoreboardDateDto.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardDateDtoFromJson(json);
}
