import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/player_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../providers/explore_providers.dart';

class SpotlightCarousel extends ConsumerWidget {
  final void Function(int playerId)? onPlayerTap;

  const SpotlightCarousel({super.key, this.onPlayerTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spotlightAsync = ref.watch(spotlightPlayersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Player Spotlight'),
        SizedBox(
          height: 200,
          child: spotlightAsync.when(
            data: (players) {
              if (players.isEmpty) {
                return const Center(
                  child: Text('No spotlight players available'),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: players.length,
                itemBuilder: (context, index) {
                  final player = players[index];
                  return PlayerCard(
                    player: player,
                    onTap: () => onPlayerTap?.call(player.id),
                  );
                },
              );
            },
            loading: () => ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) => const ShimmerPlayerCard(),
            ),
            error: (error, stack) => Center(
              child: Text('Failed to load spotlight: $error'),
            ),
          ),
        ),
      ],
    );
  }
}
