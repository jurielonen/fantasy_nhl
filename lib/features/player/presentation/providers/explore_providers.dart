import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/stat_leader.dart';
import '../../providers.dart';

part 'explore_providers.g.dart';

// ── Search ──────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void set(String query) => state = query;
}

@riverpod
Future<List<Player>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  // Debounce
  await Future<void>.delayed(
    const Duration(milliseconds: AppConstants.searchDebounceMs),
  );

  return ref.read(playerRepositoryProvider).searchPlayers(query.trim());
}

// ── Spotlight ───────────────────────────────────────────────────────────────

@riverpod
Future<List<Player>> spotlightPlayers(Ref ref) {
  return ref.read(playerRepositoryProvider).getSpotlightPlayers();
}

// ── Stat Leaders ────────────────────────────────────────────────────────────

const skaterCategories = [
  ('goals', 'Goals'),
  ('assists', 'Assists'),
  ('points', 'Points'),
  ('plusMinus', '+/-'),
  ('penaltyMinutes', 'PIM'),
  ('toi', 'TOI'),
];

const goalieCategories = [
  ('wins', 'Wins'),
  ('gaa', 'GAA'),
  ('savePctg', 'SV%'),
  ('shutouts', 'SO'),
];

@Riverpod(keepAlive: true)
class SelectedSkaterCategory extends _$SelectedSkaterCategory {
  @override
  String build() => 'goals';

  void select(String category) => state = category;
}

@Riverpod(keepAlive: true)
class SelectedGoalieCategory extends _$SelectedGoalieCategory {
  @override
  String build() => 'wins';

  void select(String category) => state = category;
}

@riverpod
Future<List<StatLeader>> skaterLeaders(Ref ref, String category) {
  return ref
      .read(playerRepositoryProvider)
      .getSkaterLeaders(category, limit: 5);
}

@riverpod
Future<List<StatLeader>> goalieLeaders(Ref ref, String category) {
  return ref
      .read(playerRepositoryProvider)
      .getGoalieLeaders(category, limit: 5);
}

@riverpod
class ShowAllSkaterLeaders extends _$ShowAllSkaterLeaders {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

@riverpod
class ShowAllGoalieLeaders extends _$ShowAllGoalieLeaders {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

// ── Browse by Team ──────────────────────────────────────────────────────────

@riverpod
Future<List<Player>> teamRoster(Ref ref, String teamAbbrev) {
  return ref.read(playerRepositoryProvider).getTeamRoster(teamAbbrev);
}
