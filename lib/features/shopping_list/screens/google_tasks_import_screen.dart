import 'package:flutter/material.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../services/google_tasks_import_service.dart';
import 'task_import_screen.dart';

// ---------------------------------------------------------------------------
// Google Tasks Import Screen (Android)
// Thin wrapper around TaskImportScreen that injects the Google Tasks fetcher
// und die Post-Import-Aktion (Complete / Complete+Delete via Tasks API).
// ---------------------------------------------------------------------------

class GoogleTasksImportScreen extends StatelessWidget {
  const GoogleTasksImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return TaskImportScreen(
      title: l.importGoogleTasks,
      fetcher: GoogleTasksImportService.fetchTaskLists,
      emptyHint: l.noTaskLists,
      onPostAction: (action, items) async {
        switch (action) {
          case TaskImportPostAction.leave:
            return;
          case TaskImportPostAction.complete:
            await GoogleTasksImportService.complete(items);
            break;
          case TaskImportPostAction.completeAndDelete:
            await GoogleTasksImportService.complete(items);
            await GoogleTasksImportService.delete(items);
            break;
        }
      },
    );
  }
}
