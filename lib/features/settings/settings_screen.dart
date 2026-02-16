import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import '../../core/utils/extensions.dart';
import 'providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsTitle)),
      body: ListView(
        children: [
          _SectionHeader(context.l10n.settingsAppearance, theme),
          _ThemeTile(ref: ref, theme: theme),
          const Divider(height: 1),
          _SectionHeader(context.l10n.settingsData, theme),
          _CacheTile(ref: ref, theme: theme),
          const Divider(height: 1),
          _SectionHeader(context.l10n.settingsAbout, theme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(context.l10n.settingsVersion),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber_outlined),
            title: Text(context.l10n.settingsDisclaimer),
            subtitle: Text(
              context.l10n.settingsDisclaimerText,
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final ThemeData theme;

  const _SectionHeader(this.title, this.theme);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final WidgetRef ref;
  final ThemeData theme;

  const _ThemeTile({required this.ref, required this.theme});

  @override
  Widget build(BuildContext context) {
    final currentMode = ref.watch(themeModeProvider);

    return ListTile(
      leading: const Icon(Icons.palette_outlined),
      title: Text(context.l10n.settingsTheme),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SegmentedButton<AppThemeMode>(
          segments: [
            ButtonSegment(
              value: AppThemeMode.dark,
              label: Text(context.l10n.settingsThemeDark),
              icon: const Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: AppThemeMode.light,
              label: Text(context.l10n.settingsThemeLight),
              icon: const Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: AppThemeMode.system,
              label: Text(context.l10n.settingsThemeSystem),
              icon: const Icon(Icons.settings_brightness),
            ),
          ],
          selected: {currentMode},
          onSelectionChanged: (selection) {
            ref.read(themeModeProvider.notifier).select(selection.first);
          },
        ),
      ),
    );
  }
}

class _CacheTile extends StatelessWidget {
  final WidgetRef ref;
  final ThemeData theme;

  const _CacheTile({required this.ref, required this.theme});

  @override
  Widget build(BuildContext context) {
    final storage = ref.read(localStorageProvider);
    final count = storage.getCacheEntryCount();

    return ListTile(
      leading: const Icon(Icons.cached),
      title: Text(context.l10n.settingsClearCache),
      subtitle: Text(context.l10n.settingsCacheCount(count)),
      trailing: FilledButton.tonal(
        onPressed: () async {
          final cleared = await storage.clearCache();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(context.l10n.settingsCacheCleared(cleared))),
            );
            ref.invalidate(themeModeProvider);
          }
        },
        child: Text(context.l10n.commonClear),
      ),
    );
  }
}
