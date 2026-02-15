import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_log_dto.freezed.dart';
part 'game_log_dto.g.dart';

@freezed
abstract class GameLogDto with _$GameLogDto {
  const factory GameLogDto({
    List<Map<String, dynamic>>? gameLog,
  }) = _GameLogDto;

  factory GameLogDto.fromJson(Map<String, dynamic> json) =>
      _$GameLogDtoFromJson(json);
}
