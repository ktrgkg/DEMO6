import "package:flutter/material.dart";

void showErrorSnackBar(BuildContext context, String message) {
  _showSnackBar(
    context,
    message,
    backgroundColor: Theme.of(context).colorScheme.error,
    foregroundColor: Theme.of(context).colorScheme.onError,
  );
}

void showSuccessSnackBar(BuildContext context, String message) {
  _showSnackBar(
    context,
    message,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
  );
}

void _showSnackBar(
  BuildContext context,
  String message, {
  required Color backgroundColor,
  required Color foregroundColor,
}) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message, style: TextStyle(color: foregroundColor)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
    ),
  );
}
