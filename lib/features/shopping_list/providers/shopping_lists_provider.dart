import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import 'shopping_list_provider.dart';

// ---------------------------------------------------------------------------
// Alle Einkaufslisten des Haushalts (Mealie ShoppingListSummary, roh als Map
// inkl. `labelSettings`). Cache-first wie überall: letzter Stand sofort, im
// Hintergrund frisch vom Server.
//
// Genutzt von der Listenwahl (⋮-Menü der Einkaufsliste) und der Verwaltung
// (Home-Kachel „Einkaufslisten").
// ---------------------------------------------------------------------------

final shoppingListsProvider =
    AsyncNotifierProvider<ShoppingListsNotifier, List<Map<String, dynamic>>>(
        ShoppingListsNotifier.new);

String shoppingListName(Map<String, dynamic> m) =>
    (m['name'] as String?)?.trim() ?? '';

/// `labelSettings` einer Liste nach Position sortiert.
List<Map<String, dynamic>> sortedLabelSettings(Map<String, dynamic> list) {
  final raw = (list['labelSettings'] as List?) ?? const [];
  final settings = raw
      .whereType<Map>()
      .map((e) => Map<String, dynamic>.from(e))
      .toList()
    ..sort((a, b) =>
        ((a['position'] as num?) ?? 0).compareTo((b['position'] as num?) ?? 0));
  return settings;
}

/// Abteilungsnamen einer Liste in ihrer Server-Reihenfolge — dasselbe Format
/// wie `AppSettings.shoppingCategoryOrder` (Anzeigereihenfolge der App).
/// labelSettings in die Reihenfolge der Kategorie-Namen [names] bringen;
/// Abteilungen, die dort nicht vorkommen (z. B. gerade leer), behalten ihre
/// relative Reihenfolge dahinter.
List<Map<String, dynamic>> orderLabelSettingsByNames(
    List<Map<String, dynamic>> settings, List<String> names) {
  String nameOf(Map<String, dynamic> s) =>
      (s['label'] is Map ? (s['label'] as Map)['name'] as String? : null) ?? '';
  return [
    for (final n in names) ...settings.where((s) => nameOf(s) == n),
    ...settings.where((s) => !names.contains(nameOf(s))),
  ];
}

List<String> labelOrderNames(Map<String, dynamic> list) => [
      for (final s in sortedLabelSettings(list))
        if (s['label'] is Map &&
            ((s['label'] as Map)['name'] as String?) != null)
          (s['label'] as Map)['name'] as String,
    ];

/// Titel mit Listennamen: „🛒 Einkaufsliste" + „Liste 1" → „🛒 Liste 1".
/// Führendes Emoji bleibt, ohne Namen bleibt der Titel unverändert.
String shoppingTitleWithName(String base, String? name) {
  if (name == null || name.trim().isEmpty) return base;
  final m = RegExp(r'^(\S+\s+)').firstMatch(base);
  final prefix = m != null && !RegExp(r'[A-Za-zÀ-ž]').hasMatch(m.group(1)!)
      ? m.group(1)!
      : '';
  return '$prefix${name.trim()}';
}

/// Name der aktiven Einkaufsliste (für Titelleiste und Kachel), `null`
/// solange unbekannt → Aufrufer zeigt dann das generische „Einkaufsliste".
final activeShoppingListNameProvider = Provider<String?>((ref) {
  final id = ref.watch(
      settingsProvider.select((a) => a.valueOrNull?.shoppingListId ?? ''));
  if (id.isEmpty) return null;
  for (final m in ref.watch(shoppingListsProvider).valueOrNull ?? const []) {
    if (m['id'] == id) {
      final n = shoppingListName(m);
      return n.isEmpty ? null : n;
    }
  }
  return null;
});

class ShoppingListsNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  static const _key = 'shopping_lists';

  @override
  Future<List<Map<String, dynamic>>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadJsonList(_key);
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await _fetch(api));
        } catch (_) {/* Cache behalten */}
      });
      return _sorted(cached);
    }
    return _fetch(api);
  }

  Future<List<Map<String, dynamic>>> _fetch(ApiService api) async {
    final lists = _sorted(await api.fetchShoppingLists());
    await LocalCache.saveJsonList(_key, lists);
    return lists;
  }

  List<Map<String, dynamic>> _sorted(List<Map<String, dynamic>> l) =>
      [...l]..sort((a, b) => shoppingListName(a)
          .toLowerCase()
          .compareTo(shoppingListName(b).toLowerCase()));

  Future<void> refresh() async {
    try {
      state = AsyncData(await _fetch(ref.read(apiServiceProvider)));
    } catch (_) {/* Stand behalten */}
  }

  List<Map<String, dynamic>> get _current => state.valueOrNull ?? const [];

  Future<void> _store(List<Map<String, dynamic>> lists) async {
    final sorted = _sorted(lists);
    state = AsyncData(sorted);
    await LocalCache.saveJsonList(_key, sorted);
  }

  Future<Map<String, dynamic>> create(String name) async {
    final created = await ref.read(apiServiceProvider).createShoppingList(name);
    await _store([..._current, created]);
    return created;
  }

  Future<void> rename(String id, String name) async {
    final updated =
        await ref.read(apiServiceProvider).renameShoppingList(id, name);
    // Die Antwort enthält auch listItems — für die Übersicht nicht nötig.
    updated.remove('listItems');
    await _store([for (final m in _current) m['id'] == id ? updated : m]);
  }

  /// Löscht die Liste. War sie die aktive, wird auf die erste verbleibende
  /// gewechselt (oder keine).
  Future<void> delete(String id) async {
    await ref.read(apiServiceProvider).deleteShoppingList(id);
    final rest = _current.where((m) => m['id'] != id).toList();
    await _store(rest);
    final s = ref.read(settingsProvider).valueOrNull;
    if (s != null && s.shoppingListId == id) {
      await select(rest.isEmpty ? null : rest.first);
    }
  }

  /// Neue Abteilungs-Reihenfolge ([settings] = geordnete labelSettings).
  /// Ist es die aktive Liste, übernimmt die Anzeige sie sofort.
  Future<void> saveLabelOrder(
      String listId, List<Map<String, dynamic>> settings) async {
    final updated = await ref
        .read(apiServiceProvider)
        .updateShoppingListLabelOrder(listId, settings);
    updated.remove('listItems');
    await _store([for (final m in _current) m['id'] == listId ? updated : m]);
    final s = ref.read(settingsProvider).valueOrNull;
    if (s != null && s.shoppingListId == listId) {
      await ref
          .read(settingsProvider.notifier)
          .save(s.copyWith(shoppingCategoryOrder: labelOrderNames(updated)));
    }
  }

  /// Aktive Einkaufsliste wechseln — wie die Auswahl in den Einstellungen,
  /// zusätzlich mit der Abteilungs-Reihenfolge dieser Liste (Mealie
  /// speichert sie pro Liste). [list] null = keine Liste.
  Future<void> select(Map<String, dynamic>? list) => _select(ref, list);

  /// Nach dem Ziehen einer Kategorie in der Einkaufsliste: dieselbe
  /// Reihenfolge (Namen) auch in Mealie für die aktive Liste speichern
  /// (Webapp zeigt sie dann genauso). Liest dafür IMMER den aktuellen
  /// Server-Stand der Liste — vorher wurde nur synchronisiert, wenn die
  /// Listenübersicht zufällig schon geladen war (still kein Sync beim
  /// direkten Öffnen der Einkaufsliste). Offline: nur lokal, kein Fehler.
  Future<void> pushOrderByNames(String listId, List<String> names) async {
    if (listId.isEmpty) return;
    final api = ref.read(apiServiceProvider);
    try {
      final list = await api.fetchShoppingList(listId);
      final settings = sortedLabelSettings(list);
      if (settings.isEmpty) return;
      final ordered = orderLabelSettingsByNames(settings, names);
      final updated = await api.updateShoppingListLabelOrder(listId, ordered);
      updated.remove('listItems');
      if (_current.any((m) => m['id'] == listId)) {
        await _store(
            [for (final m in _current) m['id'] == listId ? updated : m]);
      }
      LogManager.shared.log('🏷️ Kategorie-Reihenfolge an Mealie übertragen');
    } catch (e) {
      LogManager.shared
          .log('⚠️ Kategorie-Reihenfolge nicht übertragen (offline?): $e');
    }
  }
}

Future<void> _select(Ref ref, Map<String, dynamic>? list) async {
  final s = ref.read(settingsProvider).valueOrNull ?? const AppSettings();
  final id = (list?['id'] as String?) ?? '';
  if (id == s.shoppingListId) return;
  final order = list == null ? const <String>[] : labelOrderNames(list);
  await ref.read(settingsProvider.notifier).save(s.copyWith(
        shoppingListId: id,
        shoppingCategoryOrder: order.isEmpty ? null : order,
      ));
  ref.invalidate(shoppingListProvider);
  ref.invalidate(shoppingLabelsProvider);
  ref.read(shoppingListProvider);
  ref.read(shoppingLabelsProvider);
}
