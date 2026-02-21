import 'package:drift/drift.dart';

import '../app_database.dart';

part 'player_cache_dao.g.dart';

@DriftAccessor(tables: [CachedPlayers])
class PlayerCacheDao extends DatabaseAccessor<AppDatabase>
    with _$PlayerCacheDaoMixin {
  PlayerCacheDao(super.db);

  Future<CachedPlayerRow?> getById(int id) =>
      (select(cachedPlayers)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  Future<void> upsert(CachedPlayersCompanion entry) =>
      into(cachedPlayers).insertOnConflictUpdate(entry);
}
