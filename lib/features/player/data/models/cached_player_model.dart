import 'package:freezed_annotation/freezed_annotation.dart';

part 'cached_player_model.freezed.dart';
part 'cached_player_model.g.dart';

@freezed
abstract class CachedPlayerModel with _$CachedPlayerModel {
  const factory CachedPlayerModel({
    required int id,
    required String firstName,
    required String lastName,
    String? teamAbbrev,
    String? teamName,
    required String position,
    int? sweaterNumber,
    String? headshot,
    @Default(true) bool isActive,
  }) = _CachedPlayerModel;

  factory CachedPlayerModel.fromJson(Map<String, dynamic> json) =>
      _$CachedPlayerModelFromJson(json);
}
