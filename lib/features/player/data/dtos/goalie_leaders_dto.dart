import 'package:freezed_annotation/freezed_annotation.dart';

import 'leader_entry_dto.dart';

part 'goalie_leaders_dto.freezed.dart';
part 'goalie_leaders_dto.g.dart';

@freezed
abstract class GoalieLeadersDto with _$GoalieLeadersDto {
  const factory GoalieLeadersDto({
    List<LeaderEntryDto>? wins,
    List<LeaderEntryDto>? gaa,
    List<LeaderEntryDto>? savePctg,
    List<LeaderEntryDto>? shutouts,
  }) = _GoalieLeadersDto;

  factory GoalieLeadersDto.fromJson(Map<String, dynamic> json) =>
      _$GoalieLeadersDtoFromJson(json);
}
