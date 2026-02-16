import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/watchlist.dart';
import '../../providers.dart';
import '../providers/watchlist_providers.dart';
import 'create_watchlist_dialog.dart';

class WatchlistSelector extends ConsumerWidget {
  const WatchlistSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchlistsAsync = ref.watch(watchlistsProvider);
    final selectedId = ref.watch(selectedWatchlistIdProvider);

    return watchlistsAsync.when(
      data: (watchlists) => SizedBox(
        height: 48,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            ...watchlists.map((wl) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onLongPress: () => _showEditSheet(context, ref, wl),
                    child: ChoiceChip(
                      label: Text(wl.name),
                      selected: wl.id == selectedId,
                      onSelected: (_) {
                        ref.read(selectedWatchlistIdProvider.notifier).select(
                            wl.id);
                      },
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionChip(
                avatar: const Icon(Icons.add, size: 18),
                label: Text(context.l10n.commonNew),
                onPressed: () => _createWatchlist(context, ref),
              ),
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 48),
      error: (_, _) => const SizedBox(height: 48),
    );
  }

  Future<void> _createWatchlist(BuildContext context, WidgetRef ref) async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const CreateWatchlistDialog(),
    );
    if (name != null && name.isNotEmpty) {
      final wl =
          await ref.read(watchlistRepositoryProvider).createWatchlist(name);
      ref.read(selectedWatchlistIdProvider.notifier).select(wl.id);
    }
  }

  void _showEditSheet(BuildContext context, WidgetRef ref, Watchlist wl) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: Text(ctx.l10n.commonRename),
              onTap: () {
                Navigator.pop(ctx);
                _renameWatchlist(context, ref, wl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title:
                  Text(context.l10n.commonDelete, style: const TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, ref, wl);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _renameWatchlist(
    BuildContext context,
    WidgetRef ref,
    Watchlist wl,
  ) async {
    final controller = TextEditingController(text: wl.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.watchlistRenameTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: context.l10n.watchlistNameHint,
            filled: true,
            fillColor: AppColors.surfaceVariant,
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(context.l10n.commonRename),
          ),
        ],
      ),
    );
    controller.dispose();
    if (newName != null && newName.isNotEmpty && newName != wl.name) {
      await ref.read(watchlistRepositoryProvider).renameWatchlist(wl.id, newName);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Watchlist wl,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.watchlistDeleteTitle),
        content: Text(
          context.l10n.watchlistDeleteConfirm(wl.name, wl.playerIds.length),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(context.l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(context.l10n.commonDelete, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(watchlistRepositoryProvider).deleteWatchlist(wl.id);
      // Reset selection so it picks a new first
      ref.read(selectedWatchlistIdProvider.notifier).select(null);
    }
  }
}
