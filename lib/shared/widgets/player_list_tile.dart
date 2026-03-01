import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/extensions.dart';
import '../../features/player/domain/entities/player.dart';
import '../../features/watchlist/presentation/providers/watchlist_providers.dart';
import 'player_hero_context.dart';

class PlayerListTile extends ConsumerWidget {
  final Player player;
  final PlayerHeroContext heroContext;
  final String? trailingStat;
  final String? trailingLabel;
  final VoidCallback? onTap;
  final VoidCallback? onAddToWatchlist;
  final VoidCallback? onRemoveFromWatchlist;

  const PlayerListTile({
    super.key,
    required this.player,
    required this.heroContext,
    this.trailingStat,
    this.trailingLabel,
    this.onTap,
    this.onAddToWatchlist,
    this.onRemoveFromWatchlist,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showWatchlistButton = onAddToWatchlist != null;
    final isInWatchlist = showWatchlistButton
        ? ref.watch(isPlayerInWatchlistProvider(player.id)).value ?? false
        : false;
    final colors = context.appColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Hero(
              tag: heroContext.tag(player.id),
              child: _PlayerAvatar(
                url: player.headshot,
                fallback: player.firstName.isNotEmpty
                    ? player.firstName[0]
                    : '?',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.fullName,
                    style: context.tsPlayerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (player.teamAbbrev != null) ...[
                        _TeamBadge(player.teamAbbrev!),
                        const SizedBox(width: 6),
                      ],
                      _PositionChip(player.position),
                      if (player.sweaterNumber != null) ...[
                        const SizedBox(width: 6),
                        Text(
                          '#${player.sweaterNumber}',
                          style: context.tsBodySmallTertiary,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (trailingStat != null) ...[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(trailingStat!, style: context.tsStatValueSmall),
                  if (trailingLabel != null)
                    Text(trailingLabel!, style: context.tsCaption),
                ],
              ),
              const SizedBox(width: 8),
            ],
            if (showWatchlistButton)
              IconButton(
                icon: Icon(
                  isInWatchlist
                      ? Icons.bookmark_added
                      : Icons.add_circle_outline,
                  size: 22,
                  color: colors.accent,
                ),
                onPressed: isInWatchlist
                    ? onRemoveFromWatchlist
                    : onAddToWatchlist,
                tooltip: isInWatchlist
                    ? context.l10n.commonInWatchlist
                    : context.l10n.commonAddToWatchlist,
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ),
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final String? url;
  final String fallback;

  const _PlayerAvatar({this.url, required this.fallback});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: colors.surfaceVariant,
        child: Text(fallback, style: context.tsBodyMedium),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: colors.surfaceVariant,
      backgroundImage: CachedNetworkImageProvider(url!),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String abbrev;
  const _TeamBadge(this.abbrev);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(abbrev, style: context.tsTableHeaderSecondary),
    );
  }
}

class _PositionChip extends StatelessWidget {
  final String position;
  const _PositionChip(this.position);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(position, style: context.tsStatLabel),
    );
  }
}

class ShimmerPlayerListTile extends StatelessWidget {
  const ShimmerPlayerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundColor: colors.surfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
