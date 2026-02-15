import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotlight_player_dto.freezed.dart';
part 'spotlight_player_dto.g.dart';

@freezed
abstract class SpotlightPlayerDto with _$SpotlightPlayerDto {
  const factory SpotlightPlayerDto({
    int? playerId,
    Map<String, dynamic>? name,
    String? position,
    String? headshot,
    int? teamId,
  }) = _SpotlightPlayerDto;

  factory SpotlightPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$SpotlightPlayerDtoFromJson(json);
}
