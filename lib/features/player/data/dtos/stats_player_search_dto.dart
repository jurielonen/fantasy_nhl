import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_player_search_dto.freezed.dart';
part 'stats_player_search_dto.g.dart';

@freezed
abstract class StatsPlayerSearchDto with _$StatsPlayerSearchDto {
  const factory StatsPlayerSearchDto({
    List<StatsPlayerDto>? data,
    int? total,
  }) = _StatsPlayerSearchDto;

  factory StatsPlayerSearchDto.fromJson(Map<String, dynamic> json) =>
      _$StatsPlayerSearchDtoFromJson(json);
}

@freezed
abstract class StatsPlayerDto with _$StatsPlayerDto {
  const factory StatsPlayerDto({
    int? playerId,
    String? fullName,
    String? firstName,
    String? lastName,
    String? lastFirstName,
    String? currentTeamAbbrev,
    String? currentTeamName,
    String? positionCode,
    int? sweaterNumber,
    String? headshot,
    bool? isActive,
  }) = _StatsPlayerDto;

  factory StatsPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$StatsPlayerDtoFromJson(json);
}
