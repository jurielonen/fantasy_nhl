import '../../../../core/storage/local_storage_service.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../mappers/watchlist_mapper.dart';
import '../models/watchlist_model.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final LocalStorageService _storage;

  WatchlistRepositoryImpl({required LocalStorageService storage})
      : _storage = storage;

  static const _prefix = 'watchlist:';

  @override
  Future<List<Watchlist>> getWatchlists() async {
    final keys = _storage.getKeysWithPrefix(_prefix);
    final watchlists = <Watchlist>[];
    for (final key in keys) {
      final json = _storage.getJson(key);
      if (json != null) {
        watchlists.add(WatchlistModel.fromJson(json).toEntity());
      }
    }
    watchlists.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return watchlists;
  }

  @override
  Future<Watchlist?> getWatchlist(String id) async {
    final json = _storage.getJson('$_prefix$id');
    if (json == null) return null;
    return WatchlistModel.fromJson(json).toEntity();
  }

  @override
  Future<Watchlist> createWatchlist(String name) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final existing = await getWatchlists();
    final model = WatchlistModel(
      id: id,
      name: name,
      playerIds: [],
      sortOrder: existing.length,
      createdAt: DateTime.now().toIso8601String(),
    );
    await _storage.setJson('$_prefix$id', model.toJson());
    _storage.notifyWatchlistChanged();
    return model.toEntity();
  }

  @override
  Future<void> deleteWatchlist(String id) async {
    await _storage.remove('$_prefix$id');
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<void> addPlayer(String watchlistId, int playerId) async {
    final watchlist = await getWatchlist(watchlistId);
    if (watchlist == null) return;
    if (watchlist.playerIds.contains(playerId)) return;

    final updated = Watchlist(
      id: watchlist.id,
      name: watchlist.name,
      playerIds: [...watchlist.playerIds, playerId],
      sortOrder: watchlist.sortOrder,
      createdAt: watchlist.createdAt,
    );
    await _storage.setJson('$_prefix$watchlistId', updated.toModel().toJson());
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<void> removePlayer(String watchlistId, int playerId) async {
    final watchlist = await getWatchlist(watchlistId);
    if (watchlist == null) return;

    final updated = Watchlist(
      id: watchlist.id,
      name: watchlist.name,
      playerIds: watchlist.playerIds.where((id) => id != playerId).toList(),
      sortOrder: watchlist.sortOrder,
      createdAt: watchlist.createdAt,
    );
    await _storage.setJson('$_prefix$watchlistId', updated.toModel().toJson());
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<void> renameWatchlist(String id, String newName) async {
    final watchlist = await getWatchlist(id);
    if (watchlist == null) return;

    final updated = Watchlist(
      id: watchlist.id,
      name: newName,
      playerIds: watchlist.playerIds,
      sortOrder: watchlist.sortOrder,
      createdAt: watchlist.createdAt,
    );
    await _storage.setJson('$_prefix$id', updated.toModel().toJson());
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<void> movePlayer(String fromId, String toId, int playerId) async {
    final from = await getWatchlist(fromId);
    final to = await getWatchlist(toId);
    if (from == null || to == null) return;
    if (to.playerIds.contains(playerId)) return;

    final updatedFrom = Watchlist(
      id: from.id,
      name: from.name,
      playerIds: from.playerIds.where((id) => id != playerId).toList(),
      sortOrder: from.sortOrder,
      createdAt: from.createdAt,
    );
    final updatedTo = Watchlist(
      id: to.id,
      name: to.name,
      playerIds: [...to.playerIds, playerId],
      sortOrder: to.sortOrder,
      createdAt: to.createdAt,
    );

    await _storage.setJson('$_prefix$fromId', updatedFrom.toModel().toJson());
    await _storage.setJson('$_prefix$toId', updatedTo.toModel().toJson());
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<void> reorderPlayers(
    String watchlistId,
    List<int> playerIds,
  ) async {
    final watchlist = await getWatchlist(watchlistId);
    if (watchlist == null) return;

    final updated = Watchlist(
      id: watchlist.id,
      name: watchlist.name,
      playerIds: playerIds,
      sortOrder: watchlist.sortOrder,
      createdAt: watchlist.createdAt,
    );
    await _storage.setJson('$_prefix$watchlistId', updated.toModel().toJson());
    _storage.notifyWatchlistChanged();
  }

  @override
  Future<Watchlist?> findWatchlistContainingPlayer(int playerId) async {
    final all = await getWatchlists();
    for (final wl in all) {
      if (wl.playerIds.contains(playerId)) return wl;
    }
    return null;
  }

  @override
  Future<void> ensureDefaultWatchlist() async {
    final all = await getWatchlists();
    if (all.isEmpty) {
      await createWatchlist('My Players');
    }
  }

  @override
  Stream<void> get watchlistChanges => _storage.watchlistChanges;
}
