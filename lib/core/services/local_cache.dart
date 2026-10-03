import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/shopping_list/models/pending_changes.dart';
import '../models/cookbook_summary.dart';
import '../models/organizer_item.dart';
import '../models/mealplan_entry.dart';
import '../models/shopping_item.dart';

// ---------------------------------------------------------------------------
// Local offline cache — mirrors iOS ShoppingListCache.
// Stores shopping items, labels, cookbooks und Mealplan als JSON in
// SharedPreferences so they are available offline and on next launch.
//
// REZEPTE liegen NICHT hier, sondern ausschliesslich im Datei-Cache
// (`RecipeDetailCacheManager`): die komplette Bibliothek sprengt mit mehreren
// MB den Rahmen von SharedPreferences (Android lädt die beim Start komplett
// in den Speicher). Siehe `purgeLegacyRecipeCaches`.
// ---------------------------------------------------------------------------

class LocalCache {
  static const _shoppingKey = 'cache_shopping_items';
  static const _shoppingLabelsKey = 'cache_shopping_labels';
  static const _foodsCatalogKey = 'cache_foods_catalog';
  static const _unitsCatalogKey = 'cache_units_catalog';
  static const _cookbooksKey = 'cache_cookbooks';
  static const _cookbookRecipeIdsKey = 'cache_cookbook_recipe_ids';
  static const _mealplanKey = 'cache_mealplan_entries';
  static const _currentUserKey = 'cache_current_user';
  // Pending change keys — mirror Swift ShoppingListViewModel UserDefaults keys.
  static const _pendingCheckKey = 'pendingCheckChanges';
  static const _pendingQuantityKey = 'pendingQuantityChanges';
  static const _pendingDeleteKey = 'pendingDeleteChanges';
  static const _pendingAddKey = 'pendingAddChanges';
  static const _pendingCategoryKey = 'pendingCategoryChanges';
  // SendTo persistence — survive App-Neustarts.
  // Empfänger: empfangene Rezepte + Dedupe-Set für sendIds (gegen
  // Sender-Retry-Duplikate). Sender (Android-only): Outgoing-Queue für
  // Lieferungen die noch nicht zugestellt sind weil das Ziel offline war.
  static const _pendingReceivedKey = 'sendto_pending_received';
  static const _pendingOutgoingKey = 'sendto_pending_outgoing';
  static const _processedSendIdsKey = 'sendto_processed_send_ids';

  static Future<SharedPreferences> get _prefs =>
      SharedPreferences.getInstance();

  // ── Altlasten aufräumen ───────────────────────────────────────────────────
  // Bis 2026-08 lagen hier zwei Rezept-Caches: `cache_recipe_details` (die
  // KOMPLETTE Bibliothek als Detail-JSON, geschrieben vom Leftover-Finder)
  // und `cache_recipes` (Summaries, zuletzt nur noch beim Reset geleert und
  // sonst tot). Beide sind ersatzlos entfallen — der Leftover-Finder liest
  // jetzt `recipesProvider` mit, persistiert wird ausschliesslich im
  // Datei-Cache.
  //
  // Die Keys müssen aktiv gelöscht werden statt einfach ignoriert: Android
  // liest SharedPreferences beim Start KOMPLETT in den Speicher, ein
  // verwaister Mehr-MB-Blob würde also auf bestehenden Installationen bei
  // jedem App-Start mitgeschleppt. Idempotent — nach dem ersten Lauf ein
  // No-op.
  static const _legacyRecipeKeys = ['cache_recipes', 'cache_recipe_details'];

  static Future<void> purgeLegacyRecipeCaches() async {
    try {
      final prefs = await _prefs;
      for (final key in _legacyRecipeKeys) {
        if (prefs.containsKey(key)) await prefs.remove(key);
      }
    } catch (_) {}
  }

  // ── Shopping items ─────────────────────────────────────────────────────────

  static Future<void> saveShoppingItems(List<ShoppingItem> items) async {
    try {
      final prefs = await _prefs;
      final jsonList = items.map((i) => i.toJson()).toList();
      await prefs.setString(_shoppingKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<ShoppingItem>> loadShoppingItems() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_shoppingKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ShoppingItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Shopping labels (category colors) ──────────────────────────────────────
  // Persisting the label palette is what stops the shopping screen from
  // flashing the deterministic-by-name fallback colors for ~1 frame before
  // the server's real palette arrives over the network.

  static Future<void> saveShoppingLabels(List<ShoppingLabel> labels) async {
    try {
      final prefs = await _prefs;
      final jsonList = labels.map((l) => l.toJson()).toList();
      await prefs.setString(_shoppingLabelsKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<ShoppingLabel>> loadShoppingLabels() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_shoppingLabelsKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ShoppingLabel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Foods & Einheiten (Autovervollständigung Einkaufsliste) ───────────────
  // Cache-first wie die Labels: die Vorschläge beim Tippen kommen sofort aus
  // dem Cache, der Server aktualisiert im Hintergrund. Gespeichert werden nur
  // die schlanken Felder (id/name/abbreviation), keine kompletten Roh-Objekte.

  static Future<void> saveFoodsCatalog(List<ShoppingFood> foods) async {
    try {
      final prefs = await _prefs;
      final jsonList = foods.map((f) => f.toJson()).toList();
      await prefs.setString(_foodsCatalogKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<ShoppingFood>> loadFoodsCatalog() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_foodsCatalogKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ShoppingFood.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> saveUnitsCatalog(List<ShoppingUnit> units) async {
    try {
      final prefs = await _prefs;
      final jsonList = units.map((u) => u.toJson()).toList();
      await prefs.setString(_unitsCatalogKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<ShoppingUnit>> loadUnitsCatalog() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_unitsCatalogKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => ShoppingUnit.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Organizer (Kategorien / Schlagworte / Utensilien) ──────────────────────
  // Cache-first für die Verwaltungs-Bildschirme; ein Key pro Art.

  static Future<void> saveOrganizers(
      OrganizerKind kind, List<OrganizerItem> items) async {
    try {
      final prefs = await _prefs;
      await prefs.setString('cache_organizers_${kind.path}',
          jsonEncode(items.map((i) => i.toJson()).toList()));
    } catch (_) {}
  }

  static Future<List<OrganizerItem>> loadOrganizers(OrganizerKind kind) async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString('cache_organizers_${kind.path}');
      if (raw == null || raw.isEmpty) return [];
      return (jsonDecode(raw) as List)
          .whereType<Map>()
          .map((e) => OrganizerItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Cookbooks ──────────────────────────────────────────────────────────────
  // Cache-first wie die Shopping-Labels: die Kochbuch-Übersicht rendert sofort
  // aus dem Cache und aktualisiert im Hintergrund vom Server.

  static Future<void> saveCookbooks(List<CookbookSummary> cookbooks) async {
    try {
      final prefs = await _prefs;
      final jsonList = cookbooks.map((c) => c.toJson()).toList();
      await prefs.setString(_cookbooksKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<CookbookSummary>> loadCookbooks() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_cookbooksKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => CookbookSummary.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Cookbook-Rezept-IDs ────────────────────────────────────────────────────
  // Pro Kochbuch die zuletzt vom Server aufgelöste ID-Liste (EIN Map-Eintrag
  // pro cookbookId unter einem gemeinsamen Key). Offline-first: die Kochbuch-
  // Rezeptliste rendert sofort aus diesen IDs (aufgelöst gegen den lokalen
  // Rezept-Cache) und gleicht im Hintergrund mit dem Server ab.
  // `null` = für dieses Kochbuch wurde noch NIE geladen; eine leere Liste ist
  // dagegen ein valides Ergebnis („Filter trifft nichts") und wird gecacht.

  static Future<void> saveCookbookRecipeIds(
      String cookbookId, List<String> ids) async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_cookbookRecipeIdsKey);
      final map = raw == null || raw.isEmpty
          ? <String, dynamic>{}
          : Map<String, dynamic>.from(jsonDecode(raw) as Map);
      map[cookbookId] = ids;
      await prefs.setString(_cookbookRecipeIdsKey, jsonEncode(map));
    } catch (_) {}
  }

  static Future<List<String>?> loadCookbookRecipeIds(String cookbookId) async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_cookbookRecipeIdsKey);
      if (raw == null || raw.isEmpty) return null;
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      final list = map[cookbookId];
      if (list is! List) return null;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return null;
    }
  }

  // ── Mealplan entries ───────────────────────────────────────────────────────
  // Offline-first für den Essensplan: Einträge flach als JSON-Liste; das
  // Gruppieren nach Tag macht der Provider.

  static Future<void> saveMealplanEntries(List<MealplanEntry> entries) async {
    try {
      final prefs = await _prefs;
      final jsonList = entries.map((e) => e.toJson()).toList();
      await prefs.setString(_mealplanKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  static Future<List<MealplanEntry>> loadMealplanEntries() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_mealplanKey);
      if (raw == null || raw.isEmpty) return [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => MealplanEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  // ── Current user (greeted on the home screen) ──────────────────────────────
  // Keeps the welcome line stable across launches — without this the home
  // screen renders "Willkommen bei Mealie Recipes" first and then re-renders
  // "Willkommen <name>, …" once /api/users/self resolves.

  static Future<void> saveCurrentUser(Map<String, dynamic>? user) async {
    try {
      final prefs = await _prefs;
      if (user == null) {
        await prefs.remove(_currentUserKey);
        return;
      }
      await prefs.setString(_currentUserKey, jsonEncode(user));
    } catch (_) {}
  }

  static Future<Map<String, dynamic>?> loadCurrentUser() async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(_currentUserKey);
      if (raw == null || raw.isEmpty) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  // ── Pending shopping changes (offline-first) ──────────────────────────────
  // Mirror Swift's per-type UserDefaults keys. Jeder Typ wird als JSON-Array
  // separat persistiert (savePendingCheckChanges, loadPendingCheckChanges, …).

  static Future<void> savePendingCheckChanges(
      List<PendingCheckChange> changes) async {
    await _writeJsonList(_pendingCheckKey, changes.map((c) => c.toJson()));
  }

  static Future<List<PendingCheckChange>> loadPendingCheckChanges() async {
    final raw = await _readJsonList(_pendingCheckKey);
    return raw.map((e) => PendingCheckChange.fromJson(e)).toList();
  }

  static Future<void> savePendingQuantityChanges(
      List<PendingQuantityChange> changes) async {
    await _writeJsonList(_pendingQuantityKey, changes.map((c) => c.toJson()));
  }

  static Future<List<PendingQuantityChange>>
      loadPendingQuantityChanges() async {
    final raw = await _readJsonList(_pendingQuantityKey);
    return raw.map((e) => PendingQuantityChange.fromJson(e)).toList();
  }

  static Future<void> savePendingDeleteChanges(
      List<PendingDeleteChange> changes) async {
    await _writeJsonList(_pendingDeleteKey, changes.map((c) => c.toJson()));
  }

  static Future<List<PendingDeleteChange>> loadPendingDeleteChanges() async {
    final raw = await _readJsonList(_pendingDeleteKey);
    return raw.map((e) => PendingDeleteChange.fromJson(e)).toList();
  }

  static Future<void> savePendingAddChanges(
      List<PendingAddChange> changes) async {
    await _writeJsonList(_pendingAddKey, changes.map((c) => c.toJson()));
  }

  static Future<List<PendingAddChange>> loadPendingAddChanges() async {
    final raw = await _readJsonList(_pendingAddKey);
    return raw.map((e) => PendingAddChange.fromJson(e)).toList();
  }

  static Future<void> savePendingCategoryChanges(
      List<PendingCategoryChange> changes) async {
    await _writeJsonList(_pendingCategoryKey, changes.map((c) => c.toJson()));
  }

  static Future<List<PendingCategoryChange>>
      loadPendingCategoryChanges() async {
    final raw = await _readJsonList(_pendingCategoryKey);
    return raw.map((e) => PendingCategoryChange.fromJson(e)).toList();
  }

  // ── SendTo (Recipe-Send-To-Device) ─────────────────────────────────────────
  // Persistente State der SendTo-Pipeline. Sheet überlebt App-Neustarts,
  // Sender-Queue retried beim nächsten LAN-Resolve, Dedupe verhindert dass
  // ein vom Sender wiederholt gepushtes Rezept doppelt im Empfänger landet.

  static Future<void> savePendingReceivedRecipes(
      List<Map<String, dynamic>> items) async {
    await _writeJsonList(_pendingReceivedKey, items);
  }

  static Future<List<Map<String, dynamic>>> loadPendingReceivedRecipes() async {
    return _readJsonList(_pendingReceivedKey);
  }

  static Future<void> savePendingOutgoingSends(
      List<Map<String, dynamic>> items) async {
    await _writeJsonList(_pendingOutgoingKey, items);
  }

  static Future<List<Map<String, dynamic>>> loadPendingOutgoingSends() async {
    return _readJsonList(_pendingOutgoingKey);
  }

  static Future<void> saveProcessedSendIds(List<String> ids) async {
    try {
      final prefs = await _prefs;
      await prefs.setStringList(_processedSendIdsKey, ids);
    } catch (_) {}
  }

  static Future<List<String>> loadProcessedSendIds() async {
    try {
      final prefs = await _prefs;
      return prefs.getStringList(_processedSendIdsKey) ?? const [];
    } catch (_) {
      return const [];
    }
  }

  // ── Generische JSON-Listen (Zeitleiste, Regeln, Lebensmittel/Einheiten) ──
  // Für kleinere Server-Listen, die nur zwischen App-Starts offline
  // verfügbar sein sollen. Key-Präfix `cache_`.

  static Future<void> saveJsonList(
          String key, Iterable<Map<String, dynamic>> items) =>
      _writeJsonList('cache_$key', items);

  static Future<List<Map<String, dynamic>>> loadJsonList(String key) =>
      _readJsonList('cache_$key');

  // ── internal helpers ──────────────────────────────────────────────────────

  static Future<void> _writeJsonList(
      String key, Iterable<Map<String, dynamic>> items) async {
    try {
      final prefs = await _prefs;
      await prefs.setString(key, jsonEncode(items.toList()));
    } catch (_) {}
  }

  static Future<List<Map<String, dynamic>>> _readJsonList(String key) async {
    try {
      final prefs = await _prefs;
      final raw = prefs.getString(key);
      if (raw == null || raw.isEmpty) return const [];
      final list = jsonDecode(raw) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (_) {
      return const [];
    }
  }
}
