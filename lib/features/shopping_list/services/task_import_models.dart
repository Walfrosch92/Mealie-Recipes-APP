// Shared models for the platform-specific task-import flows
// (Google Tasks on Android, Apple Reminders on iOS).

class ImportTaskItem {
  final String id;
  final String title;
  final bool completed;

  /// Plattform-spezifischer „Listen-Container"-Schlüssel: bei Google Tasks
  /// ist das die Task-List-ID (gebraucht für PATCH/DELETE), bei Apple
  /// Reminders die Kalender-(Listen-)ID. Wird vom Service beim Bauen der
  /// Liste mitgegeben damit die spätere complete/delete-Operation den
  /// richtigen Container adressiert.
  final String? containerId;

  const ImportTaskItem({
    required this.id,
    required this.title,
    this.completed = false,
    this.containerId,
  });
}

class ImportTaskList {
  final String id;
  final String title;
  final List<ImportTaskItem> items;

  const ImportTaskList({
    required this.id,
    required this.title,
    this.items = const [],
  });
}

// ---------------------------------------------------------------------------
// 1:1 port of Swift `PostAction` (ReminderImportView.swift). Was der User
// nach dem Import in der Quell-App (Reminders / Google Tasks) machen will:
//   - leave             — nichts anrühren, nur in Mealie hinzufügen
//   - complete          — die importierten Einträge dort abhaken
//   - completeAndDelete — abhaken UND löschen
// ---------------------------------------------------------------------------

enum TaskImportPostAction { leave, complete, completeAndDelete }
