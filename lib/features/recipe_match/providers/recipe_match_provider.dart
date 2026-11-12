import 'dart:convert';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/widgets/multi_select_sheet.dart' show SelectItem;
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Rezept-Match (Kachel in „Weiteres") — Kartenstapel aus dem Rezept-Cache.
// Nach oben wischen = nächste Karte (wandert ans Ende), nach unten aufs
// „Tablett" ziehen = merken. Vom Tablett aus in den Essensplan oder (mit
// Zutaten-Auswahl) auf die Einkaufsliste.
//
// Alles nur lokal (SharedPreferences): Reihenfolge des Stapels, Tablett,
// Filter. Aufgelöst gegen den Rezept-Cache → offline nutzbar; gelöschte
// Rezepte fallen einfach weg.
// ---------------------------------------------------------------------------

const _kOrder = 'recipe_match_order';
const _kTray = 'recipe_match_tray';
const _kFilters = 'recipe_match_filters';

/// Wählbare Höchstdauern (Minuten), `null` = jede Dauer.
const kRecipeMatchMaxTimes = <int?>[null, 30, 60];

class RecipeMatchFilters {
  final List<SelectItem> categories;
  final List<SelectItem> tags;
  final int? maxMinutes;
  const RecipeMatchFilters({
    this.categories = const [],
    this.tags = const [],
    this.maxMinutes,
  });

  int get count =>
      categories.length + tags.length + (maxMinutes == null ? 0 : 1);

  /// Kategorien UND Schlagworte jeweils „irgendeines davon"; ohne
  /// hinterlegte Gesamtzeit fällt ein Rezept bei gesetzter Höchstdauer raus.
  bool matches(RecipeDetail r) {
    if (categories.isNotEmpty &&
        !r.recipeCategory.any((c) => categories.any((s) => s.id == c.id))) {
      return false;
    }
    if (tags.isNotEmpty && !r.tags.any((t) => tags.any((s) => s.id == t.id))) {
      return false;
    }
    final max = maxMinutes;
    if (max != null) {
      final total = r.totalTime ?? 0;
      if (total <= 0 || total > max) return false;
    }
    return true;
  }

  RecipeMatchFilters copyWith({
    List<SelectItem>? categories,
    List<SelectItem>? tags,
    int? Function()? maxMinutes,
  }) =>
      RecipeMatchFilters(
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
        maxMinutes: maxMinutes != null ? maxMinutes() : this.maxMinutes,
      );

  Map<String, dynamic> toJson() => {
        'categories': [
          for (final c in categories) {'id': c.id, 'name': c.name}
        ],
        'tags': [
          for (final t in tags) {'id': t.id, 'name': t.name}
        ],
        'maxMinutes': maxMinutes,
      };

  static List<SelectItem> _items(dynamic raw) => [
        for (final e in (raw is List ? raw : const []))
          if (e is Map && e['id'] is String)
            (id: e['id'] as String, name: (e['name'] as String?) ?? ''),
      ];

  factory RecipeMatchFilters.fromJson(Map<String, dynamic> j) =>
      RecipeMatchFilters(
        categories: _items(j['categories']),
        tags: _items(j['tags']),
        maxMinutes: (j['maxMinutes'] as num?)?.toInt(),
      );
}

class RecipeMatchState {
  /// Alle Rezept-IDs in Stapel-Reihenfolge (gemischt). Gefiltert wird erst
  /// beim Anzeigen ([deck]) — Filter ändern verliert die Reihenfolge nicht.
  final List<String> order;

  /// Gemerkte Rezepte, in Ablage-Reihenfolge.
  final List<String> tray;

  /// Portionen-Faktor je Rezept (Rückseite der Karte) — nur für die
  /// laufende Sitzung, geht an die Einkaufsliste weiter.
  final Map<String, double> scales;

  final RecipeMatchFilters filters;

  const RecipeMatchState({
    this.order = const [],
    this.tray = const [],
    this.scales = const {},
    this.filters = const RecipeMatchFilters(),
  });

  RecipeMatchState copyWith({
    List<String>? order,
    List<String>? tray,
    Map<String, double>? scales,
    RecipeMatchFilters? filters,
  }) =>
      RecipeMatchState(
        order: order ?? this.order,
        tray: tray ?? this.tray,
        scales: scales ?? this.scales,
        filters: filters ?? this.filters,
      );

  double scaleOf(String id) => scales[id] ?? 1;

  /// Sichtbarer Stapel: Reihenfolge, ohne Tablett, nur passende Rezepte.
  List<RecipeDetail> deck(List<RecipeDetail> all) {
    final byId = {for (final r in all) r.id: r};
    final onTray = tray.toSet();
    return [
      for (final id in order)
        if (!onTray.contains(id) &&
            byId[id] != null &&
            filters.matches(byId[id]!))
          byId[id]!,
    ];
  }

  /// Tablett gegen den Rezept-Cache aufgelöst.
  List<RecipeDetail> trayRecipes(List<RecipeDetail> all) {
    final byId = {for (final r in all) r.id: r};
    return [
      for (final id in tray)
        if (byId[id] != null) byId[id]!,
    ];
  }
}

final recipeMatchProvider =
    NotifierProvider<RecipeMatchNotifier, RecipeMatchState>(
        RecipeMatchNotifier.new);

class RecipeMatchNotifier extends Notifier<RecipeMatchState> {
  final _random = Random();
  bool _loaded = false;

  @override
  RecipeMatchState build() {
    ref.listen(recipesProvider, (_, next) {
      final all = next.valueOrNull;
      if (all != null) _sync(all);
    });
    _load();
    return const RecipeMatchState();
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var filters = const RecipeMatchFilters();
      final rawFilters = prefs.getString(_kFilters);
      if (rawFilters != null) {
        final j = jsonDecode(rawFilters);
        if (j is Map<String, dynamic>) filters = RecipeMatchFilters.fromJson(j);
      }
      state = state.copyWith(
        order: prefs.getStringList(_kOrder) ?? state.order,
        tray: [
          ...state.tray,
          ...(prefs.getStringList(_kTray) ?? const <String>[])
              .where((id) => !state.tray.contains(id)),
        ],
        filters: filters,
      );
    } catch (_) {}
    _loaded = true;
    final all = ref.read(recipesProvider).valueOrNull;
    if (all != null) _sync(all);
  }

  /// Neue Rezepte gemischt hinten anhängen, gelöschte entfernen. Erst nach
  /// dem Laden — sonst würde die gespeicherte Reihenfolge überschrieben.
  void _sync(List<RecipeDetail> all) {
    if (!_loaded) return;
    final ids = {for (final r in all) r.id};
    final known = state.order.where(ids.contains).toList();
    final knownSet = known.toSet();
    final fresh = ids.where((id) => !knownSet.contains(id)).toList()
      ..shuffle(_random);
    final tray = state.tray.where(ids.contains).toList();
    if (fresh.isEmpty &&
        known.length == state.order.length &&
        tray.length == state.tray.length) {
      return;
    }
    state = state.copyWith(order: [...known, ...fresh], tray: tray);
    _save();
  }

  /// Nach oben gewischt: Karte ans Ende des Stapels.
  void next(String id) {
    state = state.copyWith(order: [
      ...state.order.where((x) => x != id),
      id,
    ]);
    _save();
  }

  /// Aufs Tablett gelegt. Die Karte wandert zugleich ans Ende des Stapels,
  /// damit sie nach dem Abräumen nicht sofort wieder oben liegt.
  void keep(String id) {
    if (state.tray.contains(id)) return;
    state = state.copyWith(
      tray: [...state.tray, id],
      order: [...state.order.where((x) => x != id), id],
    );
    _save();
  }

  /// „Rückgängig" nach dem Ablegen: vom Tablett zurück oben auf den Stapel.
  void restoreToTop(String id) {
    state = state.copyWith(
      tray: state.tray.where((x) => x != id).toList(),
      order: [id, ...state.order.where((x) => x != id)],
    );
    _save();
  }

  void removeFromTray(String id) {
    state = state.copyWith(tray: state.tray.where((x) => x != id).toList());
    _save();
  }

  void removeManyFromTray(Iterable<String> ids) {
    final drop = ids.toSet();
    state = state.copyWith(
        tray: state.tray.where((x) => !drop.contains(x)).toList());
    _save();
  }

  void clearTray() {
    state = state.copyWith(tray: const [], scales: const {});
    _save();
  }

  void setScale(String id, double scale) {
    state = state.copyWith(scales: {...state.scales, id: scale});
  }

  void shuffle() {
    state = state.copyWith(order: List.of(state.order)..shuffle(_random));
    _save();
  }

  void setFilters(RecipeMatchFilters filters) {
    state = state.copyWith(filters: filters);
    _save();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_kOrder, state.order);
      await prefs.setStringList(_kTray, state.tray);
      await prefs.setString(_kFilters, jsonEncode(state.filters.toJson()));
    } catch (_) {}
  }
}
