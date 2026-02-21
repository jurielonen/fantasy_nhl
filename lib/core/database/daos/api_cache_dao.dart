import 'package:drift/drift.dart';

import '../app_database.dart';

part 'api_cache_dao.g.dart';

@DriftAccessor(tables: [ApiCache])
class ApiCacheDao extends DatabaseAccessor<AppDatabase>
    with _$ApiCacheDaoMixin {
  ApiCacheDao(super.db);

  Future<ApiCacheRow?> get(String key) =>
      (select(apiCache)..where((t) => t.cacheKey.equals(key)))
          .getSingleOrNull();

  bool isExpired(ApiCacheRow row) {
    final fetched = DateTime.tryParse(row.fetchedAt);
    if (fetched == null) return true;
    return DateTime.now().difference(fetched) >
        Duration(minutes: row.ttlMinutes);
  }

  Future<void> set(String key, String data, int ttlMinutes) =>
      into(apiCache).insertOnConflictUpdate(
        ApiCacheCompanion.insert(
          cacheKey: key,
          data: data,
          fetchedAt: DateTime.now().toIso8601String(),
          ttlMinutes: Value(ttlMinutes),
        ),
      );

  Future<void> deleteAll() => delete(apiCache).go();

  Future<int> count() async {
    final c = countAll();
    final query = selectOnly(apiCache)..addColumns([c]);
    final result = await query.getSingle();
    return result.read(c) ?? 0;
  }
}
