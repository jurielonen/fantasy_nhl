import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/database/database_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/providers/settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  final initialTheme =
      await db.settingsDao.getValue('settings:theme_mode');

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) => db),
        initialThemeModeProvider.overrideWith((ref) => initialTheme),
      ],
      child: const FantasyNhlApp(),
    ),
  );
}

class FantasyNhlApp extends ConsumerWidget {
  const FantasyNhlApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(flutterThemeModeProvider);

    return MaterialApp.router(
      title: 'Fantasy NHL',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
