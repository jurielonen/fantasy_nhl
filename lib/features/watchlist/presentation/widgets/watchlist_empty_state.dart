import 'package:flutter/material.dart';
import '../../../../core/router/app_router.dart';

import '../../../../core/utils/extensions.dart';

class WatchlistEmptyState extends StatelessWidget {
  const WatchlistEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_search_outlined,
              size: 64,
              color: context.appColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.watchlistEmptyTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.watchlistEmptySubtitle,
              textAlign: TextAlign.center,
              style: context.tsBodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => const ExploreRoute().go(context),
              icon: const Icon(Icons.explore),
              label: Text(context.l10n.watchlistEmptyAction),
            ),
          ],
        ),
      ),
    );
  }
}
