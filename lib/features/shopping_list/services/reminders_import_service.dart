import 'package:flutter/services.dart';

import 'task_import_models.dart';

// ---------------------------------------------------------------------------
// Apple Reminders Import — iOS task-import implementation.
//
// Talks to the native Swift RemindersPlugin via MethodChannel.
// EventKit-based; mirrors the iOS RemindersImportFlowView from the original
// Swift app.
// ---------------------------------------------------------------------------

class RemindersImportService {
  static const _channel = MethodChannel('mealie_recipes/reminders');

  /// Fetches all reminder lists with their incomplete items.
  /// Throws if the user denies Reminders access.
  static Future<List<ImportTaskList>> fetchLists() async {
    final raw = await _channel.invokeMethod<List<Object?>>('fetchLists');
    if (raw == null) return [];
    return raw
        .whereType<Map<Object?, Object?>>()
        .map((m) => ImportTaskList(
              id: (m['id'] as String?) ?? '',
              title: (m['title'] as String?) ?? '',
              items: (m['items'] as List<Object?>? ?? [])
                  .whereType<Map<Object?, Object?>>()
                  .map((it) => ImportTaskItem(
                        id: (it['id'] as String?) ?? '',
                        title: (it['title'] as String?) ?? '',
                        completed: (it['completed'] as bool?) ?? false,
                      ))
                  .toList(),
            ))
        .toList();
  }

  /// Markiert die genannten Reminder als erledigt. Spiegelt Swifts
  /// RemindersImporter.complete(reminderIds:).
  static Future<void> complete(List<String> ids) async {
    if (ids.isEmpty) return;
    await _channel.invokeMethod<void>('complete', {'ids': ids});
  }

  /// Löscht die genannten Reminder. Spiegelt Swifts
  /// RemindersImporter.remove(reminderIds:).
  static Future<void> delete(List<String> ids) async {
    if (ids.isEmpty) return;
    await _channel.invokeMethod<void>('delete', {'ids': ids});
  }
}
