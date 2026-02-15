import 'package:freezed_annotation/freezed_annotation.dart';

part 'standings_dto.freezed.dart';
part 'standings_dto.g.dart';

@freezed
abstract class StandingsDto with _$StandingsDto {
  const factory StandingsDto({
    List<Map<String, dynamic>>? standings,
  }) = _StandingsDto;

  factory StandingsDto.fromJson(Map<String, dynamic> json) =>
      _$StandingsDtoFromJson(json);
}
