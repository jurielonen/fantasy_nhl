import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/player_detail.dart';

class SeasonStatsCard extends StatelessWidget {
  final PlayerSeasonStats? stats;
  final String title;

  const SeasonStatsCard({
    super.key,
    required this.stats,
    this.title = 'Season Stats',
  });

  @override
  Widget build(BuildContext context) {
    if (stats == null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text('No stats available', style: AppTextStyles.bodyMedium),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          switch (stats!) {
            SkaterSeasonStats s => _SkaterStatsGrid(stats: s),
            GoalieSeasonStats s => _GoalieStatsGrid(stats: s),
          },
        ],
      ),
    );
  }
}

class _SkaterStatsGrid extends StatelessWidget {
  final SkaterSeasonStats stats;
  const _SkaterStatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem('GP', '${stats.gamesPlayed}'),
      _StatItem('G', '${stats.goals}'),
      _StatItem('A', '${stats.assists}'),
      _StatItem('P', '${stats.points}'),
      _StatItem('+/-', '${stats.plusMinus > 0 ? "+" : ""}${stats.plusMinus}'),
      _StatItem('PIM', '${stats.pim}'),
      if (stats.ppGoals != null) _StatItem('PPG', stats.ppGoals.toString()),
      if (stats.shGoals != null) _StatItem('SHG', stats.shGoals.toString()),
      _StatItem('GWG', '${stats.gameWinningGoals}'),
      _StatItem('S', '${stats.shots}'),
      _StatItem(
        'S%',
        stats.shootingPctg != null
            ? (stats.shootingPctg! * 100).toStringAsFixed(1)
            : '-',
      ),
      if (stats.avgToi != null) _StatItem('TOI/G', stats.avgToi!),
      if (stats.faceoffPctg != null)
        _StatItem('FO%', (stats.faceoffPctg! * 100).toStringAsFixed(1)),
    ];

    return _StatsGrid(items: items);
  }
}

class _GoalieStatsGrid extends StatelessWidget {
  final GoalieSeasonStats stats;
  const _GoalieStatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem('GP', '${stats.gamesPlayed}'),
      _StatItem('W', '${stats.wins}'),
      _StatItem('L', '${stats.losses}'),
      _StatItem('OTL', '${stats.otLosses}'),
      _StatItem('GAA', stats.gaa.toStringAsFixed(2)),
      _StatItem('SV%', '.${(stats.savePctg * 1000).round()}'),
      _StatItem('SO', '${stats.shutouts}'),
    ];

    return _StatsGrid(items: items);
  }
}

class _StatsGrid extends StatelessWidget {
  final List<_StatItem> items;
  const _StatsGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      runSpacing: 8,
      children: items.map((item) {
        return SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.value,
                style: AppTextStyles.statValue.copyWith(fontSize: 17),
              ),
              const SizedBox(height: 2),
              Text(item.label, style: AppTextStyles.statLabel),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem(this.label, this.value);
}
