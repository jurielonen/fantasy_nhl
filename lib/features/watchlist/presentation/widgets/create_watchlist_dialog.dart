import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class CreateWatchlistDialog extends StatefulWidget {
  const CreateWatchlistDialog({super.key});

  @override
  State<CreateWatchlistDialog> createState() => _CreateWatchlistDialogState();
}

class _CreateWatchlistDialogState extends State<CreateWatchlistDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Watchlist'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Watchlist name',
          filled: true,
          fillColor: AppColors.surfaceVariant,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('Create'),
        ),
      ],
    );
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) {
      Navigator.pop(context, name);
    }
  }
}
