import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/converters/localized_string_converter.dart';

part 'leader_entry_dto.freezed.dart';
part 'leader_entry_dto.g.dart';

@freezed
abstract class LeaderEntryDto with _$LeaderEntryDto {
  const factory LeaderEntryDto({
    int? id,
    @LocalizedStringConverter() String? firstName,
    @LocalizedStringConverter() String? lastName,
    String? teamAbbrev,
    String? headshot,
    String? position,
    @FlexibleDoubleConverter() double? value,
  }) = _LeaderEntryDto;

  factory LeaderEntryDto.fromJson(Map<String, dynamic> json) =>
      _$LeaderEntryDtoFromJson(json);
}
