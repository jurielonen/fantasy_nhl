import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/extensions.dart';
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
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
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
                        placeholder: (context, url) =>
                            ColoredBox(color: colors.surfaceVariant),
                        errorWidget: (context, url, error) => ColoredBox(
                          color: colors.surfaceVariant,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: colors.textTertiary,
                          ),
                        ),
                      )
                    : ColoredBox(
                        color: colors.surfaceVariant,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: colors.textTertiary,
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
                      colors.surface.withValues(alpha: 0.85),
                      colors.surface,
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
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
                          style: TextStyle(
                            fontSize: 11,
                            color: colors.textSecondary,
                          ),
                        ),
                      Text(' · ', style: TextStyle(color: colors.textTertiary)),
                      Text(
                        player.position,
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  if (featuredStat != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      featuredStat!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.accent,
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
        color: context.appColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
