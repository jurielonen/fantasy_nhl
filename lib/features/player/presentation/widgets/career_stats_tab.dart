import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';
import '../../domain/entities/player_detail.dart';

class CareerStatsTab extends StatefulWidget {
  final List<PlayerSeasonRecord> seasons;

  const CareerStatsTab({super.key, required this.seasons});

  @override
  State<CareerStatsTab> createState() => _CareerStatsTabState();
}

class _CareerStatsTabState extends State<CareerStatsTab> {
  bool _nhlOnly = true;

  @override
  Widget build(BuildContext context) {
    final filtered = _nhlOnly
        ? widget.seasons.where((s) => s.leagueAbbrev == 'NHL').toList()
        : widget.seasons;

    if (widget.seasons.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            context.l10n.careerStatsEmpty,
            style: context.tsBodyMedium,
          ),
        ),
      );
    }

    final colors = context.appColors;
    final isGoalie =
        filtered.isNotEmpty && filtered.first.stats is GoalieSeasonStats;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Text(
                  context.l10n.careerStatsTitle,
                  style: context.tsTitleMedium,
                ),
                const Spacer(),
                if (widget.seasons.any((s) => s.leagueAbbrev != 'NHL'))
                  FilterChip(
                    label: Text(context.l10n.careerStatsNhlOnly),
                    selected: _nhlOnly,
                    onSelected: (v) => setState(() => _nhlOnly = v),
                    selectedColor: colors.accent.withValues(alpha: 0.2),
                    backgroundColor: colors.surfaceVariant,
                    labelStyle: TextStyle(
                      fontSize: 12,
                      color: _nhlOnly ? colors.accent : colors.textSecondary,
                    ),
                    side: BorderSide(
                      color: _nhlOnly ? colors.accent : colors.border,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
          ),
          // Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: isGoalie
                ? _GoalieTable(seasons: filtered)
                : _SkaterTable(seasons: filtered),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SkaterTable extends StatelessWidget {
  final List<PlayerSeasonRecord> seasons;
  const _SkaterTable({required this.seasons});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final headerStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: colors.textTertiary,
    );
    final dataStyle = TextStyle(fontSize: 12, color: colors.textPrimary);
    return DataTable(
      headingRowHeight: 36,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 36,
      columnSpacing: 16,
      horizontalMargin: 0,
      headingTextStyle: headerStyle,
      dataTextStyle: dataStyle,
      columns: [
        DataColumn(label: Text(context.l10n.careerStatsColumnSeason)),
        DataColumn(label: Text(context.l10n.careerStatsColumnTeam)),
        const DataColumn(label: Text('GP'), numeric: true),
        const DataColumn(label: Text('G'), numeric: true),
        const DataColumn(label: Text('A'), numeric: true),
        const DataColumn(label: Text('P'), numeric: true),
        const DataColumn(label: Text('+/-'), numeric: true),
        const DataColumn(label: Text('PIM'), numeric: true),
      ],
      rows: seasons.map((record) {
        final s = record.stats as SkaterSeasonStats;
        return DataRow(
          cells: [
            DataCell(Text(_formatSeason(record.season))),
            DataCell(Text(record.teamName ?? '-')),
            DataCell(Text('${s.gamesPlayed}')),
            DataCell(Text('${s.goals}')),
            DataCell(Text('${s.assists}')),
            DataCell(
              Text(
                '${s.points}',
                style: dataStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
            ),
            DataCell(
              Text(
                '${s.plusMinus > 0 ? "+" : ""}${s.plusMinus}',
                style: dataStyle.copyWith(
                  color: s.plusMinus > 0
                      ? colors.success
                      : s.plusMinus < 0
                      ? colors.error
                      : colors.textSecondary,
                ),
              ),
            ),
            DataCell(Text('${s.pim}')),
          ],
        );
      }).toList(),
    );
  }
}

class _GoalieTable extends StatelessWidget {
  final List<PlayerSeasonRecord> seasons;
  const _GoalieTable({required this.seasons});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final headerStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      color: colors.textTertiary,
    );
    final dataStyle = TextStyle(fontSize: 12, color: colors.textPrimary);
    return DataTable(
      headingRowHeight: 36,
      dataRowMinHeight: 32,
      dataRowMaxHeight: 36,
      columnSpacing: 16,
      horizontalMargin: 0,
      headingTextStyle: headerStyle,
      dataTextStyle: dataStyle,
      columns: [
        DataColumn(label: Text(context.l10n.careerStatsColumnSeason)),
        DataColumn(label: Text(context.l10n.careerStatsColumnTeam)),
        const DataColumn(label: Text('GP'), numeric: true),
        const DataColumn(label: Text('W'), numeric: true),
        const DataColumn(label: Text('L'), numeric: true),
        const DataColumn(label: Text('OTL'), numeric: true),
        const DataColumn(label: Text('GAA'), numeric: true),
        const DataColumn(label: Text('SV%'), numeric: true),
        const DataColumn(label: Text('SO'), numeric: true),
      ],
      rows: seasons.map((record) {
        final s = record.stats as GoalieSeasonStats;
        return DataRow(
          cells: [
            DataCell(Text(_formatSeason(record.season))),
            DataCell(Text(record.teamName ?? '-')),
            DataCell(Text('${s.gamesPlayed}')),
            DataCell(Text('${s.wins}')),
            DataCell(Text('${s.losses}')),
            DataCell(Text('${s.otLosses}')),
            DataCell(Text(s.gaa.toStringAsFixed(2))),
            DataCell(
              Text(
                '.${(s.savePctg * 1000).round()}',
                style: dataStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.accent,
                ),
              ),
            ),
            DataCell(Text('${s.shutouts}')),
          ],
        );
      }).toList(),
    );
  }
}

String _formatSeason(int season) {
  // 20242025 → "2024-25"
  final str = season.toString();
  if (str.length == 8) {
    return '${str.substring(0, 4)}-${str.substring(6, 8)}';
  }
  return str;
}
