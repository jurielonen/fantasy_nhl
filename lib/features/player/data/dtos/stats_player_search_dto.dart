import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_player_search_dto.freezed.dart';
part 'stats_player_search_dto.g.dart';

@freezed
abstract class StatsPlayerSearchDto with _$StatsPlayerSearchDto {
  const factory StatsPlayerSearchDto({
    List<Map<String, dynamic>>? data,
    int? total,
  }) = _StatsPlayerSearchDto;

  factory StatsPlayerSearchDto.fromJson(Map<String, dynamic> json) =>
      _$StatsPlayerSearchDtoFromJson(json);
}
