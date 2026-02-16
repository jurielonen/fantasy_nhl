import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/local_storage_service.dart';
import 'providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          _SectionHeader('Appearance', theme),
          _ThemeTile(ref: ref, theme: theme),
          const Divider(height: 1),
          _SectionHeader('Data', theme),
          _CacheTile(ref: ref, theme: theme),
          const Divider(height: 1),
          _SectionHeader('About', theme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber_outlined),
            title: const Text('Disclaimer'),
            subtitle: Text(
              'This app uses unofficial NHL API data. '
              'Not affiliated with or endorsed by the NHL.',
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
      title: const Text('Theme'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SegmentedButton<AppThemeMode>(
          segments: const [
            ButtonSegment(
              value: AppThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode),
            ),
            ButtonSegment(
              value: AppThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode),
            ),
            ButtonSegment(
              value: AppThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.settings_brightness),
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
      title: const Text('Clear Cache'),
      subtitle: Text('$count cached entries'),
      trailing: FilledButton.tonal(
        onPressed: () async {
          final cleared = await storage.clearCache();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cleared $cleared cache entries')),
            );
            // Force rebuild to update count
            ref.invalidate(themeModeProvider);
          }
        },
        child: const Text('Clear'),
      ),
    );
  }
}
