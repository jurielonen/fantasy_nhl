import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../domain/entities/game_day.dart';
import '../providers/schedule_providers.dart';

class DateSelector extends ConsumerStatefulWidget {
  const DateSelector({super.key});

  @override
  ConsumerState<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends ConsumerState<DateSelector> {
  final _scrollController = ScrollController();
  bool _hasScrolledToSelected = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameDayAsync = ref.watch(gameDayProvider);
    // During reloads, .value holds the previous GameDay — use it to avoid
    // shimmer when switching days; weekDays structure is stable within a week.
    final gameDay = gameDayAsync.value;
    if (gameDay != null) return _buildDaySelector(context, gameDay);
    // First load only — no previous data available yet.
    return gameDayAsync.when(
      loading: () => _buildShimmer(),
      error: (_, _) => const SizedBox(height: 72),
      data: (gd) => _buildDaySelector(context, gd),
    );
  }

  Widget _buildShimmer() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ShimmerLoader(height: 56),
    );
  }

  Widget _buildDaySelector(BuildContext context, GameDay gameDay) {
    final weekDays = gameDay.weekDays;
    final selectedDate = ref.watch(selectedDateProvider);
    final currentDate = selectedDate ?? gameDay.currentDate;

    // Auto-scroll to selected day after build
    if (!_hasScrolledToSelected && weekDays.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected(weekDays, currentDate);
      });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 72,
          child: Row(
            children: [
              // Previous week arrow
              if (gameDay.prevDate != null)
                _NavArrow(
                  icon: Icons.chevron_left,
                  tooltip: context.l10n.schedulePreviousWeek,
                  onTap: () => ref
                      .read(selectedDateProvider.notifier)
                      .select(gameDay.prevDate),
                ),
              // Day chips
              Expanded(
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  itemCount: weekDays.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 6),
                  itemBuilder: (context, index) {
                    final day = weekDays[index];
                    final isSelected = day.date == currentDate;
                    return _DayChip(
                      day: day,
                      isSelected: isSelected,
                      onTap: () {
                        ref
                            .read(selectedDateProvider.notifier)
                            .select(day.date);
                        _hasScrolledToSelected = false;
                      },
                    );
                  },
                ),
              ),
              // Next week arrow
              if (gameDay.nextDate != null)
                _NavArrow(
                  icon: Icons.chevron_right,
                  tooltip: context.l10n.scheduleNextWeek,
                  onTap: () => ref
                      .read(selectedDateProvider.notifier)
                      .select(gameDay.nextDate),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollToSelected(List<GameWeekDay> weekDays, DateTime currentDate) {
    final index = weekDays.indexWhere((d) => d.date == currentDate);
    if (index < 0 || !_scrollController.hasClients) return;

    // Estimate chip width (~64) + spacing (6)
    const chipWidth = 70.0;
    final viewportWidth = _scrollController.position.viewportDimension;
    final targetOffset =
        (index * chipWidth) - (viewportWidth / 2) + (chipWidth / 2);
    final clampedOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      clampedOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _hasScrolledToSelected = true;
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _DayChip extends StatelessWidget {
  final GameWeekDay day;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayChip({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final dateStr = _formatShortDate(day.date, context.localeName);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.accent : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                day.dayAbbrev,
                style: context.tsChipLabel.copyWith(
                  color: isSelected ? colors.background : colors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dateStr,
                style: context.tsLabelMedium.copyWith(
                  color: isSelected ? colors.background : colors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              if (day.numberOfGames > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.background.withValues(alpha: 0.2)
                        : colors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${day.numberOfGames}',
                    style: context.tsBadgeLabel.copyWith(
                      color: isSelected ? colors.background : colors.accent,
                    ),
                  ),
                )
              else
                const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date, String locale) =>
      DateFormat.MMMd(locale).format(date);
}
