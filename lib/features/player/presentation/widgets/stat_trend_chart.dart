import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/game_log_entry.dart';

class StatTrendChart extends StatelessWidget {
  final List<GameLogEntry> gameLog;
  final String selectedMetric;
  final bool isGoalie;
  final ValueChanged<String> onMetricChanged;

  const StatTrendChart({
    super.key,
    required this.gameLog,
    required this.selectedMetric,
    required this.isGoalie,
    required this.onMetricChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (gameLog.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          context.l10n.statTrendEmpty,
          style: AppTextStyles.bodyMedium,
        ),
      );
    }

    final locale = context.localeName;
    final metrics = isGoalie ? _goalieMetrics : _skaterMetrics(context);
    // Take last 25 games, reversed to show oldest first
    final entries = gameLog.take(25).toList().reversed.toList();
    final values = entries
        .map((e) => _extractMetric(e, selectedMetric))
        .toList();
    final rollingAvg = _calculateRollingAverage(values, 5);

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
          Text(context.l10n.statTrendTitle, style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          // Metric toggle chips
          Wrap(
            spacing: 8,
            children: metrics.entries.map((e) {
              final isSelected = e.key == selectedMetric;
              return ChoiceChip(
                label: Text(e.value),
                selected: isSelected,
                onSelected: (_) => onMetricChanged(e.key),
                selectedColor: AppColors.accent.withValues(alpha: 0.2),
                backgroundColor: AppColors.surfaceVariant,
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? AppColors.accent
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isSelected ? AppColors.accent : AppColors.border,
                ),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: LineChart(
              _buildChartData(values, rollingAvg, entries, locale),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildChartData(
    List<double> values,
    List<double?> rollingAvg,
    List<GameLogEntry> entries,
    String locale,
  ) {
    final maxY = values.isEmpty
        ? 5.0
        : (values.reduce(max) * 1.2).clamp(1.0, double.infinity);
    final minY = values.isEmpty ? 0.0 : min(0.0, values.reduce(min));

    return LineChartData(
      minY: _isPercentageMetric(selectedMetric) ? null : minY,
      maxY: _isPercentageMetric(selectedMetric) ? null : maxY,
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.border.withValues(alpha: 0.5),
          strokeWidth: 0.5,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            interval: max(1, (entries.length / 5).ceil()).toDouble(),
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= entries.length) {
                return const SizedBox.shrink();
              }
              final short = DateFormat.MMMd(locale).format(entries[index].date);
              return SideTitleWidget(
                meta: meta,
                child: Text(
                  short,
                  style: const TextStyle(
                    fontSize: 9,
                    color: AppColors.textTertiary,
                  ),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              return Text(
                _isPercentageMetric(selectedMetric)
                    ? '.${(value * 1000).round()}'
                    : value.toStringAsFixed(
                        value == value.roundToDouble() ? 0 : 1,
                      ),
                style: const TextStyle(
                  fontSize: 9,
                  color: AppColors.textTertiary,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => AppColors.surfaceVariant,
          tooltipBorderRadius: BorderRadius.circular(8),
          getTooltipItems: (spots) {
            return spots.map((spot) {
              final index = spot.x.toInt();
              final dateStr = index < entries.length
                  ? DateFormat.MMMd(locale).format(entries[index].date)
                  : '';
              final label = _isPercentageMetric(selectedMetric)
                  ? '.${(spot.y * 1000).round()}'
                  : spot.y.toStringAsFixed(
                      spot.y == spot.y.roundToDouble() ? 0 : 2,
                    );
              return LineTooltipItem(
                '$dateStr\n$label',
                const TextStyle(
                  fontSize: 11,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              );
            }).toList();
          },
        ),
      ),
      lineBarsData: [
        // Main line
        LineChartBarData(
          spots: List.generate(
            values.length,
            (i) => FlSpot(i.toDouble(), values[i]),
          ),
          isCurved: true,
          curveSmoothness: 0.2,
          color: AppColors.accent,
          barWidth: 2,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
              radius: 3,
              color: AppColors.accent,
              strokeWidth: 0,
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.accent.withValues(alpha: 0.1),
          ),
        ),
        // Rolling average line
        LineChartBarData(
          spots: [
            for (int i = 0; i < rollingAvg.length; i++)
              if (rollingAvg[i] != null) FlSpot(i.toDouble(), rollingAvg[i]!),
          ],
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.warning.withValues(alpha: 0.7),
          barWidth: 1.5,
          dashArray: [6, 3],
          dotData: const FlDotData(show: false),
        ),
      ],
    );
  }

  double _extractMetric(GameLogEntry entry, String metric) {
    return switch (metric) {
      'goals' => (entry.goals ?? 0).toDouble(),
      'assists' => (entry.assists ?? 0).toDouble(),
      'points' => (entry.points ?? 0).toDouble(),
      'shots' => (entry.shots ?? 0).toDouble(),
      'plusMinus' => (entry.plusMinus ?? 0).toDouble(),
      'savePctg' => entry.savePctg ?? 0.0,
      'goalsAgainst' => (entry.goalsAgainst ?? 0).toDouble(),
      _ => (entry.points ?? 0).toDouble(),
    };
  }

  bool _isPercentageMetric(String metric) => metric == 'savePctg';

  List<double?> _calculateRollingAverage(List<double> values, int window) {
    return List.generate(values.length, (i) {
      if (i < window - 1) return null;
      final slice = values.sublist(i - window + 1, i + 1);
      return slice.reduce((a, b) => a + b) / window;
    });
  }
}

Map<String, String> _skaterMetrics(BuildContext context) => {
  'points': context.l10n.statTrendPoints,
  'goals': context.l10n.statTrendGoals,
  'assists': context.l10n.statTrendAssists,
  'shots': context.l10n.statTrendShots,
};

const _goalieMetrics = {'savePctg': 'SV%', 'goalsAgainst': 'GA'};
