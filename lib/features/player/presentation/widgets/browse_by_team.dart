import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../../shared/widgets/team_chip.dart';

class BrowseByTeam extends StatelessWidget {
  final void Function(String teamAbbrev)? onTeamTap;

  const BrowseByTeam({super.key, this.onTeamTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Browse by Team'),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: AppConstants.teamCodes.length,
            itemBuilder: (context, index) {
              final team = AppConstants.teamCodes[index];
              return TeamChip(
                abbreviation: team,
                onTap: () => onTeamTap?.call(team),
              );
            },
          ),
        ),
      ],
    );
  }
}
