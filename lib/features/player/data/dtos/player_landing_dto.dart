import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';
import 'player_stats_dto.dart';

part 'player_landing_dto.freezed.dart';
part 'player_landing_dto.g.dart';

@freezed
abstract class PlayerLandingDto with _$PlayerLandingDto {
  const factory PlayerLandingDto({
    int? playerId,
    bool? isActive,
    int? currentTeamId,
    String? currentTeamAbbrev,
    @LocalizedStringConverter() String? fullTeamName,
    @LocalizedStringConverter() String? firstName,
    @LocalizedStringConverter() String? lastName,
    String? teamLogo,
    int? sweaterNumber,
    String? position,
    String? headshot,
    String? heroImage,
    int? heightInInches,
    int? weightInPounds,
    String? birthDate,
    @LocalizedStringConverter() String? birthCity,
    String? birthCountry,
    String? shootsCatches,
    DraftDetailsDto? draftDetails,
    String? playerSlug,
    FeaturedStatsDto? featuredStats,
    CareerTotalsDto? careerTotals,
    List<SeasonTotalDto>? seasonTotals,
  }) = _PlayerLandingDto;

  factory PlayerLandingDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerLandingDtoFromJson(json);
}
