import 'package:freezed_annotation/freezed_annotation.dart';

import 'leader_entry_dto.dart';

part 'skater_leaders_dto.freezed.dart';
part 'skater_leaders_dto.g.dart';

@freezed
abstract class SkaterLeadersDto with _$SkaterLeadersDto {
  const factory SkaterLeadersDto({
    List<LeaderEntryDto>? goals,
    List<LeaderEntryDto>? assists,
    List<LeaderEntryDto>? points,
    List<LeaderEntryDto>? plusMinus,
    List<LeaderEntryDto>? penaltyMins,
    List<LeaderEntryDto>? toi,
  }) = _SkaterLeadersDto;

  factory SkaterLeadersDto.fromJson(Map<String, dynamic> json) =>
      _$SkaterLeadersDtoFromJson(json);
}
