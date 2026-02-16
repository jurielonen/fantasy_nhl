import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/extensions.dart';
import '../providers/schedule_providers.dart';

class DateSelector extends ConsumerWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(selectedDateProvider);
    final now = DateTime.now();
    final isToday =
        date.year == now.year && date.month == now.month && date.day == now.day;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () =>
                ref.read(selectedDateProvider.notifier).previousDay(),
            tooltip: context.l10n.schedulePreviousDay,
          ),
          Expanded(
            child: Center(
              child: Text(
                _formatDisplay(context, date, isToday),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => ref.read(selectedDateProvider.notifier).nextDay(),
            tooltip: context.l10n.scheduleNextDay,
          ),
          if (!isToday)
            TextButton(
              onPressed: () => ref.read(selectedDateProvider.notifier).today(),
              child: Text(context.l10n.commonToday),
            ),
        ],
      ),
    );
  }

  String _formatDisplay(BuildContext context, DateTime date, bool isToday) {
    if (isToday) return context.l10n.commonToday;
    return context.l10n.scheduleDateDisplay(date);
  }
}
