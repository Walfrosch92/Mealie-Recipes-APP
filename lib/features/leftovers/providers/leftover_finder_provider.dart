import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../../core/utils/cookbook_query_filter.dart';
import '../../../core/utils/query_filter_eval.dart';
import '../../organizers/providers/organizers_provider.dart';
import '../../recipes/providers/recipes_provider.dart';
import '../../shopping_list/providers/foods_units_provider.dart';

// ---------------------------------------------------------------------------
// Rezept-Suche — Nachbau der Mealie-Webapp-Seite „Rezept-Suche"
// (frontend/app/pages/g/[groupSlug]/recipes/finder). Ersetzt die frühere
// Freitext-„Resteverwertung".
//
// Wie in Mealie: Lebensmittel und Utensilien aus den Server-Katalogen
// auswählen; die Suche läuft über GET /api/recipes/suggestions mit denselben
// Einstellungen (max. fehlende Zutaten/Utensilien, Vorrätiges und
// Alternativen einbeziehen). Treffer werden in „Bereit zu Machen" (nichts
// fehlt) und „Fast bereit zu Machen" aufgeteilt. Auswahl und Einstellungen
// bleiben gespeichert (Mealie: localStorage).
//
// Offline bzw. bei Servern ohne diese Schnittstelle rechnet die App dieselben
// Regeln (Mealie `_recipe_suggestions.py`) über den lokalen Rezept-Cache nach
// — nur Alternativen kann sie dort nicht auswerten.
// ---------------------------------------------------------------------------

/// Lebensmittel bzw. Utensil, wie es in der Rezept-Suche angezeigt wird.
class FinderItem {
  final String id;
  final String name;
  const FinderItem(this.id, this.name);

  /// Mealie zeigt Lebensmittel mit Pluralname, falls vorhanden.
  static FinderItem? food(Map<String, dynamic>? m) {
    final id = m?['id']?.toString();
    if (id == null || id.isEmpty) return null;
    final plural = (m!['pluralName'] as String?)?.trim() ?? '';
    final name = plural.isNotEmpty ? plural : (m['name'] as String?) ?? '';
    return FinderItem(id, name.trim());
  }

  static FinderItem? tool(Map<String, dynamic>? m) {
    final id = m?['id']?.toString();
    if (id == null || id.isEmpty) return null;
    return FinderItem(id, ((m!['name'] as String?) ?? '').trim());
  }

  @override
  bool operator ==(Object other) => other is FinderItem && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class FinderSubstitution {
  final FinderItem food;
  final FinderItem substitute;
  const FinderSubstitution(this.food, this.substitute);
}

class FinderSuggestion {
  final String recipeId;
  final String name;
  final List<FinderItem> missingFoods;
  final List<FinderItem> missingTools;
  final List<FinderSubstitution> substitutedFoods;

  const FinderSuggestion({
    required this.recipeId,
    required this.name,
    this.missingFoods = const [],
    this.missingTools = const [],
    this.substitutedFoods = const [],
  });

  bool get readyToMake => missingFoods.isEmpty && missingTools.isEmpty;

  static FinderSuggestion? fromJson(Map<String, dynamic> m) {
    final recipe = (m['recipe'] as Map?)?.cast<String, dynamic>();
    final id = recipe?['id']?.toString();
    if (recipe == null || id == null || id.isEmpty) return null;
    List<Map<String, dynamic>> maps(Object? raw) => [
          for (final e in (raw as List?) ?? const [])
            if (e is Map) e.cast<String, dynamic>(),
        ];
    return FinderSuggestion(
      recipeId: id,
      name: (recipe['name'] as String?) ?? '',
      missingFoods: maps(m['missingFoods'])
          .map(FinderItem.food)
          .whereType<FinderItem>()
          .toList(),
      missingTools: maps(m['missingTools'])
          .map(FinderItem.tool)
          .whereType<FinderItem>()
          .toList(),
      substitutedFoods: [
        for (final s in maps(m['substitutedFoods']))
          if ((
            FinderItem.food((s['food'] as Map?)?.cast<String, dynamic>()),
            FinderItem.food(
                (s['substituteFood'] as Map?)?.cast<String, dynamic>()),
          )
              case (final food?, final substitute?))
            FinderSubstitution(food, substitute),
      ],
    );
  }
}

/// Auswahl + Einstellungen — Standardwerte wie Mealie-Web
/// (useRecipeFinderPreferences).
class FinderPrefs {
  final List<FinderItem> foods;
  final List<FinderItem> tools;
  final int maxMissingFoods;
  final int maxMissingTools;
  final bool includeFoodsOnHand;
  final bool includeToolsOnHand;
  final bool includeSubstitutions;

  /// Mealie „Andere Filter" (Query-Filter-String, wie die Webapp).
  final String queryFilter;

  const FinderPrefs({
    this.foods = const [],
    this.tools = const [],
    this.maxMissingFoods = 20,
    this.maxMissingTools = 20,
    this.includeFoodsOnHand = true,
    this.includeToolsOnHand = true,
    this.includeSubstitutions = true,
    this.queryFilter = '',
  });

  /// Wie Mealie: gesucht wird, sobald Lebensmittel, Utensilien ODER andere
  /// Filter gesetzt sind.
  bool get hasSelection =>
      foods.isNotEmpty || tools.isNotEmpty || queryFilter.isNotEmpty;

  FinderPrefs copyWith({
    List<FinderItem>? foods,
    List<FinderItem>? tools,
    int? maxMissingFoods,
    int? maxMissingTools,
    bool? includeFoodsOnHand,
    bool? includeToolsOnHand,
    bool? includeSubstitutions,
    String? queryFilter,
  }) =>
      FinderPrefs(
        foods: foods ?? this.foods,
        tools: tools ?? this.tools,
        // normalizeMissingItemLimit: nie negativ.
        maxMissingFoods:
            (maxMissingFoods ?? this.maxMissingFoods).clamp(0, 999),
        maxMissingTools:
            (maxMissingTools ?? this.maxMissingTools).clamp(0, 999),
        includeFoodsOnHand: includeFoodsOnHand ?? this.includeFoodsOnHand,
        includeToolsOnHand: includeToolsOnHand ?? this.includeToolsOnHand,
        includeSubstitutions: includeSubstitutions ?? this.includeSubstitutions,
        queryFilter: queryFilter ?? this.queryFilter,
      );

  Map<String, dynamic> toJson() => {
        'foods': [
          for (final f in foods) {'id': f.id, 'name': f.name}
        ],
        'tools': [
          for (final t in tools) {'id': t.id, 'name': t.name}
        ],
        'maxMissingFoods': maxMissingFoods,
        'maxMissingTools': maxMissingTools,
        'includeFoodsOnHand': includeFoodsOnHand,
        'includeToolsOnHand': includeToolsOnHand,
        'includeSubstitutions': includeSubstitutions,
        'queryFilter': queryFilter,
      };

  static FinderPrefs fromJson(Map<String, dynamic> m) {
    List<FinderItem> items(Object? raw) => [
          for (final e in (raw as List?) ?? const [])
            if (e is Map && (e['id']?.toString() ?? '').isNotEmpty)
              FinderItem(e['id'].toString(), (e['name'] ?? '').toString()),
        ];
    const d = FinderPrefs();
    return FinderPrefs(
      foods: items(m['foods']),
      tools: items(m['tools']),
      maxMissingFoods: (m['maxMissingFoods'] as int?) ?? d.maxMissingFoods,
      maxMissingTools: (m['maxMissingTools'] as int?) ?? d.maxMissingTools,
      includeFoodsOnHand:
          (m['includeFoodsOnHand'] as bool?) ?? d.includeFoodsOnHand,
      includeToolsOnHand:
          (m['includeToolsOnHand'] as bool?) ?? d.includeToolsOnHand,
      includeSubstitutions:
          (m['includeSubstitutions'] as bool?) ?? d.includeSubstitutions,
      queryFilter: (m['queryFilter'] as String?) ?? '',
    );
  }
}

class RecipeFinderState {
  final FinderPrefs prefs;
  final bool loading;
  final List<FinderSuggestion> results;

  /// Ergebnisse aus dem lokalen Cache (Server nicht erreichbar).
  final bool offline;

  /// Offline: „Andere Filter" lagen nicht in der einfachen Zeilenform vor
  /// (Roh-Text mit OR/Klammern) und wurden deshalb nicht angewendet.
  final bool filterIgnored;

  const RecipeFinderState({
    this.prefs = const FinderPrefs(),
    this.loading = false,
    this.results = const [],
    this.offline = false,
    this.filterIgnored = false,
  });

  RecipeFinderState copyWith({
    FinderPrefs? prefs,
    bool? loading,
    List<FinderSuggestion>? results,
    bool? offline,
    bool? filterIgnored,
  }) =>
      RecipeFinderState(
        prefs: prefs ?? this.prefs,
        loading: loading ?? this.loading,
        results: results ?? this.results,
        offline: offline ?? this.offline,
        filterIgnored: filterIgnored ?? this.filterIgnored,
      );
}

const _kPrefsKey = 'recipe_finder_prefs';

/// Wie die Webapp: höchstens 20 Vorschläge.
const _kLimit = 20;

final recipeFinderProvider =
    NotifierProvider<RecipeFinderNotifier, RecipeFinderState>(
        RecipeFinderNotifier.new);

class RecipeFinderNotifier extends Notifier<RecipeFinderState> {
  Timer? _debounce;
  int _generation = 0;

  @override
  RecipeFinderState build() {
    ref.onDispose(() => _debounce?.cancel());
    unawaited(_restore());
    return const RecipeFinderState();
  }

  Future<void> _restore() async {
    final saved = await LocalCache.loadJsonList(_kPrefsKey);
    if (saved.isEmpty) return;
    _update(FinderPrefs.fromJson(saved.first), save: false);
  }

  void _update(FinderPrefs prefs, {bool save = true}) {
    state = state.copyWith(prefs: prefs, loading: prefs.hasSelection);
    if (save) unawaited(LocalCache.saveJsonList(_kPrefsKey, [prefs.toJson()]));
    _debounce?.cancel();
    if (!prefs.hasSelection) {
      _generation++;
      state = state.copyWith(results: const [], loading: false, offline: false);
      return;
    }
    // Wie Mealie (watchDebounced 500 ms): mehrere schnelle Änderungen →
    // nur eine Suche.
    _debounce = Timer(const Duration(milliseconds: 500), _search);
  }

  // ── Auswahl ──
  List<FinderItem> _sorted(List<FinderItem> items) => List.of(items)
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  void setFoods(List<FinderItem> foods) =>
      _update(state.prefs.copyWith(foods: _sorted(foods)));

  void setTools(List<FinderItem> tools) =>
      _update(state.prefs.copyWith(tools: _sorted(tools)));

  void addFood(FinderItem f) {
    if (state.prefs.foods.contains(f)) return;
    setFoods([...state.prefs.foods, f]);
  }

  void removeFood(FinderItem f) =>
      setFoods(state.prefs.foods.where((x) => x != f).toList());

  void addTool(FinderItem t) {
    if (state.prefs.tools.contains(t)) return;
    setTools([...state.prefs.tools, t]);
  }

  void removeTool(FinderItem t) =>
      setTools(state.prefs.tools.where((x) => x != t).toList());

  void clearSelection() =>
      _update(state.prefs.copyWith(foods: const [], tools: const []));

  void setQueryFilter(String q) =>
      _update(state.prefs.copyWith(queryFilter: q.trim()));

  void updateSettings(FinderPrefs Function(FinderPrefs p) change) =>
      _update(change(state.prefs));

  /// Erneut suchen (Pull-to-Refresh).
  Future<void> refresh() async {
    if (!state.prefs.hasSelection) return;
    _debounce?.cancel();
    await _search();
  }

  // ── Suche ──
  Future<void> _search() async {
    final gen = ++_generation;
    final p = state.prefs;
    state = state.copyWith(loading: true);
    List<FinderSuggestion> results;
    var offline = false;
    var filterIgnored = false;
    try {
      final raw = await ref.read(apiServiceProvider).fetchRecipeSuggestions(
        foodIds: [for (final f in p.foods) f.id],
        toolIds: [for (final t in p.tools) t.id],
        maxMissingFoods: p.maxMissingFoods,
        maxMissingTools: p.maxMissingTools,
        includeFoodsOnHand: p.includeFoodsOnHand,
        includeToolsOnHand: p.includeToolsOnHand,
        includeSubstitutions: p.includeSubstitutions,
        queryFilter: p.queryFilter,
        limit: _kLimit,
      );
      results = raw
          .map(FinderSuggestion.fromJson)
          .whereType<FinderSuggestion>()
          .toList();
    } catch (e) {
      LogManager.shared.log('🔎 Rezept-Suche über Server fehlgeschlagen, '
          'rechne lokal: $e');
      final rows = tryParseCookbookQueryFilter(p.queryFilter);
      filterIgnored = rows == null;
      results = await _searchLocally(p, rows ?? const []);
      offline = true;
    }
    if (gen != _generation) return; // inzwischen neue Auswahl
    state = state.copyWith(
        results: results,
        loading: false,
        offline: offline,
        filterIgnored: filterIgnored);
  }

  /// Lokaler Nachbau von Mealie `find_suggested_recipes` (ohne Alternativen).
  Future<List<FinderSuggestion>> _searchLocally(
      FinderPrefs p, List<CookbookFilterRow> filterRows) async {
    final recipes = ref.read(recipesProvider).valueOrNull ?? const [];
    String? slug;
    try {
      slug = await ref.read(ownHouseholdSlugProvider.future);
    } catch (_) {}
    var foodsCatalog = const <ShoppingFood>[];
    var toolsCatalog = const <OrganizerItem>[];
    try {
      foodsCatalog = await ref.read(foodsCatalogProvider.future);
    } catch (_) {}
    try {
      toolsCatalog =
          await ref.read(organizersProvider(OrganizerKind.tool).future);
    } catch (_) {}

    final userFoods = {for (final f in p.foods) f.id};
    final userTools = {for (final t in p.tools) t.id};
    final haveFoods = {
      ...userFoods,
      if (p.includeFoodsOnHand)
        for (final f in foodsCatalog)
          if (f.id != null && f.isOnHandIn(slug)) f.id!,
    };
    final haveTools = {
      ...userTools,
      if (p.includeToolsOnHand && slug != null)
        for (final t in toolsCatalog)
          if (t.householdsWithTool.contains(slug)) t.id,
    };

    final foodLabelIds = {
      for (final f in foodsCatalog)
        if (f.id != null && (f.labelId ?? '').isNotEmpty) f.id!: f.labelId!,
    };
    final scored = <(RecipeDetail, int, int, int, FinderSuggestion)>[];
    for (final r in recipes) {
      if (!recipeMatchesQueryRows(r, filterRows, foodLabelIds: foodLabelIds)) {
        continue;
      }
      final missingTools = <FinderItem>[];
      var unmatchedTools = 0;
      if (userTools.isNotEmpty) {
        final seen = <String>{};
        for (final t in r.tools) {
          if (t.id.isEmpty || haveTools.contains(t.id)) continue;
          unmatchedTools++;
          if (seen.add(t.id)) missingTools.add(FinderItem(t.id, t.name));
        }
        if (unmatchedTools > p.maxMissingTools) continue;
      }
      final missingFoods = <FinderItem>[];
      var unmatchedFoods = 0;
      var userMatches = 0;
      if (userFoods.isNotEmpty) {
        final seen = <String>{};
        for (final ing in r.recipeIngredient) {
          final id = ing.food?.id;
          if (id == null || id.isEmpty) continue;
          if (userFoods.contains(id)) userMatches++;
          if (haveFoods.contains(id)) continue;
          unmatchedFoods++;
          if (seen.add(id)) {
            final plural = ing.food?.pluralName?.trim() ?? '';
            missingFoods.add(FinderItem(id,
                plural.isNotEmpty ? plural : (ing.food?.name ?? '').trim()));
          }
        }
        if (unmatchedFoods > p.maxMissingFoods) continue;
        // Nur Rezepte mit mindestens einer ausgewählten Zutat.
        if (userMatches == 0) continue;
      }
      scored.add((
        r,
        unmatchedTools,
        unmatchedFoods,
        userMatches,
        FinderSuggestion(
          recipeId: r.id,
          name: r.name,
          missingFoods: missingFoods,
          missingTools: missingTools,
        ),
      ));
    }
    // Reihenfolge wie der Server: fehlende Utensilien ↑, fehlende Zutaten ↑,
    // Treffer der Auswahl ↓, dann neueste zuerst.
    scored.sort((a, b) {
      var c = a.$2.compareTo(b.$2);
      if (c != 0) return c;
      c = a.$3.compareTo(b.$3);
      if (c != 0) return c;
      c = b.$4.compareTo(a.$4);
      if (c != 0) return c;
      return (b.$1.dateAdded ?? '').compareTo(a.$1.dateAdded ?? '');
    });
    return [for (final s in scored.take(_kLimit)) s.$5];
  }
}
