import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/cookbook_summary.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/services/local_cache.dart';
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Cookbooks — Liste der Haushalts-Kochbücher + aufgelöste Rezeptlisten.
//
// Ein Kochbuch ist eine serverseitig gespeicherte Query (queryFilterString),
// KEIN Organizer am Rezept. Der Filter kann Dimensionen enthalten, die die
// App lokal nicht kennt (households, foods, last_made, …) — darum wird er
// opak an GET /api/recipes?queryFilter=… durchgereicht statt ihn auf den
// lokalen RecipeFilter abzubilden.
// ---------------------------------------------------------------------------

final cookbooksProvider =
    AsyncNotifierProvider<CookbooksNotifier, List<CookbookSummary>>(
        CookbooksNotifier.new);

class CookbooksNotifier extends AsyncNotifier<List<CookbookSummary>> {
  // Cache-first + Hintergrund-Refresh — Muster wie shoppingLabelsProvider:
  // die Übersicht rendert sofort aus dem Cache, der Server-Stand ersetzt sie
  // lautlos, sobald er da ist. Ohne Cache (Erstbesuch) direkter Fetch; ein
  // Fehler propagiert dann als AsyncError (Screen zeigt Retry).
  @override
  Future<List<CookbookSummary>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadCookbooks();
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          final fresh = _sorted(await api.fetchCookbooks());
          await LocalCache.saveCookbooks(fresh);
          state = AsyncData(fresh);
        } catch (_) {/* offline → Cache behalten */}
      });
      return _sorted(cached);
    }
    final fresh = _sorted(await api.fetchCookbooks());
    await LocalCache.saveCookbooks(fresh);
    return fresh;
  }

  Future<void> reload() async {
    state = await AsyncValue.guard(() async {
      final api = ref.read(apiServiceProvider);
      final fresh = _sorted(await api.fetchCookbooks());
      await LocalCache.saveCookbooks(fresh);
      return fresh;
    });
  }

  // Webapp-Reihenfolge: nach `position` (client-seitig — ein
  // orderBy=position lehnen manche Mealie-Versionen ab).
  List<CookbookSummary> _sorted(List<CookbookSummary> list) {
    return List<CookbookSummary>.of(list)
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  // ── CRUD — Gegenstück zur Webapp „Ein Kochbuch erstellen/bearbeiten" ─────

  Future<CookbookSummary> create({
    required String name,
    String? description,
    String queryFilterString = '',
    bool public = false,
  }) async {
    final api = ref.read(apiServiceProvider);
    final created = await api.createCookbook(
      name: name,
      description: description,
      queryFilterString: queryFilterString,
      public: public,
    );
    await reload();
    return created;
  }

  // Nicht `update` genannt — kollidiert sonst mit AsyncNotifierBase.update
  // (Riverpods eingebauter Callback-State-Update-Methode).
  Future<void> updateCookbook(CookbookSummary cookbook) async {
    final api = ref.read(apiServiceProvider);
    await api.updateCookbook(cookbook);
    await reload();
  }

  Future<void> delete(String id) async {
    final api = ref.read(apiServiceProvider);
    await api.deleteCookbook(id);
    await reload();
  }
}

// ---------------------------------------------------------------------------
// Rezept-IDs eines Kochbuchs — OFFLINE-FIRST (gleiches Muster wie überall in
// der App): gecachte ID-Liste sofort zurückgeben, im Hintergrund den
// queryFilter frisch vom Server auflösen und nur bei Änderung nachziehen;
// schlägt der Abgleich fehl (offline), bleibt der Cache-Stand stehen.
// Nur beim ALLERERSTEN Öffnen (kein Cache) braucht es den Server — ein
// Fehler dort propagiert als AsyncError (Screen zeigt Retry).
//
// Details werden hier NICHT pro Rezept geladen (kein N+1): die Auflösung
// ID→RecipeDetail passiert reaktiv in cookbookRecipesProvider gegen den
// zentralen recipesProvider. Lokal fehlende Details (z. B. brandneue
// Rezepte) werden in kleinen Batches nachgeholt und per upsertOne in
// Liste + File-Cache eingepflegt — damit sind sie danach ebenfalls offline
// verfügbar.
// ---------------------------------------------------------------------------

final cookbookRecipeIdsProvider = AsyncNotifierProviderFamily<
    CookbookRecipeIdsNotifier,
    List<String>,
    String>(CookbookRecipeIdsNotifier.new);

class CookbookRecipeIdsNotifier
    extends FamilyAsyncNotifier<List<String>, String> {
  @override
  Future<List<String>> build(String cookbookId) async {
    ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadCookbookRecipeIds(cookbookId);
    if (cached != null) {
      Future.microtask(_refreshFromServer);
      return cached;
    }
    return _fetchAndCache();
  }

  /// Pull-to-Refresh: Server-Stand holen, ohne die Liste vorher in den
  /// Loading-State zu kippen; offline → aktueller Stand bleibt sichtbar.
  Future<void> reload() => _refreshFromServer();

  Future<void> _refreshFromServer() async {
    try {
      final fresh = await _fetchAndCache();
      final current = state.valueOrNull;
      // Nur bei tatsächlicher Änderung schreiben — kein Flackern, wenn der
      // Server dieselbe Liste liefert (Muster wie _reconcileWithServer).
      if (current == null || !listEquals(current, fresh)) {
        state = AsyncData(fresh);
      }
    } catch (_) {/* offline / Server nicht erreichbar → Cache behalten */}
  }

  Future<List<String>> _fetchAndCache() async {
    final api = ref.read(apiServiceProvider);
    final cookbooks = await ref.read(cookbooksProvider.future);
    CookbookSummary? cookbook;
    for (final c in cookbooks) {
      if (c.id == arg) {
        cookbook = c;
        break;
      }
    }
    if (cookbook == null) return const [];

    final summaries =
        await api.fetchRecipeSummariesByQueryFilter(cookbook.queryFilterString);
    final ids = summaries.map((s) => s.id).toList();
    await LocalCache.saveCookbookRecipeIds(arg, ids);
    await _ensureDetailsLoaded(ids);
    return ids;
  }

  /// Lädt Details nach, die im zentralen recipesProvider (noch) fehlen —
  /// in 5er-Batches statt unbegrenzt parallel. upsertOne legt sie in
  /// Liste + File-Cache ab → auch offline wieder auflösbar.
  Future<void> _ensureDetailsLoaded(List<String> ids) async {
    final api = ref.read(apiServiceProvider);
    final loaded =
        ref.read(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
    final known = loaded.map((r) => r.id).toSet();
    final missing = ids.where((id) => !known.contains(id)).toList();

    Future<RecipeDetail?> fetchOrNull(String id) async {
      try {
        return await api.fetchRecipeDetail(id);
      } catch (_) {
        return null;
      }
    }

    const batchSize = 5;
    for (var start = 0; start < missing.length; start += batchSize) {
      final end = (start + batchSize) > missing.length
          ? missing.length
          : (start + batchSize);
      final fetched = await Future.wait([
        for (var i = start; i < end; i++) fetchOrNull(missing[i]),
      ]);
      for (final d in fetched.whereType<RecipeDetail>()) {
        await ref.read(recipesProvider.notifier).upsertOne(d);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Aufgelöste Rezeptliste eines Kochbuchs — reine synchrone Kombination aus
// ID-Liste und zentralem recipesProvider. Reagiert auf BEIDES: neue IDs vom
// Hintergrund-Abgleich UND aktualisierte/nachgeladene Details (z. B. während
// des inkrementellen Cold-Loads füllt sich die Liste sichtbar auf).
// ---------------------------------------------------------------------------

final cookbookRecipesProvider =
    Provider.family<AsyncValue<List<RecipeDetail>>, String>((ref, cookbookId) {
  final idsAsync = ref.watch(cookbookRecipeIdsProvider(cookbookId));
  final details =
      ref.watch(recipesProvider).valueOrNull ?? const <RecipeDetail>[];
  return idsAsync.whenData((ids) {
    final byId = {for (final r in details) r.id: r};
    final resolved = <RecipeDetail>[
      for (final id in ids)
        if (byId.containsKey(id)) byId[id]!,
    ];
    resolved
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return resolved;
  });
});
