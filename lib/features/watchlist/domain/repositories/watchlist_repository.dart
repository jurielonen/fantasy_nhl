import '../entities/watchlist.dart';

abstract class WatchlistRepository {
  Future<List<Watchlist>> getWatchlists();
  Future<Watchlist?> getWatchlist(String id);
  Future<Watchlist> createWatchlist(String name);
  Future<void> deleteWatchlist(String id);
  Future<void> addPlayer(String watchlistId, int playerId);
  Future<void> removePlayer(String watchlistId, int playerId);
  Future<void> reorderPlayers(String watchlistId, List<int> playerIds);
  Stream<void> get watchlistChanges;
}
