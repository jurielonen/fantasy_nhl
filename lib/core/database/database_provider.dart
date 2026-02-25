import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'app_database.dart';
import 'daos/api_cache_dao.dart';
import 'daos/player_cache_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/watchlist_dao.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  throw UnimplementedError('appDatabaseProvider must be overridden at startup');
}

@Riverpod(keepAlive: true)
WatchlistDao watchlistDao(Ref ref) => ref.watch(appDatabaseProvider).watchlistDao;

@Riverpod(keepAlive: true)
PlayerCacheDao playerCacheDao(Ref ref) =>
    ref.watch(appDatabaseProvider).playerCacheDao;

@Riverpod(keepAlive: true)
ApiCacheDao apiCacheDao(Ref ref) => ref.watch(appDatabaseProvider).apiCacheDao;

@Riverpod(keepAlive: true)
SettingsDao settingsDao(Ref ref) => ref.watch(appDatabaseProvider).settingsDao;
