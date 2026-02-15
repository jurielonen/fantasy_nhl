import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  final _watchlistController = StreamController<void>.broadcast();

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // --- Generic typed accessors ---

  String? getString(String key) => _prefs.getString(key);

  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  Future<bool> remove(String key) => _prefs.remove(key);

  /// Decode a JSON-encoded string stored at [key].
  Map<String, dynamic>? getJson(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Encode [value] as JSON and store under [key].
  Future<bool> setJson(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  /// Decode a JSON array stored at [key].
  List<Map<String, dynamic>>? getJsonList(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    return (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>();
  }

  /// Encode a list of maps as JSON and store under [key].
  Future<bool> setJsonList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  /// Return all keys matching a given prefix.
  Set<String> getKeysWithPrefix(String prefix) =>
      _prefs.getKeys().where((k) => k.startsWith(prefix)).toSet();

  // --- Cache metadata ---

  static String _cacheMetaKey(String key) => 'cache_meta:$key';

  /// Record the current timestamp as last-fetched for [key].
  Future<void> setCacheTimestamp(String key) =>
      _prefs.setString(
        _cacheMetaKey(key),
        DateTime.now().toIso8601String(),
      );

  /// Check whether the cache for [key] has expired.
  bool isCacheExpired(String key, {int? ttlMinutes}) {
    final raw = _prefs.getString(_cacheMetaKey(key));
    if (raw == null) return true;
    final lastFetched = DateTime.tryParse(raw);
    if (lastFetched == null) return true;
    final ttl = Duration(minutes: ttlMinutes ?? AppConstants.cacheDefaultTtlMinutes);
    return DateTime.now().difference(lastFetched) > ttl;
  }

  // --- Watchlist change stream ---

  /// Emits whenever watchlist data is modified.
  Stream<void> get watchlistChanges => _watchlistController.stream;

  /// Notify listeners that watchlist data changed.
  void notifyWatchlistChanged() => _watchlistController.add(null);

  void dispose() => _watchlistController.close();
}

final localStorageProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError(
    'localStorageProvider must be overridden with an initialized instance',
  );
});
