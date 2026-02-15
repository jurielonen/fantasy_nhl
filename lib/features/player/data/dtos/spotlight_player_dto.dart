import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'spotlight_player_dto.freezed.dart';
part 'spotlight_player_dto.g.dart';

@freezed
abstract class SpotlightPlayerDto with _$SpotlightPlayerDto {
  const factory SpotlightPlayerDto({
    int? playerId,
    @LocalizedStringConverter() String? name,
    String? position,
    String? headshot,
    int? teamId,
    String? teamTriCode,
    @LocalizedStringConverter() String? teamName,
    int? sweaterNumber,
  }) = _SpotlightPlayerDto;

  factory SpotlightPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$SpotlightPlayerDtoFromJson(json);
}
