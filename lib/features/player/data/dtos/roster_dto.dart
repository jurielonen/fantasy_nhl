import 'package:freezed_annotation/freezed_annotation.dart';

part 'roster_dto.freezed.dart';
part 'roster_dto.g.dart';

@freezed
abstract class RosterDto with _$RosterDto {
  const factory RosterDto({
    List<Map<String, dynamic>>? forwards,
    List<Map<String, dynamic>>? defensemen,
    List<Map<String, dynamic>>? goalies,
  }) = _RosterDto;

  factory RosterDto.fromJson(Map<String, dynamic> json) =>
      _$RosterDtoFromJson(json);
}
