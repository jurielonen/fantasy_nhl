import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../domain/entities/schedule_game.dart';

class ScheduleGameCard extends StatefulWidget {
  final ScheduleGame game;
  final List<String> homeWatchlistNames;
  final List<String> awayWatchlistNames;

  const ScheduleGameCard({
    super.key,
    required this.game,
    this.homeWatchlistNames = const [],
    this.awayWatchlistNames = const [],
  });

  @override
  State<ScheduleGameCard> createState() => _ScheduleGameCardState();
}

class _ScheduleGameCardState extends State<ScheduleGameCard> {
  bool _goalsExpanded = false;

  ScheduleGame get game => widget.game;

  @override
  Widget build(BuildContext context) {
    final hasWatchlistPlayers =
        widget.homeWatchlistNames.isNotEmpty ||
        widget.awayWatchlistNames.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: hasWatchlistPlayers
          ? AppColors.accent.withValues(alpha: 0.05)
          : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: game.goals.isNotEmpty
            ? () => setState(() => _goalsExpanded = !_goalsExpanded)
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Main matchup row
              _buildMatchupRow(),
              // Venue
              if (game.venue != null) ...[
                const SizedBox(height: 4),
                Text(
                  game.venue!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
              // Shots on goal (live or final)
              if (_showShotsOnGoal) ...[
                const SizedBox(height: 6),
                _buildShotsRow(),
              ],
              // Watchlist players with goal/assist contributions
              if (hasWatchlistPlayers) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 6),
                _buildWatchlistSection(),
              ],
              // Expandable goals timeline
              if (_goalsExpanded && game.goals.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 6),
                _GoalsTimeline(goals: game.goals),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _showShotsOnGoal =>
      (game.gameState == GameState.live ||
          game.gameState == GameState.final_) &&
      (game.awayTeam?.shotsOnGoal != null ||
          game.homeTeam?.shotsOnGoal != null);

  Widget _buildMatchupRow() {
    return Row(
      children: [
        // Away team
        Expanded(child: _TeamColumn(team: game.awayTeam, alignEnd: false)),
        // Score / Time center
        _GameStatusCenter(game: game),
        // Home team
        Expanded(child: _TeamColumn(team: game.homeTeam, alignEnd: true)),
      ],
    );
  }

  Widget _buildShotsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${game.awayTeam?.shotsOnGoal ?? 0}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Text(
          ' SOG ',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '${game.homeTeam?.shotsOnGoal ?? 0}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildWatchlistSection() {
    // Find goal/assist contributions from watchlisted players
    final awayContributions = _getWatchlistContributions(
      widget.awayWatchlistNames,
      game,
    );
    final homeContributions = _getWatchlistContributions(
      widget.homeWatchlistNames,
      game,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _WatchlistNames(
            names: widget.awayWatchlistNames,
            contributions: awayContributions,
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: _WatchlistNames(
            names: widget.homeWatchlistNames,
            contributions: homeContributions,
            align: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }

  /// Maps player name → contribution string (e.g. "1G 1A")
  Map<String, String> _getWatchlistContributions(
    List<String> watchlistNames,
    ScheduleGame game,
  ) {
    if (watchlistNames.isEmpty || game.goals.isEmpty) return {};
    final result = <String, String>{};

    for (final name in watchlistNames) {
      var goals = 0;
      var assists = 0;

      for (final goal in game.goals) {
        if (goal.scorerName == name) goals++;
        if (goal.assists.contains(name)) assists++;
      }

      if (goals > 0 || assists > 0) {
        final parts = <String>[];
        if (goals > 0) parts.add('${goals}G');
        if (assists > 0) parts.add('${assists}A');
        result[name] = parts.join(' ');
      }
    }

    return result;
  }
}

class _TeamColumn extends StatelessWidget {
  final GameTeam? team;
  final bool alignEnd;

  const _TeamColumn({this.team, required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        if (team?.logoUrl != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: CachedNetworkImage(
              imageUrl: team!.logoUrl!,
              width: 32,
              height: 32,
              errorWidget: (context, url, error) => const SizedBox(width: 32),
            ),
          ),
        Text(
          team?.abbrev ?? '',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (team?.name != null && team!.name.isNotEmpty)
          Text(
            team!.name,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _GameStatusCenter extends StatelessWidget {
  final ScheduleGame game;

  const _GameStatusCenter({required this.game});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: switch (game.gameState) {
        GameState.live => _buildLive(context),
        GameState.final_ => _buildFinal(context),
        GameState.future => _buildFuture(context),
        GameState.off => _buildFuture(context),
      },
    );
  }

  Widget _buildLive(BuildContext context) {
    final periodText = _periodDisplay(context);
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pulsing live indicator dot
            _PulsingDot(),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                context.l10n.scheduleLive,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '${game.awayScore ?? 0} - ${game.homeScore ?? 0}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        if (periodText != null)
          Text(
            periodText,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  String? _periodDisplay(BuildContext context) {
    if (game.clock == null) return null;
    final clock = game.clock!;
    if (clock.inIntermission) {
      return context.l10n.scheduleIntermission;
    }
    final periodNum = game.period ?? 0;
    final periodLabel = switch (periodNum) {
      1 => context.l10n.schedulePeriodFirst,
      2 => context.l10n.schedulePeriodSecond,
      3 => context.l10n.schedulePeriodThird,
      _ when game.periodType == 'OT' => 'OT',
      _ => 'P$periodNum',
    };
    return '$periodLabel ${clock.timeRemaining}';
  }

  Widget _buildFinal(BuildContext context) {
    final label = _finalLabel(context);
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textTertiary),
        ),
        const SizedBox(height: 2),
        Text(
          '${game.awayScore ?? 0} - ${game.homeScore ?? 0}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _finalLabel(BuildContext context) {
    final lastPeriod = game.gameOutcomeLastPeriodType;
    if (lastPeriod == null || lastPeriod == 'REG') {
      return context.l10n.scheduleFinal;
    }
    return context.l10n.scheduleFinalWith(lastPeriod);
  }

  Widget _buildFuture(BuildContext context) {
    return Text(
      _formatTime(context, game.startTimeUtc),
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }

  String _formatTime(BuildContext context, String? utcTime) {
    if (utcTime == null) return context.l10n.scheduleTbd;
    try {
      final dt = DateTime.parse(utcTime).toLocal();
      final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
      final minute = dt.minute.toString().padLeft(2, '0');
      final period = dt.hour >= 12 ? 'PM' : 'AM';
      return '$hour:$minute $period';
    } catch (_) {
      return context.l10n.scheduleTbd;
    }
  }
}

class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.success.withValues(
              alpha: 0.4 + (_controller.value * 0.6),
            ),
          ),
        );
      },
    );
  }
}

class _GoalsTimeline extends StatelessWidget {
  final List<GameGoal> goals;

  const _GoalsTimeline({required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.scheduleGoals,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        ...goals.map((goal) => _GoalRow(goal: goal)),
      ],
    );
  }
}

class _GoalRow extends StatelessWidget {
  final GameGoal goal;

  const _GoalRow({required this.goal});

  @override
  Widget build(BuildContext context) {
    final assistText = goal.assists.isEmpty
        ? context.l10n.scheduleUnassisted
        : goal.assists.join(', ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Period + time
          SizedBox(
            width: 48,
            child: Text(
              'P${goal.period} ${goal.timeInPeriod}',
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Mugshot
          if (goal.scorerMugshot != null) ...[
            ClipOval(
              child: CachedNetworkImage(
                imageUrl: goal.scorerMugshot!,
                width: 20,
                height: 20,
                errorWidget: (context, url, error) => const SizedBox(width: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
          // Scorer + team + score
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: goal.scorerName,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: ' (${goal.teamAbbrev})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (goal.strength != 'ev')
                        TextSpan(
                          text: ' ${goal.strength.toUpperCase()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accent,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  assistText,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          // Running score
          Text(
            '${goal.awayScore}-${goal.homeScore}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _WatchlistNames extends StatelessWidget {
  final List<String> names;
  final Map<String, String> contributions;
  final CrossAxisAlignment align;

  const _WatchlistNames({
    required this.names,
    this.contributions = const {},
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: align,
      children: names.map((n) {
        final contrib = contributions[n];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (align == CrossAxisAlignment.end) const Spacer(),
            Text(
              n,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (contrib != null) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  contrib,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ],
        );
      }).toList(),
    );
  }
}
