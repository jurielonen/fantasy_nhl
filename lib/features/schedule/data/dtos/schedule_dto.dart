import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_dto.freezed.dart';
part 'schedule_dto.g.dart';

@freezed
abstract class ScheduleDto with _$ScheduleDto {
  const factory ScheduleDto({
    List<Map<String, dynamic>>? gameWeek,
  }) = _ScheduleDto;

  factory ScheduleDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDtoFromJson(json);
}
