import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/storage/local_storage_service.dart';

enum AppThemeMode { dark, light, system }

class ThemeModeNotifier extends Notifier<AppThemeMode> {
  static const _storageKey = 'settings:theme_mode';

  @override
  AppThemeMode build() {
    final storage = ref.read(localStorageProvider);
    final stored = storage.getString(_storageKey);
    return switch (stored) {
      'light' => AppThemeMode.light,
      'system' => AppThemeMode.system,
      _ => AppThemeMode.dark,
    };
  }

  void select(AppThemeMode mode) {
    state = mode;
    final storage = ref.read(localStorageProvider);
    storage.setString(_storageKey, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, AppThemeMode>(
  ThemeModeNotifier.new,
);

/// Maps AppThemeMode to Flutter's ThemeMode
final flutterThemeModeProvider = Provider<ThemeMode>((ref) {
  final mode = ref.watch(themeModeProvider);
  return switch (mode) {
    AppThemeMode.dark => ThemeMode.dark,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.system => ThemeMode.system,
  };
});
