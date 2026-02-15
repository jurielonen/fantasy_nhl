import '../../domain/entities/watchlist.dart';
import '../models/watchlist_model.dart';

extension WatchlistModelMapper on WatchlistModel {
  Watchlist toEntity() => Watchlist(
        id: id,
        name: name,
        playerIds: playerIds,
        sortOrder: sortOrder,
        createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      );
}

extension WatchlistToStorage on Watchlist {
  WatchlistModel toModel() => WatchlistModel(
        id: id,
        name: name,
        playerIds: playerIds,
        sortOrder: sortOrder,
        createdAt: createdAt.toIso8601String(),
      );
}
