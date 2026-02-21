import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';

enum AppThemeMode { dark, light, system }

/// Seeded at app startup with the stored theme string (or null).
/// Overridden in main() before runApp().
final initialThemeModeProvider = Provider<String?>((_) => null);

class ThemeModeNotifier extends Notifier<AppThemeMode> {
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
