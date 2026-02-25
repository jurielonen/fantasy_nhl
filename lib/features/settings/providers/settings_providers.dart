import 'package:flutter/material.dart' show ThemeMode;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database_provider.dart';

part 'settings_providers.g.dart';

enum AppThemeMode { dark, light, system }

/// Seeded at app startup with the stored theme string (or null).
/// Overridden in main() before runApp().
@Riverpod(keepAlive: true)
String? initialThemeMode(Ref ref) => null;

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const _storageKey = 'settings:theme_mode';

  @override
  AppThemeMode build() {
    final stored = ref.watch(initialThemeModeProvider);
    return switch (stored) {
      'light' => AppThemeMode.light,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.dark,
    };
  }

  Future<void> select(AppThemeMode mode) async {
    state = mode;
    await ref.read(settingsDaoProvider).setValue(_storageKey, mode.name);
  }
}

/// Maps AppThemeMode to Flutter's ThemeMode.
@Riverpod(keepAlive: true)
ThemeMode flutterThemeMode(Ref ref) {
  final mode = ref.watch(themeModeProvider);
  return switch (mode) {
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.system => ThemeMode.system,
  };
}

/// Exposed for the settings cache tile; also used by settings_screen.dart.
@riverpod
Future<int> cacheCount(Ref ref) {
  return ref.watch(apiCacheDaoProvider).count();
}
