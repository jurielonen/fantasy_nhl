import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_team_list_dto.freezed.dart';
part 'stats_team_list_dto.g.dart';

@freezed
abstract class StatsTeamListDto with _$StatsTeamListDto {
  const factory StatsTeamListDto({
    List<StatsTeamDto>? data,
    int? total,
  }) = _StatsTeamListDto;

  factory StatsTeamListDto.fromJson(Map<String, dynamic> json) =>
      _$StatsTeamListDtoFromJson(json);
}

@freezed
abstract class StatsTeamDto with _$StatsTeamDto {
  const factory StatsTeamDto({
    int? id,
    String? fullName,
    String? triCode,
    String? leagueId,
  }) = _StatsTeamDto;

  factory StatsTeamDto.fromJson(Map<String, dynamic> json) =>
      _$StatsTeamDtoFromJson(json);
}
