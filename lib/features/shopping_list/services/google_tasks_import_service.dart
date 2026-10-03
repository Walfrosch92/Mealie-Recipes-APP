import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:http/http.dart' as http;

import 'task_import_models.dart';

// Re-export so existing imports keep working.
export 'task_import_models.dart';

// ---------------------------------------------------------------------------
// Google Tasks Import — Android task-import implementation.
// ---------------------------------------------------------------------------

// Backwards-compat aliases — keep external imports working after the rename
// to ImportTaskList/ImportTaskItem in task_import_models.dart.
typedef GoogleTaskItem = ImportTaskItem;
typedef GoogleTaskList = ImportTaskList;

class GoogleTasksImportService {
  // Schreibender Scope statt readonly — wir wollen importierte Tasks
  // anschließend abhaken (PATCH status=completed) und ggf. löschen
  // (DELETE /tasks/{id}). Der User bekommt einmalig den Consent für
  // Read/Write angezeigt; danach klappt fetchLists/complete/delete ohne
  // weitere Prompts.
  static final _googleSignIn = GoogleSignIn(
    scopes: [tasks.TasksApi.tasksScope],
  );

  static Future<List<ImportTaskList>> fetchTaskLists() async {
    final account = await _googleSignIn.signIn();
    if (account == null) return [];

    final authHeaders = await account.authHeaders;
    final client = _AuthenticatedClient(http.Client(), authHeaders);
    final tasksApi = tasks.TasksApi(client);

    try {
      final taskListsResult = await tasksApi.tasklists.list();
      final lists = <ImportTaskList>[];

      for (final list in taskListsResult.items ?? []) {
        if (list.id == null || list.title == null) continue;
        final tasksResult = await tasksApi.tasks.list(list.id!);
        final items = (tasksResult.items ?? [])
            .where((t) => t.title?.isNotEmpty == true)
            .map((t) => ImportTaskItem(
                  id: t.id ?? '',
                  title: t.title!,
                  completed: t.status == 'completed',
                  // containerId = Task-List-ID — brauchen wir später für
                  // patch/delete um die richtige Liste zu adressieren.
                  containerId: list.id!,
                ))
            .toList();

        lists.add(ImportTaskList(
          id: list.id!,
          title: list.title!,
          items: items,
        ));
      }

      return lists;
    } finally {
      client.close();
    }
  }

  /// Markiert die genannten Tasks als erledigt. `items` liefert pro Task die
  /// containerId (Task-List-ID) damit der API-Call die richtige Liste
  /// adressiert — eine flache Liste von IDs wäre für die Google Tasks API
  /// nicht ausreichend.
  static Future<void> complete(List<ImportTaskItem> items) async {
    if (items.isEmpty) return;
    await _modifyTasks(items, _CompleteOp());
  }

  /// Löscht die genannten Tasks aus der Quell-Liste.
  static Future<void> delete(List<ImportTaskItem> items) async {
    if (items.isEmpty) return;
    await _modifyTasks(items, _DeleteOp());
  }

  static Future<void> _modifyTasks(
      List<ImportTaskItem> items, _TaskOp op) async {
    final account =
        await _googleSignIn.signInSilently() ?? await _googleSignIn.signIn();
    if (account == null) return;
    final authHeaders = await account.authHeaders;
    final client = _AuthenticatedClient(http.Client(), authHeaders);
    final tasksApi = tasks.TasksApi(client);
    try {
      for (final item in items) {
        final taskListId = item.containerId;
        if (taskListId == null || taskListId.isEmpty || item.id.isEmpty) {
          continue;
        }
        await op.apply(tasksApi, taskListId, item.id);
      }
    } finally {
      client.close();
    }
  }

  static Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

abstract class _TaskOp {
  Future<void> apply(tasks.TasksApi api, String listId, String taskId);
}

class _CompleteOp implements _TaskOp {
  @override
  Future<void> apply(tasks.TasksApi api, String listId, String taskId) async {
    // PATCH /tasks/{id} status=completed; die Google Tasks API setzt
    // dabei automatisch das `completed`-Timestamp-Feld.
    await api.tasks.patch(
      tasks.Task()..status = 'completed',
      listId,
      taskId,
    );
  }
}

class _DeleteOp implements _TaskOp {
  @override
  Future<void> apply(tasks.TasksApi api, String listId, String taskId) async {
    await api.tasks.delete(listId, taskId);
  }
}

/// HTTP client that adds Google auth headers to every request
class _AuthenticatedClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  _AuthenticatedClient(this._inner, this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
