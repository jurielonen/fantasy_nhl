import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/api_cache_dao.dart';
import 'daos/player_cache_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/watchlist_dao.dart';

final appDatabaseProvider = Provider<AppDatabase>((_) {
  throw UnimplementedError('appDatabaseProvider must be overridden at startup');
});

final watchlistDaoProvider = Provider<WatchlistDao>(
  (ref) => ref.watch(appDatabaseProvider).watchlistDao,
);

final playerCacheDaoProvider = Provider<PlayerCacheDao>(
  (ref) => ref.watch(appDatabaseProvider).playerCacheDao,
);

final apiCacheDaoProvider = Provider<ApiCacheDao>(
  (ref) => ref.watch(appDatabaseProvider).apiCacheDao,
);

final settingsDaoProvider = Provider<SettingsDao>(
  (ref) => ref.watch(appDatabaseProvider).settingsDao,
);
