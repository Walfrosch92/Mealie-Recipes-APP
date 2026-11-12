import 'package:flutter/material.dart';

import '../../core/api/api_service.dart' show userErrorMessage;

// ---------------------------------------------------------------------------
// Snackbar-Helfer — ein Format für alle Screens.
//
// Fehler: der verständliche Grund vom Server bzw. der Verbindung (z. B.
// „Keine Berechtigung"), sonst der [fallback] des Aufrufers („Speichern
// fehlgeschlagen"). Nie beides aneinandergehängt, nie technischer Rohtext.
// ---------------------------------------------------------------------------

void showAppSnack(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

void showErrorSnack(BuildContext context, String fallback, Object error) =>
    showAppSnack(context, userErrorMessage(error, fallback));
