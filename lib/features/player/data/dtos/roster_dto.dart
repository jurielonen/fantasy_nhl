import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'roster_dto.freezed.dart';
part 'roster_dto.g.dart';

@freezed
abstract class RosterDto with _$RosterDto {
  const factory RosterDto({
    List<RosterPlayerDto>? forwards,
    List<RosterPlayerDto>? defensemen,
    List<RosterPlayerDto>? goalies,
  }) = _RosterDto;

  factory RosterDto.fromJson(Map<String, dynamic> json) =>
      _$RosterDtoFromJson(json);
}

@freezed
abstract class RosterPlayerDto with _$RosterPlayerDto {
  const factory RosterPlayerDto({
    int? id,
    String? headshot,
    @LocalizedStringConverter() String? firstName,
    @LocalizedStringConverter() String? lastName,
    int? sweaterNumber,
    String? positionCode,
    String? shootsCatches,
    int? heightInInches,
    int? weightInPounds,
    String? birthDate,
    @LocalizedStringConverter() String? birthCity,
    String? birthCountry,
  }) = _RosterPlayerDto;

  factory RosterPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$RosterPlayerDtoFromJson(json);
}
