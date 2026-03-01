import 'package:flutter/material.dart';

import '../../../../core/utils/extensions.dart';

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
      title: Text(context.l10n.watchlistNewTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        style: TextStyle(color: context.appColors.textPrimary),
        decoration: InputDecoration(
          hintText: context.l10n.watchlistNameHint,
          filled: true,
          fillColor: context.appColors.surfaceVariant,
        ),
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonCancel),
        ),
        TextButton(onPressed: _submit, child: Text(context.l10n.commonCreate)),
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
