import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/extensions.dart';

class TeamChip extends StatelessWidget {
  final String abbreviation;
  final String? logoUrl;
  final bool selected;
  final VoidCallback? onTap;

  const TeamChip({
    super.key,
    required this.abbreviation,
    this.logoUrl,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: selected
              ? colors.accent.withValues(alpha: 0.15)
              : colors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? colors.accent : colors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (logoUrl != null) ...[
              SvgPicture.network(
                logoUrl!,
                width: 24,
                height: 24,
                placeholderBuilder: (_) =>
                    const SizedBox(width: 24, height: 24),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              abbreviation,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? colors.accent : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
