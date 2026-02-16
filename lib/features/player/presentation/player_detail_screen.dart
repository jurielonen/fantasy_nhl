import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_error_widget.dart';
import '../../../shared/widgets/shimmer_loader.dart';
import '../../watchlist/presentation/providers/add_to_watchlist_action.dart';
import '../../watchlist/providers.dart';
import '../domain/entities/player.dart';
import 'providers/player_detail_providers.dart';
import 'widgets/career_stats_tab.dart';
import 'widgets/game_log_tab.dart';
import 'widgets/player_detail_header.dart';
import 'widgets/season_stats_card.dart';
import 'widgets/stat_trend_chart.dart';
import 'widgets/upcoming_schedule_tab.dart';

class PlayerDetailScreen extends ConsumerStatefulWidget {
  final int playerId;

  const PlayerDetailScreen({super.key, required this.playerId});

  @override
  ConsumerState<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends ConsumerState<PlayerDetailScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    ref.invalidate(playerDetailProvider(widget.playerId));
    ref.invalidate(playerGameLogProvider(widget.playerId));
    // Schedule provider is invalidated when we know the team
    final detail = ref.read(playerDetailProvider(widget.playerId));
    if (detail.hasValue && detail.value!.player.teamAbbrev != null) {
      ref.invalidate(
        playerUpcomingScheduleProvider(detail.value!.player.teamAbbrev!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(playerDetailProvider(widget.playerId));
    final gameLogAsync = ref.watch(playerGameLogProvider(widget.playerId));

    return Scaffold(
      body: detailAsync.when(
        loading: () => _buildLoadingState(),
        error: (error, _) => CustomScrollView(
          slivers: [
            const SliverAppBar(title: Text('Player Detail')),
            SliverFillRemaining(
              child: AppErrorWidget(
                message: 'Failed to load player',
                onRetry: _refresh,
              ),
            ),
          ],
        ),
        data: (detail) {
          final isGoalie = detail.player.position == 'G';
          final teamAbbrev = detail.player.teamAbbrev;

          final scheduleAsync = teamAbbrev != null
              ? ref.watch(playerUpcomingScheduleProvider(teamAbbrev))
              : const AsyncValue<List<dynamic>>.data([]);

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                title: Text(detail.player.fullName),
                floating: true,
                snap: true,
                forceElevated: innerBoxIsScrolled,
                actions: [
                  _WatchlistButton(
                    player: detail.player,
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: PlayerDetailHeader(
                  player: detail.player,
                  bio: detail.bio,
                ),
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  tabBar: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: AppColors.accent,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.accent,
                    dividerColor: AppColors.border,
                    labelStyle: AppTextStyles.labelLarge,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Game Log'),
                      Tab(text: 'Schedule'),
                      Tab(text: 'Career'),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                // Overview tab
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SeasonStatsCard(
                          stats: detail.currentSeasonStats,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _StatTrendSection(
                          gameLogAsync: gameLogAsync,
                          isGoalie: isGoalie,
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 24),
                      ),
                    ],
                  ),
                ),
                // Game Log tab
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    slivers: [
                      GameLogTab(
                        gameLogAsync: gameLogAsync,
                        onRetry: _refresh,
                      ),
                    ],
                  ),
                ),
                // Schedule tab
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    slivers: [
                      if (teamAbbrev != null)
                        UpcomingScheduleTab(
                          scheduleAsync: scheduleAsync.whenData(
                            (data) => data.cast(),
                          ),
                          teamAbbrev: teamAbbrev,
                          onRetry: _refresh,
                        )
                      else
                        const SliverFillRemaining(
                          child: Center(
                            child: Text(
                              'No team assigned',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Career tab
                RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                    slivers: [
                      CareerStatsTab(
                        seasons: detail.seasonBySeasonStats,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(title: Text('Loading...')),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const ShimmerLoader(width: 80, height: 80, borderRadius: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          ShimmerLoader(width: 180, height: 22),
                          SizedBox(height: 8),
                          ShimmerLoader(width: 120, height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const ShimmerLoader(height: 180),
                const SizedBox(height: 16),
                const ShimmerLoader(height: 250),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatTrendSection extends ConsumerWidget {
  final AsyncValue<List<dynamic>> gameLogAsync;
  final bool isGoalie;

  const _StatTrendSection({
    required this.gameLogAsync,
    required this.isGoalie,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMetric = ref.watch(selectedStatTrendProvider);

    return gameLogAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ShimmerLoader(height: 250),
      ),
      error: (_, _) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Could not load trend data',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      data: (entries) => StatTrendChart(
        gameLog: entries.cast(),
        selectedMetric: selectedMetric,
        isGoalie: isGoalie,
        onMetricChanged: (metric) =>
            ref.read(selectedStatTrendProvider.notifier).select(metric),
      ),
    );
  }
}

class _WatchlistButton extends ConsumerWidget {
  final Player player;

  const _WatchlistButton({required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
      future: _isInWatchlist(ref),
      builder: (context, snapshot) {
        final isInWatchlist = snapshot.data ?? false;
        return IconButton(
          icon: Icon(
            isInWatchlist ? Icons.bookmark_added : Icons.bookmark_add_outlined,
            color: isInWatchlist ? AppColors.accent : null,
          ),
          tooltip: isInWatchlist ? 'In watchlist' : 'Add to watchlist',
          onPressed: () async {
            if (isInWatchlist) {
              final repo = ref.read(watchlistRepositoryProvider);
              final wl =
                  await repo.findWatchlistContainingPlayer(player.id);
              if (wl != null) {
                await repo.removePlayer(wl.id, player.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '${player.fullName} removed from "${wl.name}"',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            } else {
              await addToWatchlist(ref, context, player);
            }
          },
        );
      },
    );
  }

  Future<bool> _isInWatchlist(WidgetRef ref) async {
    final wl = await ref
        .read(watchlistRepositoryProvider)
        .findWatchlistContainingPlayer(player.id);
    return wl != null;
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: AppColors.background,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
