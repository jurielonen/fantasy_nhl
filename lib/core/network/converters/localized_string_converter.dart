import 'package:json_annotation/json_annotation.dart';

/// Handles the NHL API's `{"default": "value"}` localized string pattern.
/// Also handles plain strings for cached/normalized data.
class LocalizedStringConverter implements JsonConverter<String?, dynamic> {
  const LocalizedStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is String) return json;
    if (json is Map) return json['default'] as String?;
    return null;
  }

  @override
  dynamic toJson(String? object) => object;
}

/// Handles the NHL API returning numbers as int, double, or string inconsistently.
class FlexibleDoubleConverter implements JsonConverter<double?, dynamic> {
  const FlexibleDoubleConverter();

  @override
  double? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is double) return json;
    if (json is int) return json.toDouble();
    if (json is String) return double.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(double? object) => object;
}
