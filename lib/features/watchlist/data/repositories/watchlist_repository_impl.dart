import 'package:drift/drift.dart';

import '../../../../core/database/daos/watchlist_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistDao _dao;

  WatchlistRepositoryImpl({required WatchlistDao dao}) : _dao = dao;

  @override
  Future<List<Watchlist>> getWatchlists() => _dao.getAllWatchlists();

  @override
  Future<Watchlist?> getWatchlist(String id) => _dao.getById(id);

  @override
  Future<Watchlist> createWatchlist(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final count = await _dao.countWatchlists();
    await _dao.insertWatchlist(
      WatchlistsCompanion.insert(
        id: id,
        name: name,
        sortOrder: Value(count),
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
    return Watchlist(
      id: id,
      name: name,
      playerIds: const [],
      sortOrder: count,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> deleteWatchlist(String id) => _dao.deleteById(id);

  @override
  Future<void> renameWatchlist(String id, String newName) =>
      _dao.updateName(id, newName);

  @override
  Future<void> addPlayer(String watchlistId, int playerId) =>
      _dao.addPlayer(watchlistId, playerId);

  @override
  Future<void> removePlayer(String watchlistId, int playerId) =>
      _dao.removePlayer(watchlistId, playerId);

  @override
  Future<void> movePlayer(String fromId, String toId, int playerId) =>
      _dao.movePlayer(fromId, toId, playerId);

  @override
  Future<void> reorderPlayers(String watchlistId, List<int> playerIds) =>
      _dao.reorderPlayers(watchlistId, playerIds);

  @override
  Future<Watchlist?> findWatchlistContainingPlayer(int playerId) =>
      _dao.findWatchlistContainingPlayer(playerId);

  @override
  Future<void> ensureDefaultWatchlist() async {
    if (await _dao.countWatchlists() == 0) {
      await createWatchlist('My Players');
    }
  }

  @override
  Stream<List<Watchlist>> get watchlistChanges => _dao.watchAllWatchlists();
}
