import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/player/domain/entities/stat_leader.dart';

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
                  color: rank <= 3 ? AppColors.accent : AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceVariant,
              backgroundImage: leader.headshot != null
                  ? CachedNetworkImageProvider(leader.headshot!)
                  : null,
              child: leader.headshot == null
                  ? Text(
                      leader.firstName.isNotEmpty ? leader.firstName[0] : '?',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    leader.fullName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (leader.teamAbbrev != null)
                    Text(
                      leader.teamAbbrev!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              _formatStatValue(leader.statValue, leader.statCategory),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
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
