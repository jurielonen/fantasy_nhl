import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/date_time_converter.dart';
import '../../../../core/network/converters/localized_string_converter.dart';

part 'game_log_dto.freezed.dart';
part 'game_log_dto.g.dart';

@freezed
abstract class GameLogDto with _$GameLogDto {
  const factory GameLogDto({List<GameLogEntryDto>? gameLog}) = _GameLogDto;

  factory GameLogDto.fromJson(Map<String, dynamic> json) =>
      _$GameLogDtoFromJson(json);
}

@freezed
abstract class GameLogEntryDto with _$GameLogEntryDto {
  const factory GameLogEntryDto({
    int? gameId,
    String? teamAbbrev,
    String? homeRoadFlg,
    @NullableDateTimeConverter() DateTime? gameDate,
    @LocalizedStringConverter() String? commonName,
    String? opponentAbbrev,
    String? toi,
    // Skater fields
    int? goals,
    int? assists,
    int? points,
    int? plusMinus,
    int? powerPlayGoals,
    int? gameWinningGoals,
    int? otGoals,
    int? shots,
    int? shifts,
    int? shorthandedGoals,
    int? pim,
    // Goalie fields
    String? decision,
    int? shotsAgainst,
    int? goalsAgainst,
    double? savePctg,
    int? gamesStarted,
  }) = _GameLogEntryDto;

  factory GameLogEntryDto.fromJson(Map<String, dynamic> json) =>
      _$GameLogEntryDtoFromJson(json);
}
