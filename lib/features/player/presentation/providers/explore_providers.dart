import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/stat_leader.dart';
import '../../providers.dart';

// ── Search ──────────────────────────────────────────────────────────────────

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void set(String query) => state = query;
}

final searchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final searchResultsProvider =
    FutureProvider.autoDispose<List<Player>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().length < 2) return [];

  // Debounce
  await Future<void>.delayed(
    const Duration(milliseconds: AppConstants.searchDebounceMs),
  );

  return ref.read(playerRepositoryProvider).searchPlayers(query.trim());
});

// ── Spotlight ───────────────────────────────────────────────────────────────

final spotlightPlayersProvider = FutureProvider<List<Player>>((ref) {
  return ref.read(playerRepositoryProvider).getSpotlightPlayers();
});

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

class SelectedSkaterCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'goals';

  void select(String category) => state = category;
}

final selectedSkaterCategoryProvider =
    NotifierProvider<SelectedSkaterCategoryNotifier, String>(
  SelectedSkaterCategoryNotifier.new,
);

class SelectedGoalieCategoryNotifier extends Notifier<String> {
  @override
  String build() => 'wins';

  void select(String category) => state = category;
}

final selectedGoalieCategoryProvider =
    NotifierProvider<SelectedGoalieCategoryNotifier, String>(
  SelectedGoalieCategoryNotifier.new,
);

final skaterLeadersProvider =
    FutureProvider.family<List<StatLeader>, String>((ref, category) {
  return ref
      .read(playerRepositoryProvider)
      .getSkaterLeaders(category, limit: 5);
});

final goalieLeadersProvider =
    FutureProvider.family<List<StatLeader>, String>((ref, category) {
  return ref
      .read(playerRepositoryProvider)
      .getGoalieLeaders(category, limit: 5);
});

class ShowAllSkaterLeadersNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final showAllSkaterLeadersProvider =
    NotifierProvider<ShowAllSkaterLeadersNotifier, bool>(
  ShowAllSkaterLeadersNotifier.new,
);

class ShowAllGoalieLeadersNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;
}

final showAllGoalieLeadersProvider =
    NotifierProvider<ShowAllGoalieLeadersNotifier, bool>(
  ShowAllGoalieLeadersNotifier.new,
);

// ── Browse by Team ──────────────────────────────────────────────────────────

final teamRosterProvider =
    FutureProvider.family<List<Player>, String>((ref, teamAbbrev) {
  return ref.read(playerRepositoryProvider).getTeamRoster(teamAbbrev);
});
