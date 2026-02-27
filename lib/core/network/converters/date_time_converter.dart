import 'package:json_annotation/json_annotation.dart';

/// Converts nullable ISO-8601 date/time strings to [DateTime?] during JSON
/// deserialization. All date fields in the NHL APIs are nullable, so this
/// single converter covers every case.
class NullableDateTimeConverter implements JsonConverter<DateTime?, String?> {
  const NullableDateTimeConverter();

  @override
  DateTime? fromJson(String? json) =>
      json != null ? DateTime.tryParse(json) : null;

  @override
  String? toJson(DateTime? object) => object?.toIso8601String();
}
