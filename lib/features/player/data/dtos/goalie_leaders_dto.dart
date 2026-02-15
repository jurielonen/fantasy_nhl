import 'package:freezed_annotation/freezed_annotation.dart';

part 'goalie_leaders_dto.freezed.dart';
part 'goalie_leaders_dto.g.dart';

@freezed
abstract class GoalieLeadersDto with _$GoalieLeadersDto {
  const factory GoalieLeadersDto({
    List<Map<String, dynamic>>? wins,
    List<Map<String, dynamic>>? gaa,
    List<Map<String, dynamic>>? savePctg,
  }) = _GoalieLeadersDto;

  factory GoalieLeadersDto.fromJson(Map<String, dynamic> json) =>
      _$GoalieLeadersDtoFromJson(json);
}
