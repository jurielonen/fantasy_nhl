import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_model.freezed.dart';
part 'watchlist_model.g.dart';

@freezed
abstract class WatchlistModel with _$WatchlistModel {
  const factory WatchlistModel({
    required String id,
    required String name,
    @Default([]) List<int> playerIds,
    @Default(0) int sortOrder,
    required String createdAt,
  }) = _WatchlistModel;

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      _$WatchlistModelFromJson(json);
}
