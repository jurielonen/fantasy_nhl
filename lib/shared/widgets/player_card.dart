import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/player/domain/entities/player.dart';
import 'player_hero_context.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final String? featuredStat;
  final String? featuredStatLabel;
  final VoidCallback? onTap;

  const PlayerCard({
    super.key,
    required this.player,
    this.featuredStat,
    this.featuredStatLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Headshot
            Positioned.fill(
              child: Hero(
                tag: PlayerHeroContext.spotlight.tag(player.id),
                child: player.headshot != null
                    ? CachedNetworkImage(
                        imageUrl: player.headshot!,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) => const ColoredBox(
                          color: AppColors.surfaceVariant,
                        ),
                        errorWidget: (context, url, error) => const ColoredBox(
                          color: AppColors.surfaceVariant,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                    : const ColoredBox(
                        color: AppColors.surfaceVariant,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                      ),
              ),
            ),
            // Gradient overlay
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 100,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.surface.withValues(alpha: 0.85),
                      AppColors.surface,
                    ],
                  ),
                ),
              ),
            ),
            // Info
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    player.fullName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (player.teamAbbrev != null)
                        Text(
                          player.teamAbbrev!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      const Text(
                        ' · ',
                        style: TextStyle(color: AppColors.textTertiary),
                      ),
                      Text(
                        player.position,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (featuredStat != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      featuredStat!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerPlayerCard extends StatelessWidget {
  const ShimmerPlayerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
