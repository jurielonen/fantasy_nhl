import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/schedule_game.dart';
import '../../providers.dart';

// ── Selected date ────────────────────────────────────────────────────────────

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void selectDate(DateTime date) => state = date;

  void nextDay() => state = state.add(const Duration(days: 1));

  void previousDay() => state = state.subtract(const Duration(days: 1));

  void today() => state = DateTime.now();
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  SelectedDateNotifier.new,
);

// ── Format helper ────────────────────────────────────────────────────────────

String _formatDate(DateTime dt) =>
    '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

// ── Schedule games for selected date ─────────────────────────────────────────

final scheduleDateGamesProvider = FutureProvider<List<ScheduleGame>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final formatted = _formatDate(date);
  return ref.read(scheduleRepositoryProvider).getScheduleByDate(formatted);
});

// ── Scores for selected date ─────────────────────────────────────────────────

final scheduleDateScoresProvider = FutureProvider<List<ScheduleGame>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final formatted = _formatDate(date);
  return ref.read(scheduleRepositoryProvider).getScoresByDate(formatted);
});

// ── Merged games with scores ─────────────────────────────────────────────────

final scheduleGamesWithScoresProvider =
    FutureProvider<List<ScheduleGame>>((ref) async {
  final games = await ref.watch(scheduleDateGamesProvider.future);
  final scores = await ref
      .watch(scheduleDateScoresProvider.future)
      .catchError((_) => <ScheduleGame>[]);

  final scoreMap = {for (final s in scores) s.gameId: s};

  return games.map((g) => scoreMap[g.gameId] ?? g).toList();
});
