import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/router/app_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/extensions.dart';
import '../../../shared/widgets/player_hero_context.dart';
import '../domain/entities/player.dart';
import 'providers/explore_providers.dart';
import 'widgets/browse_by_team.dart';
import 'widgets/search_results_list.dart';
import 'widgets/spotlight_carousel.dart';
import 'widgets/stat_leaders_section.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    ref.read(searchQueryProvider.notifier).set(query);
    setState(() {
      _isSearching = query.trim().isNotEmpty;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _onSearchChanged('');
    _searchFocusNode.unfocus();
  }

  void _navigateToPlayer(Player? player, int playerId, PlayerHeroContext heroContext) {
    PlayerDetailRoute(
      playerId: playerId,
      $extra: PlayerDetailExtra(heroContext: heroContext, player: player),
    ).push(context);
  }

  void _navigateToTeam(String teamAbbrev) {
    TeamRosterRoute(teamAbbrev: teamAbbrev).push(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(spotlightPlayersProvider);
          final cat = ref.read(selectedSkaterCategoryProvider);
          final gCat = ref.read(selectedGoalieCategoryProvider);
          ref.invalidate(skaterLeadersProvider(cat));
          ref.invalidate(goalieLeadersProvider(gCat));
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              title: Text(context.l10n.exploreTitle),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: context.l10n.exploreSearchHint,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      suffixIcon: _isSearching
                          ? IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: _clearSearch,
                            )
                          : null,
                      filled: true,
                      fillColor: AppColors.surfaceVariant,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isSearching)
              SliverToBoxAdapter(
                child: SearchResultsList(
                  onPlayerTap: (p) => _navigateToPlayer(p, p.id, PlayerHeroContext.searchResult),
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: SpotlightCarousel(
                  onPlayerTap: (p) => _navigateToPlayer(p, p.id, PlayerHeroContext.spotlight),
                ),
              ),
              SliverToBoxAdapter(
                child: StatLeadersSection(
                  onPlayerTap: (p) => _navigateToPlayer(p, p.id, PlayerHeroContext.statLeader),
                ),
              ),
              SliverToBoxAdapter(
                child: BrowseByTeam(onTeamTap: _navigateToTeam),
              ),
              const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
            ],
          ],
        ),
      ),
    );
  }
}
