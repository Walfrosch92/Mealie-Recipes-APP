import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/utils/ingredient_display.dart' show snapQuantity;
import '../../../core/utils/ingredient_parse.dart';
import '../models/pending_changes.dart';
import '../services/network_error.dart';
import '../../organizers/providers/organizers_provider.dart'
    show ownHouseholdSlugProvider;
import '../../recipes/providers/recipes_provider.dart';
import 'foods_units_provider.dart';
import 'pending_changes_provider.dart';
import 'shopping_lists_provider.dart';

// ---------------------------------------------------------------------------
// Online/Offline-Status + Server-Snapshot + Sync-Trigger
//
// 1:1 zu Swift:
//   @Published var isOffline
//   @Published var serverSnapshot
//   NotificationCenter.post(name: .pendingShoppingSync)
//
// In Flutter modellieren wir den Notification-Mechanismus als monoton
// inkrementierten Tick — die UI hört über ref.listen darauf und öffnet bei
// jeder Erhöhung das SyncChangesSheet (sofern Pending-Changes vorliegen).
// ---------------------------------------------------------------------------

final shoppingOfflineProvider = StateProvider<bool>((ref) => false);
final shoppingServerSnapshotProvider =
    StateProvider<List<ShoppingItem>>((ref) => const []);
final shoppingSyncTriggerProvider = StateProvider<int>((ref) => 0);

// ---------------------------------------------------------------------------
// Archivierte Einkäufe — beim „Einkauf abschließen" abgelegte erledigte
// Artikel. Früher (1:1 iOS) nur im Arbeitsspeicher: nach jedem App-Neustart
// war das Archiv leer. Jetzt dauerhaft im lokalen Cache, mit Datum und
// Listenname, begrenzt auf die letzten [_kMaxArchived] Einkäufe (neueste
// zuerst). Rein lokal — Mealie hat kein Archiv für Einkaufslisten.
// ---------------------------------------------------------------------------

const _kMaxArchived = 50;
const _kArchivedKey = 'archived_purchases';

class ArchivedPurchase {
  final String id;
  final DateTime date;
  final String listName;
  final List<ShoppingItem> items;

  const ArchivedPurchase({
    required this.id,
    required this.date,
    required this.listName,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'listName': listName,
        'items': items.map((i) => i.toJson()).toList(),
      };

  static ArchivedPurchase? tryParse(Map<String, dynamic> m) {
    try {
      return ArchivedPurchase(
        id: m['id'] as String,
        date: DateTime.parse(m['date'] as String),
        listName: (m['listName'] as String?) ?? '',
        items: [
          for (final i in (m['items'] as List? ?? const []))
            ShoppingItem.fromJson(Map<String, dynamic>.from(i as Map)),
        ],
      );
    } catch (_) {
      return null;
    }
  }
}

final archivedShoppingListsProvider =
    NotifierProvider<ArchivedShoppingListsNotifier, List<ArchivedPurchase>>(
        ArchivedShoppingListsNotifier.new);

class ArchivedShoppingListsNotifier extends Notifier<List<ArchivedPurchase>> {
  // Jede Änderung wartet, bis der gespeicherte Stand geladen ist. Vorher lief
  // der Load parallel zum ersten „Einkauf abschließen" nach dem App-Start:
  // addPurchase speicherte [neu] (überschrieb damit das alte Archiv), der
  // Load las danach genau dieses [neu] und hängte es an → der Einkauf stand
  // doppelt im Archiv und ältere Einkäufe waren weg.
  late Future<void> _loaded;

  @override
  List<ArchivedPurchase> build() {
    _loaded = _load();
    return const [];
  }

  Future<void> _load() async {
    final loaded = (await LocalCache.loadJsonList(_kArchivedKey))
        .map(ArchivedPurchase.tryParse)
        .whereType<ArchivedPurchase>()
        .toList();
    final clean = _dedupe(loaded);
    state = clean;
    // Bereits doppelt gespeicherte Einträge (alter Fehler) bereinigen.
    if (clean.length != loaded.length) {
      await LocalCache.saveJsonList(
          _kArchivedKey, clean.map((p) => p.toJson()));
    }
  }

  /// Gleiche Einkaufs-ID nur einmal, darin gleiche Artikel-ID nur einmal.
  static List<ArchivedPurchase> _dedupe(List<ArchivedPurchase> list) {
    final seen = <String>{};
    return [
      for (final p in list)
        if (seen.add(p.id))
          ArchivedPurchase(
            id: p.id,
            date: p.date,
            listName: p.listName,
            items: _uniqueItems(p.items),
          ),
    ];
  }

  static List<ShoppingItem> _uniqueItems(List<ShoppingItem> items) {
    final seen = <String>{};
    return [
      for (final i in items)
        if (i.id.isEmpty || seen.add(i.id)) i,
    ];
  }

  void _set(List<ArchivedPurchase> list) {
    state = list;
    LocalCache.saveJsonList(_kArchivedKey, list.map((p) => p.toJson()));
  }

  Future<void> addPurchase(List<ShoppingItem> items,
      {String listName = ''}) async {
    final unique = _uniqueItems(items);
    if (unique.isEmpty) return;
    final now = DateTime.now();
    await _loaded;
    _set([
      ArchivedPurchase(
        id: now.microsecondsSinceEpoch.toString(),
        date: now,
        listName: listName,
        items: unique,
      ),
      ...state,
    ].take(_kMaxArchived).toList());
  }

  Future<void> remove(String id) async {
    await _loaded;
    _set(state.where((p) => p.id != id).toList());
  }

  Future<void> deleteAll() async {
    await _loaded;
    _set(const []);
  }
}

// ---------------------------------------------------------------------------
// Labels provider — mirrors iOS ShoppingListViewModel.loadLabels()
// ---------------------------------------------------------------------------

final shoppingLabelsProvider =
    AsyncNotifierProvider<ShoppingLabelsNotifier, List<ShoppingLabel>>(
        ShoppingLabelsNotifier.new);

class ShoppingLabelsNotifier extends AsyncNotifier<List<ShoppingLabel>> {
  @override
  Future<List<ShoppingLabel>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadShoppingLabels();
    if (cached.isNotEmpty) {
      // Return cached palette immediately so the shopping list renders with
      // the correct category colors on the very first frame. Refresh from
      // the server in the background and update if anything changed.
      Future(() async {
        try {
          final fresh = await api.fetchShoppingLabels();
          await LocalCache.saveShoppingLabels(fresh);
          state = AsyncData(fresh);
        } catch (_) {/* keep cached */}
      });
      return cached;
    }
    try {
      final labels = await api.fetchShoppingLabels();
      await LocalCache.saveShoppingLabels(labels);
      return labels;
    } catch (_) {
      return [];
    }
  }

  /// Neu laden ohne Lade-Zustand (Verwaltung: kein Aufblitzen der Liste).
  Future<void> refreshQuiet() async {
    try {
      final labels = await ref.read(apiServiceProvider).fetchShoppingLabels();
      await LocalCache.saveShoppingLabels(labels);
      state = AsyncData(labels);
    } catch (_) {/* Stand behalten */}
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiServiceProvider);
      final labels = await api.fetchShoppingLabels();
      await LocalCache.saveShoppingLabels(labels);
      return labels;
    });
  }
}

// ---------------------------------------------------------------------------
// Shopping list provider
// ---------------------------------------------------------------------------

final shoppingListProvider =
    AsyncNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(
        ShoppingListNotifier.new);

class ShoppingListNotifier extends AsyncNotifier<List<ShoppingItem>> {
  @override
  Future<List<ShoppingItem>> build() async {
    final api = ref.watch(apiServiceProvider);
    // Debounce-Timer stoppen wenn der Provider neu gebaut/disposed wird —
    // sonst feuert _silentRefresh auf einem toten Notifier (ref nach dispose).
    ref.onDispose(() => _watchResyncTimer?.cancel());
    try {
      final items = await api.fetchShoppingItems();
      await LocalCache.saveShoppingItems(items);
      _onLoadSuccess(items);
      return items;
    } catch (e) {
      // Offline / Serverfehler → gecachte Liste zeigen + Offline-Banner
      // (isOffline via _onLoadFailure). NIEMALS hart fehlschlagen: ist der
      // Cache leer oder (z. B. nach Swift-Migration) nicht parsebar, lieber
      // eine leere Liste mit Offline-Hinweis zeigen als eine Fehlermeldung.
      // 1:1 zu Swifts isOffline-Pfad (loadShoppingListFromServer-Failure).
      final cached = await LocalCache.loadShoppingItems();
      _onLoadFailure();
      return cached;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiServiceProvider);
      try {
        final items = await api.fetchShoppingItems();
        await LocalCache.saveShoppingItems(items);
        _onLoadSuccess(items);
        return items;
      } catch (e) {
        // Siehe build(): offline → gecachte (ggf. leere) Liste statt Fehler.
        final cached = await LocalCache.loadShoppingItems();
        _onLoadFailure();
        return cached;
      }
    });
  }

  // mirrors iOS loadShoppingListFromServer (success branch):
  // serverSnapshot speichern, isOffline = false, bei pending changes nach
  // 0.5 s einen Sync-Tick feuern (Notification-Pendant in iOS).
  //
  // Abweichung von iOS (bewusst): Pending-ADDS werden automatisch und ohne
  // Sheet nachgeschoben. Ein Add ist konfliktfrei — es KANN keinen
  // widersprechenden Server-Stand geben — und der Sheet-Weg hatte eine
  // Falle: er öffnet nur bei gemountetem Shopping-Screen und braucht eine
  // User-Bestätigung. Offline (z. B. „Connection refused") erfasste Artikel
  // blieben so dauerhaft nur lokal sichtbar und erschienen nie in der
  // Webapp. Das Sheet bleibt für die echten Konfliktfälle
  // (Check/Menge/Kategorie/Delete) unverändert bestehen.
  // ── Offline vorgemerkte Rezept-Verknüpfungen ─────────────────────────────
  static const _kPendingRecipeRefs = 'pending_shopping_recipe_refs';

  Future<void> _queueRecipeReference(String listId, String recipeId) async {
    if (listId.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kPendingRecipeRefs) ?? <String>[];
      list.add('$listId|$recipeId');
      await prefs.setStringList(_kPendingRecipeRefs, list);
    } catch (_) {}
  }

  bool _syncingRefs = false;

  /// Nach dem Senden der Pending-Adds: Verknüpfungen nachtragen. Netzfehler
  /// → bleibt stehen; andere Fehler (alte Mealie-Version) → verwerfen.
  Future<void> _syncPendingRecipeRefs() async {
    if (_syncingRefs) return;
    _syncingRefs = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(_kPendingRecipeRefs) ?? <String>[];
      if (list.isEmpty) return;
      final api = ref.read(apiServiceProvider);
      final rest = <String>[];
      var any = false;
      for (var i = 0; i < list.length; i++) {
        final parts = list[i].split('|');
        if (parts.length != 2) continue;
        try {
          await api.addShoppingListRecipeReference(parts[0], parts[1]);
          any = true;
        } catch (e) {
          if (isNetworkError(e)) {
            rest.addAll(list.sublist(i));
            break;
          }
          LogManager.shared
              .log('⚠️ Vorgemerkte Rezept-Verknüpfung verworfen: $e');
        }
      }
      await prefs.setStringList(_kPendingRecipeRefs, rest);
      if (any) unawaited(ref.read(shoppingListsProvider.notifier).refresh());
    } catch (_) {
    } finally {
      _syncingRefs = false;
    }
  }

  void _onLoadSuccess(List<ShoppingItem> items) {
    ref.read(shoppingServerSnapshotProvider.notifier).state = items;
    ref.read(shoppingOfflineProvider.notifier).state = false;
    final pending = ref.read(pendingShoppingChangesProvider);
    if (pending.adds.isNotEmpty) {
      // Verknüpfungen erst NACH den Zutaten (Reihenfolge wie online).
      Future.microtask(() async {
        await _syncPendingAddsSilently();
        await _syncPendingRecipeRefs();
      });
    } else {
      Future.microtask(_syncPendingRecipeRefs);
    }
    Future.microtask(
        () => ref.read(shoppingListsProvider.notifier).flushPendingOrder());
    final hasConflicts = pending.checks.isNotEmpty ||
        pending.quantities.isNotEmpty ||
        pending.categories.isNotEmpty ||
        pending.notes.isNotEmpty ||
        pending.deletes.isNotEmpty;
    if (hasConflicts) {
      // Auto-Trigger: nach erfolgreichem Reload mit pending changes den
      // Sync-Sheet anstossen.
      Future.delayed(const Duration(milliseconds: 500), () {
        ref.read(shoppingSyncTriggerProvider.notifier).state++;
      });
    }
  }

  // Offline entstandene Adds still zum Server schieben, sobald er wieder
  // erreichbar ist: POSTen, lokales Dummy-Item (lokale UUID) durch das
  // Server-Echo ersetzen, Pending-Eintrag löschen. Schlägt ein POST erneut
  // fehl, bleibt der Pending-Eintrag stehen — der nächste erfolgreiche Load
  // versucht es wieder.
  bool _syncingAdds = false;
  Future<void> _syncPendingAddsSilently() async {
    if (_syncingAdds) return;
    _syncingAdds = true;
    try {
      final api = ref.read(apiServiceProvider);
      final pendingNotifier = ref.read(pendingShoppingChangesProvider.notifier);
      final adds = List<PendingAddChange>.of(
          ref.read(pendingShoppingChangesProvider).adds);
      final currentListId =
          ref.read(settingsProvider).valueOrNull?.shoppingListId ?? '';
      var anySynced = false;
      for (final add in adds) {
        // Jeder Add trägt seit `shoppingListId` seine eigene Ziel-Liste —
        // die AKTUELL aktive Liste NICHT blind verwenden, sonst landet ein
        // z. B. auf Liste A offline erfasster Artikel auf Liste B, falls der
        // User zwischenzeitlich die aktive Liste in den Settings gewechselt
        // hat. Ältere, vor diesem Feld persistierte Einträge (leeres
        // shoppingListId) fallen weiter auf die aktuell aktive Liste zurück.
        final targetListId =
            add.shoppingListId.isNotEmpty ? add.shoppingListId : currentListId;
        if (targetListId.isEmpty) continue;
        // Schon auf dem Server? Ein Timeout NACH dem Speichern (Antwort ging
        // verloren) landet ebenfalls hier — ein erneuter POST würde den
        // Artikel verdoppeln (Mealie führt gleiche Artikel zusammen → Menge
        // 2). Gleiche Regel wie beim normalen Hinzufügen: steht ein offener
        // Artikel mit diesem Namen schon auf der Liste, nicht noch einmal.
        if (targetListId == currentListId) {
          final want = add.note.trim().toLowerCase();
          final onServer = ref.read(shoppingServerSnapshotProvider).any((i) =>
              !i.checked &&
              (i.displayName.trim().toLowerCase() == want ||
                  (i.note ?? '').trim().toLowerCase() == want));
          if (want.isNotEmpty && onServer) {
            state.whenData((list) =>
                state = AsyncData(list.where((i) => i.id != add.id).toList()));
            await pendingNotifier.removeAdd(add.id);
            anySynced = true;
            continue;
          }
        }
        try {
          final created = await api.addShoppingItem(ShoppingItemCreate(
            shoppingListId: targetListId,
            note: add.note,
            quantity: add.quantity,
            labelId: add.labelId,
          ));
          // Den lokalen Dummy nur ersetzen/anhängen, wenn die GERADE
          // ANGEZEIGTE Liste auch das Ziel dieses Adds ist — sonst würde ein
          // für eine andere Liste bestimmter Artikel sichtbar in der
          // aktuell offenen Liste auftauchen.
          if (targetListId == currentListId) {
            state.whenData((list) {
              final idx = list.indexWhere((i) => i.id == add.id);
              final next = List<ShoppingItem>.of(list);
              if (idx >= 0) {
                // Label des Dummies behalten, falls der Server es (noch)
                // nicht aufgelöst zurückliefert.
                next[idx] = created.copyWith(label: next[idx].label);
              } else {
                next.add(created);
              }
              state = AsyncData(next);
            });
          }
          await pendingNotifier.removeAdd(add.id);
          anySynced = true;
        } catch (_) {/* bleibt pending, nächster Load versucht es erneut */}
      }
      if (anySynced) await _persistLocalCache();
    } finally {
      _syncingAdds = false;
    }
  }

  void _onLoadFailure() {
    ref.read(shoppingOfflineProvider.notifier).state = true;
  }

  // mirrors iOS addManualIngredient(note:label:)
  // Online: API anfragen, lokal anhängen. Bei echtem Netzwerkfehler: eigene
  // UUID erzeugen, lokales Dummy-Item einfügen und PendingAddChange speichern
  // (1:1 zu Swifts isOffline-Pfad).
  //
  // Erweiterung für den Exakt-Modus (manuelle Adds mit Menge + Einheit):
  //   • [quantity]  — echte Menge statt implizit 1 (z. B. 200).
  //   • [unit]      — aufgelöste Server-Einheit → strukturiert (unitId), der
  //                   Artikel erscheint in Webapp UND App als „200 g Butter".
  //   • [unitText]  — Freitext-Einheit OHNE Server-ID → in den Artikeltext
  //                   eingebettet („Tüte Butter"), gleiche Konvention wie
  //                   addIngredient. Schließen sich mit [unit] aus.
  //   • [food]      — aufgelöstes Server-Food → echtes Food-Item (foodId +
  //                   isFood, leere note) wie ein Webapp-Add — in BEIDEN
  //                   Modi. Ohne Treffer bleibt der Artikel eine Notiz wie in
  //                   Mealie 3.29; ein neues Lebensmittel entsteht nur auf
  //                   ausdrücklichen Wunsch (Einkaufsliste „Als neues
  //                   Lebensmittel speichern" → Aufrufer übergibt es hier).
  // Im Exakt-Modus wird außerdem wie bei addIngredient zusammengeführt:
  // gleicher Artikel + gleiche Einheit → Menge addieren (bzw. abgehakte mit
  // der neuen Menge wieder öffnen) statt ein Duplikat anzulegen.
  Future<void> addItem({
    required String note,
    String? shoppingListId,
    ShoppingLabel? label,
    double quantity = 1,
    ShoppingUnit? unit,
    String? unitText,
    ShoppingFood? food,
    // Zusatz-Notiz aus den aufgeklappten Details („reife"). Bei Lebensmitteln
    // die Notiz des Artikels, sonst wie die Webapp mit „, " angehängt.
    String? extraNote,
  }) async {
    final settings = ref.read(settingsProvider).valueOrNull;
    final listId = shoppingListId ?? settings?.shoppingListId ?? '';
    if (listId.isEmpty) return;

    final exact = settings?.addExactQuantities ?? false;
    final api = ref.read(apiServiceProvider);

    final resolvedFood = food;
    final asFood = (resolvedFood?.id ?? '').isNotEmpty;
    final embedUnit = (unitText ?? '').trim();
    final extra = (extraNote ?? '').trim();
    // Artikeltext für Notiz-Items; bei Food-Match bleibt die note leer
    // (bzw. trägt nur die Zusatz-Notiz).
    final baseText = embedUnit.isEmpty ? note : '$embedUnit $note';
    final itemText = extra.isEmpty ? baseText : '$baseText, $extra';

    // Mit Zusatz-Notiz nicht lokal zusammenführen — „Butter, reife" ist ein
    // eigener Wunsch (der Server entscheidet wie bei der Webapp selbst).
    if (exact && extra.isEmpty) {
      // Dubletten-Merge wie addIngredient: verglichen wird der fertige
      // Anzeigename gegen displayName, plus identische strukturierte Einheit
      // (g ≠ EL → separater Artikel).
      final compareName =
          asFood ? (resolvedFood!.name ?? note).trim() : itemText;
      final existing = state.valueOrNull ?? const <ShoppingItem>[];
      for (final i in existing) {
        if (i.displayName.toLowerCase() == compareName.toLowerCase() &&
            i.unit?.id == unit?.id) {
          if (i.checked) {
            // Beide Aufrufe statt einem kombinierten PUT, damit der
            // Offline-Pfad Quantity- UND Check-Änderung als Pending erfasst.
            await updateQuantity(i, quantity);
            await toggleChecked(i.copyWith(quantity: quantity));
          } else {
            await updateQuantity(i, snapQuantity((i.quantity ?? 1) + quantity));
          }
          return;
        }
      }
    }

    try {
      final item = await api.addShoppingItem(ShoppingItemCreate(
        shoppingListId: listId,
        note: asFood ? extra : itemText,
        isFood: asFood ? true : null,
        quantity: quantity,
        foodId: resolvedFood?.id,
        unitId: unit?.id,
        // Ohne gewählte Abteilung die des Lebensmittels — wie die Webapp.
        labelId: label?.id ?? resolvedFood?.labelId,
      ));
      // Echo-Lücken stopfen: liefert der Server food/unit (noch) nicht
      // aufgelöst zurück, das lokal aufgelöste Objekt einsetzen — sonst
      // hieße die Zeile bis zum stillen Refresh „-".
      final finalItem = item.copyWith(
        label: label ?? item.label,
        food: item.food == null ? resolvedFood : null,
        unit: item.unit == null ? unit : null,
      );
      _appendLocal(finalItem);
      // 4d (Hintergrund-Refresh): KEIN `refresh()` mit Loading-State-Flip —
      // der lokale Eintrag würde dabei kurz verschwinden und Mealie liefert
      // direkt nach POST oft noch die ungeänderte Liste (eventual
      // consistency). `_silentRefresh` aktualisiert lautlos und merged
      // local-pending mit Server-Stand, damit nichts wegspringt.
      Future.microtask(_silentRefresh);
    } catch (e) {
      // Server-/Decode-Fehler (z. B. HTTP 422/500) NICHT mehr verschlucken:
      // vorher verschwand das Item kommentarlos — weder Liste noch Webapp
      // noch Fehlermeldung. Der Screen fängt den Fehler und zeigt ihn an.
      if (!isNetworkError(e)) rethrow;
      // Pending-Adds kennen kein unitId/foodId → Einheit in den Text
      // einbetten, damit sie offline nicht verloren geht.
      final unitLabel = unit?.name?.trim() ?? embedUnit;
      final baseName = asFood ? (resolvedFood!.name ?? note).trim() : note;
      final pendingText = unitLabel.isEmpty ? baseName : '$unitLabel $baseName';
      await _enqueuePendingAdd(
          listId: listId,
          note: extra.isEmpty ? pendingText : '$pendingText, $extra',
          label: label,
          quantity: quantity);
    }
  }

  // Einheiten-Lookup (Token→kanonischer Name, inkl. Abkürzungen wie "g"→"Gramm"
  // und gängige Mehrsprach-Abkürzungen als Fallback; einmal geladen, gecacht) —
  // zum Erkennen/Strippen der Einheit in unstrukturierten Zutaten-Notentexten.
  Map<String, String>? _unitLookupCache;
  Future<Map<String, String>> _ensureUnitLookup() async {
    if (_unitLookupCache != null) return _unitLookupCache!;
    try {
      final raw = await ref.read(apiServiceProvider).fetchUnits();
      _unitLookupCache = buildUnitLookup(raw);
    } catch (_) {
      _unitLookupCache = buildUnitLookup(const []); // wenigstens der Fallback
    }
    return _unitLookupCache!;
  }

  // mirrors iOS addIngredients(_:) + buildIngredientName(for:)
  //
  // Adds the ingredient as "1x <name>" (whole unit, no fractional qty/unit),
  // because you can't buy 0.33l milk — you buy 1x milk. The food's saved
  // label/category is applied via foodId (server assigns it on refresh) —
  // that holds for BOTH modes below.
  //
  // With the "exakte Mengen" setting enabled, the scaled recipe amount goes
  // into the quantity field (the list row's stepper shows it, e.g. 200) and
  // the unit stays in the item text ("g Butter") — the row renders
  // [− qty +] displayName, so a structured unit field would be invisible.
  // Gibt `false` zurück, wenn der Server den Artikel abgelehnt hat (z. B.
  // HTTP 422/500) — vorher wurde das verschluckt und die Zutat fehlte
  // kommentarlos. Netzwerkfehler zählen als Erfolg: der Artikel landet im
  // Pending-Puffer und wird beim nächsten erfolgreichen Load nachgeschoben.
  /// Zutaten eines verlinkten Unterrezepts hinzufügen. Das Rezept kommt aus
  /// dem Cache (offline-fähig), sonst frisch vom Server. [depth] begrenzt
  /// Verschachtelungen (und schützt vor Rezepten, die sich gegenseitig
  /// verlinken).
  Future<bool> _addLinkedRecipe({
    required String shoppingListId,
    required ReferencedRecipe linked,
    required double factor,
    required bool refreshAfter,
    required int depth,
    bool Function(Ingredient)? skipIf,
  }) async {
    if (depth >= 3) return false;
    RecipeDetail? sub;
    for (final r in ref.read(recipesProvider).valueOrNull ?? const []) {
      if (r.id == linked.id) {
        sub = r;
        break;
      }
    }
    if (sub == null) {
      try {
        sub = await ref.read(apiServiceProvider).fetchRecipeDetail(linked.id);
      } catch (_) {
        return false;
      }
    }
    var ok = true;
    for (final ing in sub.recipeIngredient) {
      final added = await addIngredient(
        shoppingListId: shoppingListId,
        ingredient: ing,
        multiplier: factor,
        refreshAfter: false,
        depth: depth + 1,
        skipIf: skipIf,
        // Wie Mealie: Zutaten eines Unterrezepts verweisen auf DAS
        // Unterrezept (ohne eigenen Listen-Eintrag).
        recipeId: sub.id,
      );
      ok = ok && added;
    }
    if (refreshAfter) await refresh();
    return ok;
  }

  /// Rezept zur Liste — wie Mealies „Zur Einkaufsliste": die Artikel tragen
  /// die Rezept-Verknüpfung und die Liste führt das Rezept unter „verknüpfte
  /// Rezepte". [ingredients] = Auswahl (sonst alle). Gibt die Zahl der vom
  /// Server abgelehnten Zutaten zurück; der Aufrufer refresht danach.
  ///
  /// Online macht das wie die Webapp der SERVER in einem Aufruf
  /// ([_addRecipeViaServer]): Mengen × Faktor, Einheiten, Lebensmittel,
  /// Abteilungen, Zusammenführen mit offenen Artikeln, Rezept-Verknüpfung.
  /// Offline (oder falls der Server den Aufruf ablehnt) wie bisher Zutat für
  /// Zutat mit Offline-Warteschlange ([_addRecipeLegacy]).
  Future<int> addRecipe({
    required String shoppingListId,
    required RecipeDetail recipe,
    required double multiplier,
    Iterable<Ingredient>? ingredients,
    bool Function(Ingredient)? skipIf,
  }) async {
    if (shoppingListId.isEmpty) return 0;
    final selected = (ingredients ?? recipe.recipeIngredient).toList();
    // Jede Zutat nur EINMAL prüfen — der Aufrufer zählt die Treffer
    // („x vorrätig übersprungen"); fällt der Server-Weg auf den alten Weg
    // zurück, würde sonst doppelt gezählt.
    final memo = <String, bool>{};
    final checkOnce = skipIf == null
        ? null
        : (Ingredient ing) => memo.putIfAbsent(
            '${ing.referenceId}|${ing.food?.id}|${ing.note}|${ing.quantity}',
            () => skipIf(ing));
    try {
      await _addRecipeViaServer(
        shoppingListId: shoppingListId,
        recipe: recipe,
        multiplier: multiplier,
        selected: selected,
        skipIf: checkOnce,
      );
      return 0;
    } on _AmbiguousRecipePost catch (e) {
      // Anfrage kam an, nur die Antwort blieb aus — der Server hat die
      // Zutaten sehr wahrscheinlich schon angelegt. NICHT nochmal Zutat für
      // Zutat (sonst doppelt), nur den Stand neu laden.
      LogManager.shared
          .log('⏳ Rezept zur Liste: Antwort blieb aus (${recipe.slug}): $e');
      await _silentRefresh();
      return 0;
    } catch (e) {
      LogManager.shared.log(isNetworkError(e)
          ? '📴 Rezept offline zur Liste (${recipe.slug}) — Warteschlange'
          : '⚠️ Rezept über Server fehlgeschlagen (${recipe.slug}): $e — '
              'Zutat für Zutat');
    }
    return _addRecipeLegacy(
      shoppingListId: shoppingListId,
      recipe: recipe,
      multiplier: multiplier,
      ingredients: selected,
      skipIf: checkOnce,
    );
  }

  Future<void> _addRecipeViaServer({
    required String shoppingListId,
    required RecipeDetail recipe,
    required double multiplier,
    required List<Ingredient> selected,
    bool Function(Ingredient)? skipIf,
  }) async {
    final api = ref.read(apiServiceProvider);
    final exact =
        ref.read(settingsProvider).valueOrNull?.addExactQuantities ?? false;

    // Rohe Zutaten vom Server — wie die Webapp sie schickt: komplette
    // Lebensmittel (inkl. Abteilung) und komplette verlinkte Unterrezepte.
    final raw = await api.fetchRecipeRaw(recipe.id);
    final rawIngs = _rawIngredientList(raw);

    // Ausgewählte (gecachte) Zutaten den rohen zuordnen: per referenceId,
    // sonst per Position (wenn Cache und Server gleich lang sind), sonst
    // das App-Modell selbst (dann ohne Abteilung — der Server rät sie).
    final byRef = <String, Map<String, dynamic>>{
      for (final m in rawIngs)
        if ((m['referenceId'] as String?)?.isNotEmpty == true)
          m['referenceId'] as String: m,
    };
    final sameShape = rawIngs.length == recipe.recipeIngredient.length;
    Map<String, dynamic> rawFor(Ingredient ing) {
      final refId = ing.referenceId;
      if (refId != null && byRef[refId] != null) return byRef[refId]!;
      if (sameShape) {
        final i = recipe.recipeIngredient.indexOf(ing);
        if (i >= 0) return rawIngs[i];
      }
      return ing.toJson();
    }

    final unitLookup = exact ? null : await _ensureUnitLookup();
    final aus = _AusDedupe(state.valueOrNull ?? const <ShoppingItem>[]);
    final payload = <Map<String, dynamic>>[];
    for (final ing in selected) {
      final m = await _prepareServerIngredient(
        Map<String, dynamic>.from(rawFor(ing)),
        exact: exact,
        skipIf: skipIf,
        unitLookup: unitLookup,
        aus: aus,
        depth: 0,
      );
      if (m != null) payload.add(m);
    }

    // Einfacher Modus: immer „1×" — Faktor 1, damit der Server die Menge 1
    // nicht vervielfacht und „Rezept entfernen" genau 1× wieder abzieht.
    try {
      await api.addRecipeIngredientsToShoppingList(
          shoppingListId, recipe.id, exact ? multiplier : 1, payload);
    } on DioException catch (e) {
      // Gesendet, aber keine (rechtzeitige) Antwort → Ergebnis unbekannt.
      // Verbindungsfehler/-Timeout = nie angekommen → Rückfall ist sicher.
      if (e.type == DioExceptionType.receiveTimeout) {
        throw _AmbiguousRecipePost(e);
      }
      rethrow;
    }
    unawaited(ref.read(shoppingListsProvider.notifier).refresh());
    await _silentRefresh();
  }

  static List<Map<String, dynamic>> _rawIngredientList(dynamic recipeMap) {
    final list = recipeMap is Map ? recipeMap['recipeIngredient'] : null;
    return [
      for (final e in (list is List ? list : const []))
        if (e is Map) Map<String, dynamic>.from(e),
    ];
  }

  /// Eine rohe Zutat für den Server vorbereiten. `null` = nicht senden
  /// (reine Abschnitts-Überschrift, „Im Haushalt vorrätig", im einfachen
  /// Modus schon auf der Liste). Verlinkte Unterrezepte werden rekursiv
  /// genauso gefiltert — der Server löst sie selbst auf, braucht dafür aber
  /// das komplette Unterrezept (fehlt es, wird es nachgeladen).
  Future<Map<String, dynamic>?> _prepareServerIngredient(
    Map<String, dynamic> m, {
    required bool exact,
    required bool Function(Ingredient)? skipIf,
    required Map<String, String>? unitLookup,
    required _AusDedupe aus,
    required int depth,
  }) async {
    final ing = Ingredient.fromJson(m);
    final food = ing.food?.name?.trim() ?? '';

    // Verlinktes Unterrezept („1 Béchamelsauce").
    final linked = m['referencedRecipe'];
    if (food.isEmpty && linked is Map && linked['id'] != null) {
      if (depth >= 3) return null; // Schutz vor Endlos-Verlinkung
      var sub = Map<String, dynamic>.from(linked);
      if (sub['recipeIngredient'] is! List) {
        sub = await ref
            .read(apiServiceProvider)
            .fetchRecipeRaw(sub['slug'] as String? ?? sub['id'] as String);
      }
      final subIngs = <Map<String, dynamic>>[];
      for (final s in _rawIngredientList(sub)) {
        final p = await _prepareServerIngredient(s,
            exact: exact,
            skipIf: skipIf,
            unitLookup: unitLookup,
            aus: aus,
            depth: depth + 1);
        if (p != null) subIngs.add(p);
      }
      if (subIngs.isEmpty) return null;
      sub['recipeIngredient'] = subIngs;
      m['referencedRecipe'] = sub;
      // Einfacher Modus: Unterrezept nicht vervielfachen (Server rechnet
      // Menge der Verknüpfung × Faktor, 0 zählt als 1).
      if (!exact) m['quantity'] = 0;
      return m;
    }

    if (!ing.hasContent) return null; // reine Abschnitts-Überschrift
    if (skipIf != null && skipIf(ing)) return null;

    final note = ing.note?.trim() ?? '';
    final hasFood = ing.food?.id != null && food.isNotEmpty;

    if (exact) {
      // Unstrukturierte Zutat („200 g Gouda", ohne Lebensmittel und Menge):
      // führende Zahl ins Mengenfeld, damit der Server sie mit dem Faktor
      // skaliert (die Webapp würde „200 g Gouda" unverändert übernehmen).
      if (!hasFood && (ing.quantity ?? 0) == 0 && note.isNotEmpty) {
        final (qty, rest) = _splitLeadingNumber(note);
        if (qty != null && rest.isNotEmpty) {
          m['quantity'] = qty;
          m['note'] = rest;
        }
      }
      return m;
    }

    // ── Einfacher Modus: „1× Butter" ─────────────────────────────────────
    final unitName = ing.unit?.name?.trim() ?? '';
    // Parser-Sonderfall „4 Eier (Größe M)": das Nomen steckt in der Einheit.
    final unitCarriesName = ing.unit?.id != null &&
        unitName.isNotEmpty &&
        food.length > 2 &&
        food.startsWith('(') &&
        food.endsWith(')');
    String name;
    if (hasFood) {
      name = unitCarriesName ? '$unitName $food' : food;
    } else {
      final units = unitLookup ?? const <String, String>{};
      name = splitIngredientNote(note, units).food;
      if (name.isEmpty) name = _nameFromNote(note, ing.unit?.name?.trim());
    }
    name = name.trim();
    if (name.isEmpty) return null;
    // Schon auf der Liste (offen oder abgehakt) oder doppelt im Rezept →
    // nicht nochmal (sonst addiert der Server zu „2× Butter").
    if (!aus.claim(name, hasFood ? ing.food!.id : null)) return null;

    m['quantity'] = 1;
    m['disableAmount'] = false;
    if (hasFood) {
      // Nur der Artikel — keine Zubereitungs-Notiz („geschmolzen").
      m['note'] = '';
      if (!unitCarriesName) m['unit'] = null;
    } else {
      m['note'] = name;
      m['unit'] = null;
      m['food'] = null;
    }
    return m;
  }

  /// Bisheriger Weg Zutat für Zutat — offline mit Warteschlange.
  Future<int> _addRecipeLegacy({
    required String shoppingListId,
    required RecipeDetail recipe,
    required double multiplier,
    Iterable<Ingredient>? ingredients,
    bool Function(Ingredient)? skipIf,
  }) async {
    var failed = 0;
    for (final ing in ingredients ?? recipe.recipeIngredient) {
      final ok = await addIngredient(
        shoppingListId: shoppingListId,
        ingredient: ing,
        multiplier: multiplier,
        refreshAfter: false,
        skipIf: skipIf,
        recipeId: recipe.id,
      );
      if (!ok) failed++;
    }
    try {
      await ref
          .read(apiServiceProvider)
          .addShoppingListRecipeReference(shoppingListId, recipe.id);
      unawaited(ref.read(shoppingListsProvider.notifier).refresh());
    } catch (e) {
      // Offline: vormerken — die Zutaten kommen über die Pending-Adds an, die
      // Verknüpfung (und damit das „−" der Webapp) sonst nie.
      if (isNetworkError(e)) {
        await _queueRecipeReference(shoppingListId, recipe.id);
      }
      // Alte Mealie-Version o. Ä.: Zutaten sind trotzdem auf der Liste,
      // nur ohne Eintrag unter „verknüpfte Rezepte".
      LogManager.shared.log('⚠️ Rezept-Verknüpfung nicht gesetzt: $e');
    }
    return failed;
  }

  /// „−" bei einem verknüpften Rezept: Mealie zieht die Mengen dieses Rezepts
  /// ab und löscht leere Artikel (wie die Webapp).
  Future<void> removeRecipe(String shoppingListId, String recipeId) async {
    await ref
        .read(apiServiceProvider)
        .removeShoppingListRecipe(shoppingListId, recipeId);
    await Future.wait([
      ref.read(shoppingListsProvider.notifier).refresh(),
      _silentRefresh(),
    ]);
  }

  /// Prüfer für „Im Haushalt vorrätig" (eigener Haushalt) — dieselbe Regel
  /// wie Mealie-Web: dort sind vorrätige Zutaten im „Zur Einkaufsliste
  /// hinzufügen"-Dialog abgewählt. Quelle ist der Lebensmittel-Katalog
  /// (Cache-first), nicht das Rezept-JSON — „Vorrätig" ändert das Rezept
  /// nicht und stünde dort im Cache sonst veraltet.
  Future<bool Function(Ingredient)> onHandChecker() async {
    var foods = const <ShoppingFood>[];
    String? slug;
    try {
      foods = await ref.read(foodsCatalogProvider.future);
    } catch (_) {/* ohne Katalog: nichts überspringen */}
    try {
      slug = await ref.read(ownHouseholdSlugProvider.future);
    } catch (_) {}
    final onHand = <String>{
      for (final f in foods)
        if (f.id != null && f.isOnHandIn(slug)) f.id!,
    };
    return (ing) {
      final id = ing.food?.id;
      return id != null && onHand.contains(id);
    };
  }

  Future<bool> addIngredient({
    required String shoppingListId,
    required Ingredient ingredient,
    required double multiplier, // used only when addExactQuantities is on
    bool refreshAfter = true,
    int depth = 0,
    // Zutaten, die NICHT auf die Liste sollen (z. B. „Im Haushalt
    // vorrätig", siehe [onHandChecker]) — gilt auch für die Zutaten
    // verlinkter Unterrezepte. Übersprungen zählt als Erfolg.
    bool Function(Ingredient)? skipIf,
    // Rezept, aus dem die Zutat stammt → Mealie-Rezept-Verknüpfung am
    // Artikel (für „verknüpfte Rezepte" und „Rezept entfernen").
    String? recipeId,
  }) async {
    if (shoppingListId.isEmpty) return false;
    // Reine Abschnitts-Überschrift („Knusperboden") ist nichts zum Kaufen —
    // gilt als erledigt statt als Fehlschlag (zählt nicht in „x fehlgeschlagen").
    if (!ingredient.hasContent) return true;
    if (skipIf != null && skipIf(ingredient)) return true;
    // Verlinktes Rezept („1 Béchamelsauce"): nicht das Rezept selbst auf die
    // Liste setzen, sondern SEINE Zutaten — skaliert mit der Menge.
    final linked = ingredient.referencedRecipe;
    if (linked != null && (ingredient.food?.name?.trim().isEmpty ?? true)) {
      return _addLinkedRecipe(
        shoppingListId: shoppingListId,
        linked: linked,
        factor: multiplier *
            ((ingredient.quantity ?? 0) > 0 ? ingredient.quantity! : 1),
        refreshAfter: refreshAfter,
        depth: depth,
        skipIf: skipIf,
      );
    }
    try {
      final api = ref.read(apiServiceProvider);
      final exact =
          ref.read(settingsProvider).valueOrNull?.addExactQuantities ?? false;

      // Only the ingredient name (food). Notes are NOT appended — you buy
      // "Weizenmehl", not "220 g Weizenmehl".
      final food = ingredient.food?.name?.trim() ?? '';
      final note = ingredient.note?.trim() ?? '';
      // Parser-Sonderfall „4 Eier (Größe M)": Mealie legt das Nomen als
      // EINHEIT an und nur die Klammer-Anmerkung als Food. Der Produktname
      // steckt dann in der Einheit — sie muss deshalb in BEIDEN Modi
      // strukturiert mitgehen (sonst hieße der Artikel nur „(Größe M)").
      final unitName = ingredient.unit?.name?.trim() ?? '';
      final ingredientUnitCarriesName = ingredient.unit?.id != null &&
          unitName.isNotEmpty &&
          food.length > 2 &&
          food.startsWith('(') &&
          food.endsWith(')');
      String name;
      double quantity = 1;
      String? unitId; // strukturierte Einheit (Webapp-Parität) im Exakt-Modus
      String unitText = ''; // Einheiten-Text für den Offline-Fallback
      if (exact) {
        if (food.isNotEmpty) {
          name = food;
          // disableAmount-Zutaten haben bewusst keine Menge → 1x purer Name.
          if (ingredient.disableAmount != true &&
              (ingredient.quantity ?? 0) > 0) {
            // Auf 2 Nachkommastellen runden — ein Multiplikator aus einer
            // exakt eingegebenen/gesteppten Zielportionenzahl (siehe
            // _PortionStepper) ist i. Allg. kein exakter Binärbruch (z. B.
            // 6 × 4/6 = 3.9999999999999996 statt 4.0), sonst würde diese
            // Float-Rundung dauerhaft im gespeicherten Artikel landen.
            // Exakte Koch-Brüche speichern (⅛ = 0.125) — auf 2 Stellen
            // gerundet stand sonst 0.13 auf dem Server (Webapp-Anzeige,
            // Summen beim Zusammenführen, +/- im Bruch-Raster).
            quantity = snapQuantity(ingredient.quantity! * multiplier);
            final unit = ingredient.unit?.name?.trim() ?? '';
            if (ingredient.unit?.id != null && unit.isNotEmpty) {
              // Einheit strukturiert mitgeben — Server und Webapp zeigen den
              // Artikel dann exakt wie ein Web-Add ("150 g Joghurt").
              unitId = ingredient.unit!.id;
              unitText = unit;
            } else if (unit.isNotEmpty) {
              // Freitext-Einheit ohne Server-ID: in den Artikeltext einbetten.
              name = '$unit $food';
            }
          }
        } else {
          // Unstrukturierte Zutat: führende Zahl des note-Texts skaliert ins
          // Mengenfeld, der Rest ("g Gouda") wird der Artikeltext.
          final (parsedQty, rest) = _splitLeadingNumber(note);
          if (parsedQty != null && rest.isNotEmpty) {
            quantity = snapQuantity(parsedQty * multiplier);
            name = rest;
          } else {
            name = note;
          }
        }
      } else if (food.isNotEmpty) {
        name = food;
      } else {
        // Unstrukturierte Zutat (food leer, alles im note-Text wie
        // "200.0 Gramm Gouda" — z.B. von einer älteren App-Version). Mit den
        // bekannten Mealie-Einheiten zerlegen und NUR die Zutat nehmen.
        final units = await _ensureUnitLookup();
        name = splitIngredientNote(note, units).food;
        if (name.isEmpty) {
          name = _nameFromNote(note, ingredient.unit?.name?.trim());
        }
      }
      if (name.isEmpty) return true;

      // Namenstragende Einheit immer strukturiert anhängen — auch im 1x-Modus
      // und ohne Menge, damit der Artikel als „Eier (Größe M)" erscheint
      // (ShoppingItem.unitCarriesName setzt beides voraus).
      final carriesName = ingredientUnitCarriesName && name == food;
      if (carriesName) {
        unitId = ingredient.unit!.id;
        unitText = unitName;
      }

      // Skip if already on the list (mirrors iOS contains-check, aber über
      // displayName statt note — so zählen auch Web-Adds mit leerer note und
      // gesetztem food als vorhanden). Mit exakten Mengen wird stattdessen
      // zusammengeführt: offene Artikel gleicher Einheit addieren die Menge
      // (150 g + 200 g → 350 g), abgehakte werden mit der neuen Menge wieder
      // geöffnet. Andere Einheit (g vs. EL) → separater Artikel.
      // Verglichen wird gegen den fertigen Anzeigenamen: bei namenstragender
      // Einheit ist das „Eier (Größe M)", nicht das nackte Food.
      final compareName = carriesName ? '$unitName $name' : name;
      final existing = state.valueOrNull ?? [];
      ShoppingItem? match;
      for (final i in existing) {
        if (i.displayName.toLowerCase() == compareName.toLowerCase() &&
            (!exact || i.unit?.id == unitId)) {
          match = i;
          break;
        }
      }
      if (match != null) {
        if (exact) {
          if (match.checked) {
            // Beide Aufrufe statt einem kombinierten PUT, damit der
            // Offline-Pfad Quantity- UND Check-Änderung als Pending erfasst.
            await updateQuantity(match, quantity);
            await toggleChecked(match.copyWith(quantity: quantity));
          } else {
            await updateQuantity(
                match, snapQuantity((match.quantity ?? 1) + quantity));
          }
        }
        return true;
      }

      try {
        // Entspricht der Artikeltext exakt dem Server-Food (kein eingebetteter
        // Einheiten-Freitext), als ECHTES Food-Item anlegen (isFood=true,
        // leere note) — genau wie ein Webapp-Add. Vorher waren App-Adds reine
        // Notiz-Items und erschienen in der Webapp nur als unscheinbare
        // Freitextzeile; außerdem greift so der food-first-displayName.
        final asFood = ingredient.food?.id != null && name == food;
        await api.addShoppingItem(ShoppingItemCreate(
          shoppingListId: shoppingListId,
          note: asFood ? '' : name,
          isFood: asFood ? true : null,
          quantity: quantity, // 1x — bzw. exakte Rezeptmenge im Exakt-Modus
          foodId: ingredient.food?.id,
          unitId: unitId, // null außer im Exakt-Modus mit Server-Einheit
          // Menge = genau das, was hier auf die Liste kommt (1x bzw. exakt)
          // — so zieht „Rezept entfernen" serverseitig exakt das wieder ab.
          recipeReferences: recipeId == null
              ? null
              : [
                  {
                    'recipeId': recipeId,
                    'recipeQuantity': quantity,
                    'recipeScale': 1,
                    if (note.isNotEmpty) 'recipeNote': note,
                  }
                ],
        ));
        // Stiller Refresh statt `refresh()` damit die Liste nicht in den
        // Loading-State kippt und gerade frisch eingefügte Items nicht
        // wegblitzen.
        if (refreshAfter) await _silentRefresh();
      } catch (e) {
        // Server-/Decode-Fehler: als Fehlschlag melden statt still zu
        // verschlucken — der Aufrufer (Detail-Screen) zählt die Ausfälle
        // und zeigt sie im Snackbar-Text an.
        if (!isNetworkError(e)) return false;
        // Pending-Adds kennen kein unitId/foodId → Einheit in den Text
        // einbetten, damit sie offline nicht verloren geht.
        await _enqueuePendingAdd(
            listId: shoppingListId,
            note: unitText.isEmpty ? name : '$unitText $name',
            label: null,
            quantity: quantity);
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  // Extract the bare ingredient name from an unstructured note.
  // Language- and unit-agnostic: we strip the leading quantity (digits/
  // fractions are universal) and, if the server provided a structured unit,
  // we strip that exact unit word — instead of guessing from a word list.
  String _nameFromNote(String note, String? unitName) {
    var s = note.trim();
    // 1) Leading quantity: digits, decimals, commas, ranges, fractions.
    s = s.replaceFirst(RegExp(r'^[\d.,/½¼¾⅓⅔⅛⅜⅝⅞\s\-–]+'), '').trim();
    // 2) The actual unit value from the ingredient (any language/unit).
    if (unitName != null && unitName.isNotEmpty) {
      final lower = s.toLowerCase();
      final u = unitName.toLowerCase();
      if (lower.startsWith(u)) {
        s = s
            .substring(unitName.length)
            .replaceFirst(RegExp(r'^[.\s]+'), '')
            .trim();
      }
    }
    return s.isEmpty ? note.trim() : s;
  }

  // Zerlegt einen unstrukturierten note-Text in führende Zahl + Rest
  // ("200 g Gouda" → (200, "g Gouda")). Zahl-Parsing identisch zu _scaledNote
  // der Detailansicht (Ganzzahlen, "0,5"/"0.5"-Dezimalen, Brüche "1/2");
  // ohne parsbare Zahl kommt (null, <ganzer Text>) zurück.
  (double?, String) _splitLeadingNumber(String note) {
    final trimmed = note.trim();
    final match =
        RegExp(r'^(\d+(?:[.,]\d+)?(?:/\d+(?:[.,]\d+)?)?)(.*)$', dotAll: true)
            .firstMatch(trimmed);
    if (match == null) return (null, trimmed);
    final numberStr = match.group(1)!;
    final rest = (match.group(2) ?? '').trim();

    double? parsed;
    if (numberStr.contains('/')) {
      final parts = numberStr.split('/');
      final a = double.tryParse(parts[0].replaceAll(',', '.'));
      final b = parts.length == 2
          ? double.tryParse(parts[1].replaceAll(',', '.'))
          : null;
      if (a != null && b != null && b != 0) parsed = a / b;
    } else {
      parsed = double.tryParse(numberStr.replaceAll(',', '.'));
    }
    return parsed == null ? (null, trimmed) : (parsed, rest);
  }

  // mirrors iOS toggleIngredientCompletion(_:)
  // Optimistic update bleibt sichtbar; bei Netzwerkfehler → PendingCheck.
  Future<void> toggleChecked(ShoppingItem item) async {
    final updated = item.copyWith(checked: !item.checked);
    _updateLocal(updated);
    await _persistLocalCache();
    try {
      await ref.read(apiServiceProvider).updateShoppingItem(updated);
    } catch (e) {
      if (!isNetworkError(e)) {
        _updateLocal(item); // server/decode error → revert
        await _persistLocalCache();
        return;
      }
      await ref.read(pendingShoppingChangesProvider.notifier).addCheck(
          PendingCheckChange(itemId: item.id, checked: updated.checked));
    }
  }

  // mirrors iOS updateQuantity(for:to:)
  // `clearUnit`: bei DEAKTIVIERTEN exakten Mengen zeigt die Liste Einheiten-
  // Artikel (z. B. Web-Add „150 g Joghurt") als 1x-Stückkauf — die erste
  // bewusste +/−-Interaktion macht daraus einen echten Stück-Artikel und
  // entfernt dabei die Einheit (PUT schickt unitId: null).
  Future<void> updateQuantity(ShoppingItem item, double qty,
      {bool clearUnit = false}) async {
    final updated = item.copyWith(quantity: qty, clearUnit: clearUnit);
    _updateLocal(updated);
    await _persistLocalCache();
    _scheduleWatchResync(); // Uhr nach dem Tap-Burst sauber nachziehen
    try {
      await ref.read(apiServiceProvider).updateShoppingItem(updated);
    } catch (e) {
      if (!isNetworkError(e)) {
        _updateLocal(item);
        await _persistLocalCache();
        return;
      }
      await ref
          .read(pendingShoppingChangesProvider.notifier)
          .addQuantity(PendingQuantityChange(itemId: item.id, quantity: qty));
    }
  }

  // mirrors iOS updateItemCategory(_:to:)
  Future<void> updateItemCategory(
      ShoppingItem item, ShoppingLabel? label) async {
    if (item.label?.id == label?.id) return;
    final updated = item.copyWith(label: label, clearLabel: label == null);
    _updateLocal(updated);
    await _persistLocalCache();
    try {
      await ref.read(apiServiceProvider).updateShoppingItem(updated);
    } catch (e) {
      if (!isNetworkError(e)) {
        _updateLocal(item);
        await _persistLocalCache();
        return;
      }
      await ref.read(pendingShoppingChangesProvider.notifier).addCategory(
          PendingCategoryChange(itemId: item.id, labelId: label?.id));
    }
  }

  // Edit name (note), quantity and category together in one update.
  // Hier matchen wir iOS' Aufteilung: das eine UI-Edit wird intern in die
  // entsprechenden Pending-Eimer zerlegt, damit der Konflikt-Sheet jede
  // Dimension separat lösen lassen kann.
  Future<void> editItem(
    ShoppingItem item, {
    required String note,
    required double quantity,
    required ShoppingLabel? label,
    required bool clearLabel,
  }) async {
    final trimmed = note.trim();
    // Food-Items (Web-Adds): das Namensfeld des Edit-Sheets zeigt seit dem
    // food-first-displayName den PRODUKTNAMEN aus `food`, nicht die note.
    // Unverändert speichern darf die note deshalb NICHT mit dem Food-Namen
    // überschreiben (dort steckt die echte Zusatznotiz). Wird der Name
    // BEWUSST geändert, lösen wir die Food-Verknüpfung (clearFood) und
    // schreiben den neuen Text in die note — sonst bliebe die Umbenennung
    // unsichtbar, weil App und Webapp bei Food-Items den food-Namen zeigen.
    // Rename-Erkennung gegen displayName (das zeigt das Edit-Sheet an) —
    // bei unitCarriesName-Items („Eier (Größe M)") wäre der Food-Name allein
    // immer ungleich und jedes unveränderte Speichern würde die Food-
    // Verknüpfung lösen. `foodLeads` statt `isFood`, weil Web-Adds auch mit
    // isFood=false food-verknüpft ankommen.
    final shownName = item.displayName;
    final renamedFoodItem = item.foodLeads &&
        trimmed.isNotEmpty &&
        trimmed.toLowerCase() != shownName.toLowerCase();
    final keepNote = trimmed.isEmpty || (item.foodLeads && !renamedFoodItem);
    // Umbenannt auf ein bekanntes Lebensmittel (Name/Plural/Alias, z. B. per
    // Vorschlag gewählt) → wie beim Hinzufügen damit VERKNÜPFEN statt zum
    // Notiz-Artikel zu machen. Eine Zusatznotiz eines Food-Items bleibt.
    final renamed = trimmed.isNotEmpty &&
        trimmed.toLowerCase() != shownName.toLowerCase();
    final linkFood = renamed
        ? resolveFoodByName(
            ref.read(foodsCatalogProvider).valueOrNull ?? const [], trimmed)
        : null;
    final relink = linkFood != null && linkFood.id != item.food?.id;
    final updated = relink
        ? item.copyWith(
            note: item.foodLeads ? (item.note ?? '') : '',
            food: linkFood,
            quantity: quantity,
            label: label,
            clearLabel: clearLabel,
            // Alter Produktname in der Einheit („Eier (Größe M)") muss weg.
            clearUnit: item.unitCarriesName,
          )
        : item.copyWith(
            note: keepNote ? item.note : trimmed,
            quantity: quantity,
            label: label,
            clearLabel: clearLabel,
            clearFood: renamedFoodItem,
            // Bei unitCarriesName-Items steckt der alte Produktname in der
            // Einheit („Eier") — die muss beim Rename mit weg, sonst hängt
            // der Exakt-Modus sie weiter vor den neuen Namen.
            clearUnit: renamedFoodItem && item.unitCarriesName,
          );
    _updateLocal(updated);
    await _persistLocalCache();
    _scheduleWatchResync(); // Uhr nach dem Edit sauber nachziehen
    try {
      await ref.read(apiServiceProvider).updateShoppingItem(updated);
    } catch (e) {
      if (!isNetworkError(e)) {
        _updateLocal(item);
        await _persistLocalCache();
        return;
      }
      final pending = ref.read(pendingShoppingChangesProvider.notifier);
      if (quantity != item.quantity) {
        await pending.addQuantity(
            PendingQuantityChange(itemId: item.id, quantity: quantity));
      }
      if ((label?.id) != item.label?.id) {
        await pending.addCategory(
            PendingCategoryChange(itemId: item.id, labelId: label?.id));
      }
      // Umbenennung ebenfalls vormerken (früher wie in iOS verloren).
      // Offline kennt die Warteschlange keine Food-Verknüpfung — eine
      // Umbenennung auf ein Lebensmittel wird dort als Text-Umbenennung
      // nachgeholt (der Name stimmt, nur ohne Verknüpfung).
      if (relink) {
        await pending.addNote(PendingNoteChange(
          itemId: item.id,
          note: trimmed,
          clearFood: item.food != null,
          clearUnit: item.unitCarriesName,
        ));
      } else if (updated.note != item.note || renamedFoodItem) {
        await pending.addNote(PendingNoteChange(
          itemId: item.id,
          note: updated.note ?? '',
          clearFood: renamedFoodItem,
          clearUnit: renamedFoodItem && item.unitCarriesName,
        ));
      }
    }
  }

  // mirrors iOS deleteItem(_:)
  Future<void> deleteItem(String id) async {
    // Wenn dies ein lokal noch nicht synchronisierter Add ist, einfach das
    // Pending-Add wieder rauswerfen statt einen Delete-Pending zu schreiben.
    final pending = ref.read(pendingShoppingChangesProvider);
    final isPendingLocalAdd = pending.adds.any((a) => a.id == id);
    state.whenData(
        (list) => state = AsyncData(list.where((i) => i.id != id).toList()));
    await _persistLocalCache();
    if (isPendingLocalAdd) {
      await ref.read(pendingShoppingChangesProvider.notifier).removeAdd(id);
      return;
    }
    try {
      await ref.read(apiServiceProvider).deleteShoppingItem(id);
    } catch (e) {
      if (!isNetworkError(e)) {
        await refresh();
        return;
      }
      await ref
          .read(pendingShoppingChangesProvider.notifier)
          .addDelete(PendingDeleteChange(itemId: id));
    }
  }

  // mirrors iOS archiveList() — deletes checked items from API, removes locally
  Future<void> archiveCheckedItems() async {
    final items = state.valueOrNull;
    if (items == null) return;
    final checked = items.where((i) => i.checked).toList();
    if (checked.isEmpty) return;
    // Erst archivieren (dauerhaft, mit Listenname), dann lokal entfernen.
    String listName = '';
    final listId = ref.read(settingsProvider).valueOrNull?.shoppingListId;
    for (final m in ref.read(shoppingListsProvider).valueOrNull ?? const []) {
      if (m['id'] == listId) listName = shoppingListName(m);
    }
    // Nicht awaiten: die Liste soll sofort leer werden; das Archiv wartet
    // intern selbst auf seinen geladenen Stand.
    unawaited(ref
        .read(archivedShoppingListsProvider.notifier)
        .addPurchase(checked, listName: listName));
    state = AsyncData(items.where((i) => !i.checked).toList());
    await _persistLocalCache();
    // Am Server löschen — wie deleteItem offline-fest: ohne Netz als
    // ausstehende Änderung vormerken (vorher wurden Fehler verschluckt und
    // die Artikel tauchten beim nächsten Laden wieder abgehakt auf).
    final api = ref.read(apiServiceProvider);
    final pendingNotifier = ref.read(pendingShoppingChangesProvider.notifier);
    final pendingAdds = ref.read(pendingShoppingChangesProvider).adds;
    for (final item in checked) {
      if (pendingAdds.any((a) => a.id == item.id)) {
        await pendingNotifier.removeAdd(item.id);
        continue;
      }
      try {
        await api.deleteShoppingItem(item.id);
      } catch (e) {
        if (isNetworkError(e)) {
          await pendingNotifier.addDelete(PendingDeleteChange(itemId: item.id));
        }
      }
    }
    // Mealie entfernt dabei verwaiste „verknüpfte Rezepte" der Liste.
    unawaited(ref.read(shoppingListsProvider.notifier).refresh());
  }

  void _updateLocal(ShoppingItem updated) {
    state.whenData((list) {
      state =
          AsyncData(list.map((i) => i.id == updated.id ? updated : i).toList());
    });
  }

  void _appendLocal(ShoppingItem item) {
    state.whenData((list) => state = AsyncData([...list, item]));
  }

  // Hintergrund-Refresh ohne Loading-State-Flip.
  //
  // `refresh()` blendet die Liste über `state = AsyncLoading()` aus — das
  // ist richtig für Pull-to-Refresh, aber falsch direkt nach einem Add:
  // (a) der gerade lokal hinzugefügte Eintrag würde während des Fetches
  // unsichtbar werden, (b) Mealie liefert nach einem POST nicht garantiert
  // sofort die neue Liste zurück (Server-Cache / replication-lag), das
  // POST'ete Item wäre also bei einem stupiden `state = AsyncData(items)`
  // wieder weg.
  //
  // Lösung: Server-Liste holen + mit lokal noch nicht echo'ten Items
  // mergen. IDs, die der Server bereits zurückgibt, gewinnen (kanonischer
  // Stand); IDs, die nur lokal existieren, bleiben sichtbar bis der nächste
  // Refresh sie tatsächlich reflektiert.
  // Nach Mengen-/Edit-Änderungen die Smartwatch zuverlässig nachziehen: ein
  // debounced stilles Neuladen NACH dem Tap-Burst. Grund: mehrere schnelle
  // +/- Taps lösen rapide `updateApplicationContext`-Pushes aus, die iOS
  // rate-limited verwirft → die Uhr bleibt auf dem alten Wert. Ein sauberer
  // Push ~700 ms nach der letzten Änderung (wie das manuelle Neuladen)
  // synct die Uhr verlässlich. Cancelt vorherige Timer → nur ein Refresh.
  Timer? _watchResyncTimer;
  void _scheduleWatchResync() {
    _watchResyncTimer?.cancel();
    _watchResyncTimer = Timer(const Duration(milliseconds: 700), () {
      _silentRefresh();
    });
  }

  // Öffentlicher Wrapper für einen stillen Hintergrund-Refresh direkt beim
  // Öffnen des Shopping-Screens (initState) — holt den Server-Stand ohne den
  // AsyncLoading-Flip von refresh(), damit die (ggf. gecachte) Liste sofort
  // sichtbar bleibt und nur im Hintergrund aktualisiert wird. Vorher musste
  // man nach dem Öffnen manuell den Reload-Button/Pull-to-Refresh nutzen.
  Future<void> refreshOnOpen() => _silentRefresh();

  Future<void> _silentRefresh() async {
    final api = ref.read(apiServiceProvider);
    final currentListId =
        ref.read(settingsProvider).valueOrNull?.shoppingListId ?? '';
    try {
      final items = await api.fetchShoppingItems();
      final localCurrent = state.valueOrNull ?? const <ShoppingItem>[];
      final serverIds = items.map((i) => i.id).toSet();
      // Nur Items der AKTUELL aktiven Liste als „vom Server noch nicht
      // bestätigt" behandeln. Ohne diesen Filter überleben Artikel einer
      // vorher aktiven Liste (z. B. nach einem Listenwechsel in den
      // Settings, während dieser Fetch schon lief) fälschlich den Merge und
      // tauchen dann auf der neu ausgewählten Liste mit auf.
      final stillPendingLocal = localCurrent.where((i) =>
          !serverIds.contains(i.id) && i.shoppingListId == currentListId);
      final merged = [...items, ...stillPendingLocal];
      await LocalCache.saveShoppingItems(merged);
      _onLoadSuccess(merged);
      state = AsyncData(merged);
    } catch (_) {
      // Best effort — bei Netzwerkfehler den aktuellen UI-State lassen,
      // NICHT auf AsyncError flippen, sonst hätte das Add-Item-UX wieder
      // den gleichen Flicker den wir gerade fixen.
      _onLoadFailure();
    }
  }

  Future<void> _persistLocalCache() async {
    final list = state.valueOrNull;
    if (list != null) await LocalCache.saveShoppingItems(list);
  }

  // Erzeugt ein lokales Dummy-Item + PendingAddChange — 1:1 zu Swifts
  // Offline-Pfad in addManualIngredient / addIngredients.
  Future<void> _enqueuePendingAdd({
    required String listId,
    required String note,
    required ShoppingLabel? label,
    double quantity = 1,
  }) async {
    final localId = _newUuidV4();
    final dummy = ShoppingItem(
      id: localId,
      shoppingListId: listId,
      checked: false,
      note: note,
      label: label,
      quantity: quantity,
    );
    _appendLocal(dummy);
    await _persistLocalCache();
    await ref.read(pendingShoppingChangesProvider.notifier).addAdd(
        PendingAddChange(
            id: localId,
            note: note,
            labelId: label?.id,
            quantity: quantity,
            shoppingListId: listId));
  }

  // mirrors iOS syncPendingChangesToServer(selected…) — Reihenfolge identisch:
  //   1. Deletes  → Array leeren
  //   2. Adds     → Array leeren
  //   3. Check / Quantity / Category pro itemId zusammenfassen, EIN PUT
  //   4. Pending-Arrays leeren
  //   5. Cache + Server-Reload
  // Die `selected…`-Maps lassen den User pro Konflikt entscheiden, ob die
  // lokale Änderung angewendet wird (true/null → ja, false → Server-Stand
  // beibehalten). Default-Verhalten ist „lokale Änderung verwenden", was
  // Swifts `?? true`-Fallback entspricht.
  Future<void> syncPendingChangesToServer({
    Map<String, bool> selectedCheckChanges = const {},
    Map<String, bool> selectedQuantityChanges = const {},
    Map<String, bool> selectedCategoryChanges = const {},
    Map<String, bool> selectedNoteChanges = const {},
  }) async {
    final api = ref.read(apiServiceProvider);
    final pendingNotifier = ref.read(pendingShoppingChangesProvider.notifier);
    final pending = ref.read(pendingShoppingChangesProvider);

    // Scheitert eine Änderung erneut am NETZ (Verbindung bricht während des
    // Abgleichs ab), bleibt sie vorgemerkt und wird beim nächsten Abgleich
    // wiederholt — vorher wurde die Warteschlange trotzdem komplett geleert
    // und die offline gemachten Änderungen waren verloren. Lehnt der Server
    // dagegen endgültig ab (4xx, z. B. Artikel inzwischen gelöscht), fällt
    // sie weg: ein erneuter Versuch hätte dasselbe Ergebnis.
    final keepDeletes = <PendingDeleteChange>[];
    final keepAdds = <PendingAddChange>[];
    final failedItemIds = <String>{};

    // 1) Deletes
    for (final c in pending.deletes) {
      try {
        await api.deleteShoppingItem(c.itemId);
      } catch (e) {
        if (isNetworkError(e)) keepDeletes.add(c);
      }
    }
    await pendingNotifier.clearDeletes();
    for (final c in keepDeletes) {
      await pendingNotifier.addDelete(c);
    }

    // 2) Adds — jeweils in IHRE Liste (offline erfasst auf Liste A, danach
    // auf B gewechselt → gehört trotzdem auf A), wie _syncPendingAddsSilently.
    final settings = ref.read(settingsProvider).valueOrNull;
    final listId = settings?.shoppingListId ?? '';
    for (final c in pending.adds) {
      final target = c.shoppingListId.isNotEmpty ? c.shoppingListId : listId;
      if (target.isEmpty) continue;
      try {
        await api.addShoppingItem(ShoppingItemCreate(
          shoppingListId: target,
          note: c.note,
          quantity: c.quantity,
          labelId: c.labelId,
        ));
      } catch (e) {
        if (isNetworkError(e)) keepAdds.add(c);
      }
    }
    await pendingNotifier.clearAdds();
    for (final c in keepAdds) {
      await pendingNotifier.addAdd(c);
    }

    // 3) Updates pro itemId zusammenfassen (mirror Swift).
    final allChangedIds = <String>{
      ...pending.checks.map((c) => c.itemId),
      ...pending.quantities.map((c) => c.itemId),
      ...pending.categories.map((c) => c.itemId),
      ...pending.notes.map((c) => c.itemId),
    };
    final list = state.valueOrNull ?? const <ShoppingItem>[];
    for (final itemId in allChangedIds) {
      final base = list.firstWhere(
        (i) => i.id == itemId,
        orElse: () => const ShoppingItem(id: ''),
      );
      if (base.id.isEmpty) continue;
      var merged = base;
      final useCheck = selectedCheckChanges[itemId] ?? true;
      final useQty = selectedQuantityChanges[itemId] ?? true;
      final useCat = selectedCategoryChanges[itemId] ?? true;
      final useNote = selectedNoteChanges[itemId] ?? true;
      if (useNote) {
        for (final c in pending.notes) {
          if (c.itemId != itemId) continue;
          merged = merged.copyWith(
              note: c.note, clearFood: c.clearFood, clearUnit: c.clearUnit);
        }
      }
      if (useCheck) {
        final c = pending.checks.firstWhere(
          (c) => c.itemId == itemId,
          orElse: () =>
              PendingCheckChange(itemId: itemId, checked: base.checked),
        );
        merged = merged.copyWith(checked: c.checked);
      }
      if (useQty) {
        final q = pending.quantities.firstWhere(
          (c) => c.itemId == itemId,
          orElse: () => PendingQuantityChange(
              itemId: itemId, quantity: base.quantity ?? 1),
        );
        merged = merged.copyWith(quantity: q.quantity);
      }
      if (useCat) {
        final c = pending.categories.firstWhere(
          (c) => c.itemId == itemId,
          orElse: () =>
              PendingCategoryChange(itemId: itemId, labelId: base.label?.id),
        );
        // Label-Auflösung gegen aktuell bekannte Labels.
        ShoppingLabel? resolved;
        if (c.labelId != null) {
          final labels =
              ref.read(shoppingLabelsProvider).valueOrNull ?? const [];
          resolved = labels.firstWhere(
            (l) => l.id == c.labelId,
            orElse: () => ShoppingLabel(id: c.labelId!, name: '—'),
          );
        }
        merged = merged.copyWith(label: resolved, clearLabel: resolved == null);
      }
      try {
        await api.updateShoppingItem(merged);
      } catch (e) {
        if (isNetworkError(e)) failedItemIds.add(itemId);
      }
    }

    // 4) Pending leeren — außer den am Netz gescheiterten (siehe oben).
    await pendingNotifier.clearChecks();
    await pendingNotifier.clearQuantities();
    await pendingNotifier.clearCategories();
    await pendingNotifier.clearNotes();
    for (final c in pending.notes) {
      if (failedItemIds.contains(c.itemId)) await pendingNotifier.addNote(c);
    }
    for (final c in pending.checks) {
      if (failedItemIds.contains(c.itemId)) await pendingNotifier.addCheck(c);
    }
    for (final c in pending.quantities) {
      if (failedItemIds.contains(c.itemId)) {
        await pendingNotifier.addQuantity(c);
      }
    }
    for (final c in pending.categories) {
      if (failedItemIds.contains(c.itemId)) {
        await pendingNotifier.addCategory(c);
      }
    }

    // 5) Cache + Server-Reload
    await _persistLocalCache();
    await refresh();
  }

  // Lokaler UUID v4 — wir vermeiden ein neues Paket (uuid) und bauen den
  // String aus dart:math.Random.secure selbst, wie Swift es mit UUID() macht.
  String _newUuidV4() {
    final b = List<int>.generate(16, (_) => _uuidRandom.nextInt(256));
    b[6] = (b[6] & 0x0f) | 0x40; // Version 4
    b[8] = (b[8] & 0x3f) | 0x80; // Variant 1
    String hex(int n) => n.toRadixString(16).padLeft(2, '0');
    final h = b.map(hex).join();
    return '${h.substring(0, 8)}-${h.substring(8, 12)}-'
        '${h.substring(12, 16)}-${h.substring(16, 20)}-${h.substring(20)}';
  }
}

final Random _uuidRandom = Random.secure();

class _AmbiguousRecipePost implements Exception {
  final Object cause;
  _AmbiguousRecipePost(this.cause);
  @override
  String toString() => cause.toString();
}

/// Einfacher Modus: was schon auf der Liste steht (offen ODER abgehakt) bzw.
/// in dieser Übernahme schon vorkommt, kommt nicht nochmal dazu — gleiche
/// Regel wie bisher (Name, ohne Groß/Klein), zusätzlich gleiches
/// Lebensmittel (der Server würde offene Artikel sonst zu „2×" addieren).
class _AusDedupe {
  final Set<String> _names;
  final Set<String> _foodIds;

  _AusDedupe(List<ShoppingItem> existing)
      : _names = {for (final i in existing) i.displayName.trim().toLowerCase()},
        _foodIds = {
          for (final i in existing)
            if (!i.checked && (i.food?.id ?? '').isNotEmpty) i.food!.id!,
        };

  /// true = neu, darf auf die Liste (und ist ab jetzt vergeben).
  bool claim(String name, String? foodId) {
    final key = name.trim().toLowerCase();
    if (_names.contains(key)) return false;
    if (foodId != null && _foodIds.contains(foodId)) return false;
    _names.add(key);
    if (foodId != null) _foodIds.add(foodId);
    return true;
  }
}
