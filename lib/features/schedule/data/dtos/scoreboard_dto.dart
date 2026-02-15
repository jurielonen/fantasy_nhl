import 'package:freezed_annotation/freezed_annotation.dart';

part 'scoreboard_dto.freezed.dart';
part 'scoreboard_dto.g.dart';

@freezed
abstract class ScoreboardDto with _$ScoreboardDto {
  const factory ScoreboardDto({
    Map<String, dynamic>? focusedDate,
    List<Map<String, dynamic>>? gamesByDate,
  }) = _ScoreboardDto;

  factory ScoreboardDto.fromJson(Map<String, dynamic> json) =>
      _$ScoreboardDtoFromJson(json);
}
