import 'package:freezed_annotation/freezed_annotation.dart';

part 'skater_leaders_dto.freezed.dart';
part 'skater_leaders_dto.g.dart';

@freezed
abstract class SkaterLeadersDto with _$SkaterLeadersDto {
  const factory SkaterLeadersDto({
    List<Map<String, dynamic>>? goals,
    List<Map<String, dynamic>>? assists,
    List<Map<String, dynamic>>? points,
  }) = _SkaterLeadersDto;

  factory SkaterLeadersDto.fromJson(Map<String, dynamic> json) =>
      _$SkaterLeadersDtoFromJson(json);
}
