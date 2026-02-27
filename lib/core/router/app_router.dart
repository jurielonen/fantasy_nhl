import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/player/presentation/explore_screen.dart';
import '../../features/player/presentation/player_detail_screen.dart';
import '../../features/player/presentation/team_roster_screen.dart';
import '../../shared/widgets/player_hero_context.dart';
import '../../features/schedule/presentation/schedule_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/watchlist/presentation/watchlist_screen.dart';
import '../utils/extensions.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

// ── GoRouter instance ────────────────────────────────────────────────────────
// $appRoutes is generated from the @Typed* annotations below.

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/watchlist',
  routes: $appRoutes,
);

// ── Shell (StatefulShellRoute) ───────────────────────────────────────────────

@TypedStatefulShellRoute<AppShellRouteData>(
  branches: [
    TypedStatefulShellBranch<WatchlistBranchData>(
      routes: [TypedGoRoute<WatchlistRoute>(path: '/watchlist')],
    ),
    TypedStatefulShellBranch<ExploreBranchData>(
      routes: [
        TypedGoRoute<ExploreRoute>(
          path: '/explore',
          routes: [TypedGoRoute<TeamRosterRoute>(path: 'team/:teamAbbrev')],
        ),
      ],
    ),
    TypedStatefulShellBranch<ScheduleBranchData>(
      routes: [TypedGoRoute<ScheduleRoute>(path: '/schedule')],
    ),
    TypedStatefulShellBranch<SettingsBranchData>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class AppShellRouteData extends StatefulShellRouteData {
  const AppShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) => AppShell(navigationShell: navigationShell);
}

class WatchlistBranchData extends StatefulShellBranchData {
  const WatchlistBranchData();
}

class ExploreBranchData extends StatefulShellBranchData {
  const ExploreBranchData();
}

class ScheduleBranchData extends StatefulShellBranchData {
  const ScheduleBranchData();
}

class SettingsBranchData extends StatefulShellBranchData {
  const SettingsBranchData();
}

// ── Leaf route data ──────────────────────────────────────────────────────────

class WatchlistRoute extends GoRouteData with $WatchlistRoute {
  const WatchlistRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const WatchlistScreen();
}

class ExploreRoute extends GoRouteData with $ExploreRoute {
  const ExploreRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ExploreScreen();
}

/// Displayed above the shell (full-screen); uses _rootNavigatorKey.
class TeamRosterRoute extends GoRouteData with $TeamRosterRoute {
  const TeamRosterRoute({required this.teamAbbrev});

  final String teamAbbrev;

  static final $parentNavigatorKey = _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      TeamRosterScreen(teamAbbrev: teamAbbrev);
}

class ScheduleRoute extends GoRouteData with $ScheduleRoute {
  const ScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ScheduleScreen();
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsScreen();
}

/// Displayed above the shell. Accepts an optional [PlayerDetailExtra] via
/// [$extra] carrying the pre-loaded [Player] and [PlayerHeroContext] so the
/// hero animation can start immediately.
@TypedGoRoute<PlayerDetailRoute>(path: '/player/:playerId')
class PlayerDetailRoute extends GoRouteData with $PlayerDetailRoute {
  const PlayerDetailRoute({required this.playerId, this.$extra});

  final int playerId;

  final PlayerDetailExtra? $extra;

  static final $parentNavigatorKey = _rootNavigatorKey;

  @override
  Widget build(BuildContext context, GoRouterState state) => PlayerDetailScreen(
    playerId: playerId,
    playerDetailExtra:
        $extra ??
        const PlayerDetailExtra(heroContext: PlayerHeroContext.watchlist),
  );
}

// ── AppShell widget ──────────────────────────────────────────────────────────

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 600) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: navigationShell.goBranch,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.list_alt),
                      selectedIcon: const Icon(Icons.list_alt_rounded),
                      label: Text(context.l10n.navWatchlist),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.explore_outlined),
                      selectedIcon: const Icon(Icons.explore),
                      label: Text(context.l10n.navExplore),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.calendar_today_outlined),
                      selectedIcon: const Icon(Icons.calendar_today),
                      label: Text(context.l10n.navSchedule),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings_outlined),
                      selectedIcon: const Icon(Icons.settings),
                      label: Text(context.l10n.navSettings),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: navigationShell),
              ],
            ),
          );
        }

        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: NavigationBar(
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: navigationShell.goBranch,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.list_alt),
                selectedIcon: const Icon(Icons.list_alt_rounded),
                label: context.l10n.navWatchlist,
              ),
              NavigationDestination(
                icon: const Icon(Icons.explore_outlined),
                selectedIcon: const Icon(Icons.explore),
                label: context.l10n.navExplore,
              ),
              NavigationDestination(
                icon: const Icon(Icons.calendar_today_outlined),
                selectedIcon: const Icon(Icons.calendar_today),
                label: context.l10n.navSchedule,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings_outlined),
                selectedIcon: const Icon(Icons.settings),
                label: context.l10n.navSettings,
              ),
            ],
          ),
        );
      },
    );
  }
}
