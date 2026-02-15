import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_landing_dto.freezed.dart';
part 'player_landing_dto.g.dart';

@freezed
abstract class PlayerLandingDto with _$PlayerLandingDto {
  const factory PlayerLandingDto({
    int? playerId,
    Map<String, dynamic>? firstName,
    Map<String, dynamic>? lastName,
    String? position,
    String? headshot,
    int? teamId,
    Map<String, dynamic>? teamLogo,
  }) = _PlayerLandingDto;

  factory PlayerLandingDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerLandingDtoFromJson(json);
}
