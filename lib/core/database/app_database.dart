import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/api_cache_dao.dart';
import 'daos/player_cache_dao.dart';
import 'daos/settings_dao.dart';
import 'daos/watchlist_dao.dart';

part 'app_database.g.dart';

// ── Table definitions ────────────────────────────────────────────────────────

@DataClassName('WatchlistRow')
class Watchlists extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WatchlistPlayerRow')
class WatchlistPlayers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get watchlistId => text().references(Watchlists, #id,
      onDelete: KeyAction.cascade)();
  IntColumn get playerId => integer()();
  IntColumn get position => integer().withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {watchlistId, playerId},
      ];
}

@DataClassName('CachedPlayerRow')
class CachedPlayers extends Table {
  IntColumn get id => integer()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get teamAbbrev => text().nullable()();
  TextColumn get teamName => text().nullable()();
  TextColumn get position => text()();
  IntColumn get sweaterNumber => integer().nullable()();
  TextColumn get headshot => text().nullable()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ApiCacheRow')
class ApiCache extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get data => text()();
  TextColumn get fetchedAt => text()(); // ISO-8601
  IntColumn get ttlMinutes =>
      integer().withDefault(const Constant(15))();

  @override
  Set<Column> get primaryKey => {cacheKey};
}

@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

// ── Database class ───────────────────────────────────────────────────────────

@DriftDatabase(
  tables: [Watchlists, WatchlistPlayers, CachedPlayers, ApiCache, Settings],
  daos: [WatchlistDao, PlayerCacheDao, ApiCacheDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration =>
      MigrationStrategy(onCreate: (m) => m.createAll());

  @override
  WatchlistDao get watchlistDao => WatchlistDao(this);
  @override
  PlayerCacheDao get playerCacheDao => PlayerCacheDao(this);
  @override
  ApiCacheDao get apiCacheDao => ApiCacheDao(this);
  @override
  SettingsDao get settingsDao => SettingsDao(this);

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'fantasy_nhl');
  }
}
