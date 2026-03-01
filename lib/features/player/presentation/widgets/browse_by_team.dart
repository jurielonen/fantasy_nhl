import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/team_chip.dart';
import '../providers/explore_providers.dart';

class BrowseByTeam extends ConsumerWidget {
  final void Function(String teamAbbrev)? onTeamTap;

  const BrowseByTeam({super.key, this.onTeamTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final teams = ref.watch(teamListProvider).value ?? AppConstants.teamCodes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: context.l10n.exploreBrowseByTeam),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return TeamChip(
                abbreviation: team.abbrev,
                logoUrl: team.logoUrl(brightness),
                onTap: () => onTeamTap?.call(team.abbrev),
              );
            },
          ),
        ),
      ],
    );
  }
}
