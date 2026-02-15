import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
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

  void _navigateToPlayer(int playerId) {
    context.push('/player/$playerId');
  }

  void _navigateToTeam(String teamAbbrev) {
    context.push('/explore/team/$teamAbbrev');
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
              title: const Text('Explore'),
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
                      hintText: 'Search players...',
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
                child: SearchResultsList(onPlayerTap: _navigateToPlayer),
              )
            else ...[
              SliverToBoxAdapter(
                child: SpotlightCarousel(onPlayerTap: _navigateToPlayer),
              ),
              SliverToBoxAdapter(
                child: StatLeadersSection(onPlayerTap: _navigateToPlayer),
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
