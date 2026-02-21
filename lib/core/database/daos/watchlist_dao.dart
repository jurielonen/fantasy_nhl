import 'package:drift/drift.dart';

import '../../../features/watchlist/domain/entities/watchlist.dart';
import '../app_database.dart';

part 'watchlist_dao.g.dart';

@DriftAccessor(tables: [Watchlists, WatchlistPlayers])
class WatchlistDao extends DatabaseAccessor<AppDatabase>
    with _$WatchlistDaoMixin {
  WatchlistDao(super.db);

  // ── Private helpers ─────────────────────────────────────────────────────────

  Future<List<WatchlistRow>> _getAllWatchlistRows() => (select(
    watchlists,
  )..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();

  Future<List<WatchlistPlayerRow>> _getPlayersForWatchlist(String id) =>
      (select(watchlistPlayers)
            ..where((t) => t.watchlistId.equals(id))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<Watchlist> _assembleWatchlist(WatchlistRow row) async {
    final players = await _getPlayersForWatchlist(row.id);
    return Watchlist(
      id: row.id,
      name: row.name,
      playerIds: players.map((p) => p.playerId).toList(),
      sortOrder: row.sortOrder,
      createdAt: DateTime.tryParse(row.createdAt) ?? DateTime.now(),
    );
  }

  // ── Public API ───────────────────────────────────────────────────────────────

  Future<List<Watchlist>> getAllWatchlists() async {
    final rows = await _getAllWatchlistRows();
    return Future.wait(rows.map(_assembleWatchlist));
  }

  Future<Watchlist?> getById(String id) async {
    final row = await (select(
      watchlists,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _assembleWatchlist(row);
  }

  Future<void> insertWatchlist(WatchlistsCompanion entry) =>
      into(watchlists).insert(entry);

  Future<void> deleteById(String id) =>
      (delete(watchlists)..where((t) => t.id.equals(id))).go();

  Future<void> updateName(String id, String newName) =>
      (update(watchlists)..where((t) => t.id.equals(id))).write(
        WatchlistsCompanion(name: Value(newName)),
      );

  Future<int> countWatchlists() async {
    final count = countAll();
    final query = selectOnly(watchlists)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> addPlayer(String watchlistId, int playerId) async {
    final existing = await _getPlayersForWatchlist(watchlistId);
    final nextPosition = existing.isEmpty ? 0 : existing.last.position + 1;
    await into(watchlistPlayers).insert(
      WatchlistPlayersCompanion.insert(
        watchlistId: watchlistId,
        playerId: playerId,
        position: Value(nextPosition),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> removePlayer(String watchlistId, int playerId) =>
      (delete(watchlistPlayers)..where(
            (t) =>
                t.watchlistId.equals(watchlistId) & t.playerId.equals(playerId),
          ))
          .go();

  Future<void> reorderPlayers(String watchlistId, List<int> playerIds) async {
    await transaction(() async {
      await (delete(
        watchlistPlayers,
      )..where((t) => t.watchlistId.equals(watchlistId))).go();
      for (var i = 0; i < playerIds.length; i++) {
        await into(watchlistPlayers).insert(
          WatchlistPlayersCompanion.insert(
            watchlistId: watchlistId,
            playerId: playerIds[i],
            position: Value(i),
          ),
        );
      }
    });
  }

  Future<void> movePlayer(String fromId, String toId, int playerId) async {
    await transaction(() async {
      await removePlayer(fromId, playerId);
      await addPlayer(toId, playerId);
    });
  }

  Future<Watchlist?> findWatchlistContainingPlayer(int playerId) async {
    final row = await (select(
      watchlistPlayers,
    )..where((t) => t.playerId.equals(playerId))).getSingleOrNull();
    if (row == null) return null;
    return getById(row.watchlistId);
  }

  /// Reactive stream — emits a new list whenever watchlists OR watchlist_players changes.
  Stream<List<Watchlist>> watchAllWatchlists() {
    // customSelect with readsFrom tracking both tables ensures Drift re-emits
    // when either the watchlists rows or the watchlist_players rows change
    // (e.g. adding/removing a player only writes to watchlist_players).
    return customSelect(
      'SELECT 1',
      readsFrom: {watchlists, watchlistPlayers},
    ).watch().asyncMap((_) => getAllWatchlists());
  }
}
