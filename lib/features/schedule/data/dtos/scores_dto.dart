import 'package:freezed_annotation/freezed_annotation.dart';

import 'schedule_team_dto.dart';

part 'scores_dto.freezed.dart';
part 'scores_dto.g.dart';

@freezed
abstract class ScoresDto with _$ScoresDto {
  const factory ScoresDto({
    List<ScheduleGameDto>? games,
  }) = _ScoresDto;

  factory ScoresDto.fromJson(Map<String, dynamic> json) =>
      _$ScoresDtoFromJson(json);
}
