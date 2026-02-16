import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../features/player/domain/entities/player.dart';

class PlayerListTile extends StatelessWidget {
  final Player player;
  final String? trailingStat;
  final String? trailingLabel;
  final VoidCallback? onTap;
  final VoidCallback? onAddToWatchlist;

  const PlayerListTile({
    super.key,
    required this.player,
    this.trailingStat,
    this.trailingLabel,
    this.onTap,
    this.onAddToWatchlist,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Hero(
              tag: 'player_${player.id}',
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
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
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textTertiary,
                          ),
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
                  Text(
                    trailingStat!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  if (trailingLabel != null)
                    Text(
                      trailingLabel!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            if (onAddToWatchlist != null)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                color: AppColors.accent,
                onPressed: onAddToWatchlist,
                tooltip: context.l10n.commonAddToWatchlist,
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
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.surfaceVariant,
        child: Text(fallback, style: const TextStyle(color: AppColors.textSecondary)),
      );
    }
    return CircleAvatar(
      radius: 22,
      backgroundColor: AppColors.surfaceVariant,
      backgroundImage: CachedNetworkImageProvider(url!),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String abbrev;
  const _TeamBadge(this.abbrev);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        abbrev,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _PositionChip extends StatelessWidget {
  final String position;
  const _PositionChip(this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        position,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class ShimmerPlayerListTile extends StatelessWidget {
  const ShimmerPlayerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const CircleAvatar(radius: 22, backgroundColor: AppColors.surfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 140,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 80,
                  height: 12,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
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
