import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_team_list_dto.freezed.dart';
part 'stats_team_list_dto.g.dart';

@freezed
abstract class StatsTeamListDto with _$StatsTeamListDto {
  const factory StatsTeamListDto({
    List<Map<String, dynamic>>? data,
    int? total,
  }) = _StatsTeamListDto;

  factory StatsTeamListDto.fromJson(Map<String, dynamic> json) =>
      _$StatsTeamListDtoFromJson(json);
}
