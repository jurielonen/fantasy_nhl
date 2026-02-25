import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/shimmer_loader.dart';
import '../../../../shared/widgets/stat_leader_row.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/stat_leader.dart';
import '../providers/explore_providers.dart';

Player _playerFromLeader(StatLeader l) => Player(
      id: l.playerId,
      firstName: l.firstName,
      lastName: l.lastName,
      teamAbbrev: l.teamAbbrev,
      position: l.position ?? '',
      headshot: l.headshot,
    );

class StatLeadersSection extends ConsumerWidget {
  final void Function(Player)? onPlayerTap;

  const StatLeadersSection({super.key, this.onPlayerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkaterLeaders(onPlayerTap: onPlayerTap),
        const SizedBox(height: 8),
        _GoalieLeaders(onPlayerTap: onPlayerTap),
      ],
    );
  }
}

class _SkaterLeaders extends ConsumerWidget {
  final void Function(Player)? onPlayerTap;

  const _SkaterLeaders({this.onPlayerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedSkaterCategoryProvider);
    final leadersAsync = ref.watch(skaterLeadersProvider(selectedCategory));
    final showAll = ref.watch(showAllSkaterLeadersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.exploreSkaterLeaders,
          actionText: showAll ? context.l10n.exploreShowLess : context.l10n.exploreSeeAll,
          onAction: () =>
              ref.read(showAllSkaterLeadersProvider.notifier).toggle(),
        ),
        _CategoryTabs(
          categories: skaterCategories,
          selected: selectedCategory,
          onSelected: (cat) =>
              ref.read(selectedSkaterCategoryProvider.notifier).select(cat),
        ),
        const SizedBox(height: 4),
        leadersAsync.when(
          data: (leaders) {
            final visible = showAll ? leaders : leaders.take(5).toList();
            return Column(
              children: [
                for (var i = 0; i < visible.length; i++)
                  StatLeaderRow(
                    rank: i + 1,
                    leader: visible[i],
                    onTap: () => onPlayerTap?.call(_playerFromLeader(visible[i])),
                  ),
              ],
            );
          },
          loading: () => Column(
            children: List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ShimmerLoader(height: 36),
              ),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(context.l10n.exploreFailedToLoad(error.toString())),
          ),
        ),
      ],
    );
  }
}

class _GoalieLeaders extends ConsumerWidget {
  final void Function(Player)? onPlayerTap;

  const _GoalieLeaders({this.onPlayerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedGoalieCategoryProvider);
    final leadersAsync = ref.watch(goalieLeadersProvider(selectedCategory));
    final showAll = ref.watch(showAllGoalieLeadersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: context.l10n.exploreGoalieLeaders,
          actionText: showAll ? context.l10n.exploreShowLess : context.l10n.exploreSeeAll,
          onAction: () =>
              ref.read(showAllGoalieLeadersProvider.notifier).toggle(),
        ),
        _CategoryTabs(
          categories: goalieCategories,
          selected: selectedCategory,
          onSelected: (cat) =>
              ref.read(selectedGoalieCategoryProvider.notifier).select(cat),
        ),
        const SizedBox(height: 4),
        leadersAsync.when(
          data: (leaders) {
            final visible = showAll ? leaders : leaders.take(5).toList();
            return Column(
              children: [
                for (var i = 0; i < visible.length; i++)
                  StatLeaderRow(
                    rank: i + 1,
                    leader: visible[i],
                    onTap: () => onPlayerTap?.call(_playerFromLeader(visible[i])),
                  ),
              ],
            );
          },
          loading: () => Column(
            children: List.generate(
              5,
              (index) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ShimmerLoader(height: 36),
              ),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(context.l10n.exploreFailedToLoad(error.toString())),
          ),
        ),
      ],
    );
  }
}

class _CategoryTabs extends StatelessWidget {
  final List<(String, String)> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const _CategoryTabs({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (key, label) = categories[index];
          final isSelected = key == selected;
          return GestureDetector(
            onTap: () => onSelected(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      isSelected ? AppColors.accent : AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
