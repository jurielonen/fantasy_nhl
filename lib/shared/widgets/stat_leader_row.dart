import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/utils/extensions.dart';
import '../../features/player/domain/entities/stat_leader.dart';
import 'player_hero_context.dart';

class StatLeaderRow extends StatelessWidget {
  final int rank;
  final StatLeader leader;
  final VoidCallback? onTap;

  const StatLeaderRow({
    super.key,
    required this.rank,
    required this.leader,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '$rank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: rank <= 3 ? FontWeight.bold : FontWeight.normal,
                  color: rank <= 3 ? colors.accent : colors.textTertiary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Hero(
              tag: PlayerHeroContext.statLeader.tag(leader.playerId),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: colors.surfaceVariant,
                backgroundImage: leader.headshot != null
                    ? CachedNetworkImageProvider(leader.headshot!)
                    : null,
                child: leader.headshot == null
                    ? Text(
                        leader.firstName.isNotEmpty ? leader.firstName[0] : '?',
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    leader.fullName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (leader.teamAbbrev != null)
                    Text(
                      leader.teamAbbrev!,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              _formatStatValue(leader.statValue, leader.statCategory),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatStatValue(double value, String category) {
    if (category == 'gaa') return value.toStringAsFixed(2);
    if (category == 'savePctg') {
      return value >= 1
          ? value.toStringAsFixed(3)
          : '.${(value * 1000).round()}';
    }
    return value.truncate() == value
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
