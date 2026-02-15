import 'package:freezed_annotation/freezed_annotation.dart';

part 'scores_dto.freezed.dart';
part 'scores_dto.g.dart';

@freezed
abstract class ScoresDto with _$ScoresDto {
  const factory ScoresDto({
    List<Map<String, dynamic>>? games,
  }) = _ScoresDto;

  factory ScoresDto.fromJson(Map<String, dynamic> json) =>
      _$ScoresDtoFromJson(json);
}
