import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../services/reminders_import_service.dart';
import '../services/task_import_models.dart';
import 'task_import_screen.dart';

// ---------------------------------------------------------------------------
// Apple Reminders Import Screen (iOS)
// Thin wrapper around TaskImportScreen that injects the Reminders fetcher
// und die Post-Import-Aktion (Abhaken / Abhaken+Löschen via EventKit).
// ---------------------------------------------------------------------------

class RemindersImportScreen extends StatelessWidget {
  const RemindersImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return TaskImportScreen(
      title: l.importReminders,
      fetcher: RemindersImportService.fetchLists,
      emptyHint: l.noReminderLists,
      onPostAction: (action, items) async {
        final ids = items.map((i) => i.id).toList();
        switch (action) {
          case TaskImportPostAction.leave:
            return;
          case TaskImportPostAction.complete:
            await RemindersImportService.complete(ids);
            break;
          case TaskImportPostAction.completeAndDelete:
            await RemindersImportService.complete(ids);
            await RemindersImportService.delete(ids);
            break;
        }
      },
    );
  }
}
