import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/player_detail.dart';

class PlayerDetailHeader extends StatelessWidget {
  final Player player;
  final PlayerBio bio;

  const PlayerDetailHeader({
    super.key,
    required this.player,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        // Headshot + Name row
        Row(
          children: [
            const SizedBox(width: 16),
            Hero(
              tag: 'player_${player.id}',
              child: _Headshot(url: player.headshot, fallback: player.firstName),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(player.fullName, style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (player.sweaterNumber != null)
                        Text(
                          '#${player.sweaterNumber}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      if (player.sweaterNumber != null)
                        const SizedBox(width: 8),
                      _PositionBadge(player.position),
                      const SizedBox(width: 8),
                      if (player.teamAbbrev != null)
                        _TeamBadge(player.teamAbbrev!),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
        const SizedBox(height: 16),
        // Bio row
        _BioRow(bio: bio),
        // Draft info
        if (bio.draftInfo != null) ...[
          const SizedBox(height: 8),
          _DraftInfoRow(draft: bio.draftInfo!),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}

class _Headshot extends StatelessWidget {
  final String? url;
  final String fallback;

  const _Headshot({this.url, required this.fallback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.accent, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: url != null && url!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (_, _) => const Icon(
                Icons.person,
                size: 40,
                color: AppColors.textTertiary,
              ),
              errorWidget: (_, _, _) => const Icon(
                Icons.person,
                size: 40,
                color: AppColors.textTertiary,
              ),
            )
          : Center(
              child: Text(
                fallback.isNotEmpty ? fallback[0] : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
    );
  }
}

class _PositionBadge extends StatelessWidget {
  final String position;
  const _PositionBadge(this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        position,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

class _TeamBadge extends StatelessWidget {
  final String abbrev;
  const _TeamBadge(this.abbrev);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        abbrev,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _BioRow extends StatelessWidget {
  final PlayerBio bio;
  const _BioRow({required this.bio});

  @override
  Widget build(BuildContext context) {
    final items = <String>[];

    if (bio.birthDate != null) {
      final age = _calculateAge(bio.birthDate!);
      if (age != null) items.add('Age $age');
    }
    if (bio.heightInInches != null) {
      items.add(_formatHeight(bio.heightInInches!));
    }
    if (bio.weightInPounds != null) {
      items.add('${bio.weightInPounds} lbs');
    }
    if (bio.shootsCatches != null) {
      items.add(bio.shootsCatches == 'L' ? 'Left' : 'Right');
    }
    if (bio.birthCity != null) {
      final location = [bio.birthCity, bio.birthCountry]
          .where((s) => s != null)
          .join(', ');
      items.add(location);
    }

    if (items.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 16,
        runSpacing: 4,
        children: items
            .map((item) => Text(item, style: AppTextStyles.bodyMedium))
            .toList(),
      ),
    );
  }

  int? _calculateAge(String birthDate) {
    try {
      final date = DateTime.parse(birthDate);
      final now = DateTime.now();
      var age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return null;
    }
  }

  String _formatHeight(int inches) {
    final feet = inches ~/ 12;
    final remainder = inches % 12;
    return "$feet'$remainder\"";
  }
}

class _DraftInfoRow extends StatelessWidget {
  final DraftInfo draft;
  const _DraftInfoRow({required this.draft});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      'Round ${draft.round}',
      'Pick ${draft.pickInRound}',
      '(#${draft.overallPick} overall)',
      '${draft.year}',
    ];
    if (draft.teamAbbrev != null) {
      parts.add('by ${draft.teamAbbrev}');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.sports_hockey, size: 14, color: AppColors.textTertiary),
          const SizedBox(width: 6),
          Text(
            'Draft: ${parts.join(' · ')}',
            style: AppTextStyles.labelSmall,
          ),
        ],
      ),
    );
  }
}
