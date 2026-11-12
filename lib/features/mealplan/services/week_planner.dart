import 'dart:math';

import '../../../core/models/recipe_detail.dart';
import '../../../shared/widgets/multi_select_sheet.dart' show SelectItem;

// ---------------------------------------------------------------------------
// „Woche planen" — Vorschlagslogik ohne UI (testbar). Füllt die gewählten
// Mahlzeiten-Plätze der Reihe nach mit Rezepten aus dem Rezept-Cache:
//
//   • Filter (hart): „Nur aus" Kategorien/Schlagworte (je Dimension
//     „irgendeines", untereinander UND), Würfel-Auswahl je Mahlzeit,
//     „unter der Woche schnell" (Mo–Fr ≤ 30 Min. Gesamtzeit).
//   • Gewichtung (weich): lange nicht gekocht/geplant, Favoriten + gute
//     Bewertung.
//   • Abwechslung: keine gemeinsame Kategorie mit dem vorigen Platz — wird
//     gelockert, wenn sonst nichts übrig bleibt.
//   • Kein Rezept zweimal in derselben Woche (auch nicht doppelt zu bereits
//     geplanten Einträgen), solange es genug andere gibt.
// ---------------------------------------------------------------------------

/// Ein zu füllender Platz: Tag + Mealie-Mahlzeitentyp.
class PlanSlot {
  final DateTime date;
  final String type;
  const PlanSlot(this.date, this.type);

  String get key => '${date.year}-${date.month}-${date.day}|$type';
}

class WeekPlanPrefs {
  final bool quickWeekdays;
  final bool preferStale;
  final bool preferFavorites;
  final bool variety;
  final bool useDiceRules;
  final List<SelectItem> categories;
  final List<SelectItem> tags;

  const WeekPlanPrefs({
    this.quickWeekdays = true,
    this.preferStale = true,
    this.preferFavorites = false,
    this.variety = true,
    this.useDiceRules = false,
    this.categories = const [],
    this.tags = const [],
  });

  WeekPlanPrefs copyWith({
    bool? quickWeekdays,
    bool? preferStale,
    bool? preferFavorites,
    bool? variety,
    bool? useDiceRules,
    List<SelectItem>? categories,
    List<SelectItem>? tags,
  }) =>
      WeekPlanPrefs(
        quickWeekdays: quickWeekdays ?? this.quickWeekdays,
        preferStale: preferStale ?? this.preferStale,
        preferFavorites: preferFavorites ?? this.preferFavorites,
        variety: variety ?? this.variety,
        useDiceRules: useDiceRules ?? this.useDiceRules,
        categories: categories ?? this.categories,
        tags: tags ?? this.tags,
      );

  Map<String, dynamic> toJson() => {
        'quickWeekdays': quickWeekdays,
        'preferStale': preferStale,
        'preferFavorites': preferFavorites,
        'variety': variety,
        'useDiceRules': useDiceRules,
        'categories': [
          for (final c in categories) {'id': c.id, 'name': c.name}
        ],
        'tags': [
          for (final t in tags) {'id': t.id, 'name': t.name}
        ],
      };

  static List<SelectItem> _items(dynamic raw) => [
        for (final e in (raw is List ? raw : const []))
          if (e is Map && e['id'] is String)
            (id: e['id'] as String, name: (e['name'] as String?) ?? ''),
      ];

  factory WeekPlanPrefs.fromJson(Map<String, dynamic> j) => WeekPlanPrefs(
        quickWeekdays: j['quickWeekdays'] as bool? ?? true,
        preferStale: j['preferStale'] as bool? ?? true,
        preferFavorites: j['preferFavorites'] as bool? ?? false,
        variety: j['variety'] as bool? ?? true,
        useDiceRules: j['useDiceRules'] as bool? ?? false,
        categories: _items(j['categories']),
        tags: _items(j['tags']),
      );
}

/// Warum ein Rezept vorgeschlagen wurde (für die kleine Begründung).
/// [fromTray] = vom Rezept-Match-Tablett mitgebracht.
enum PlanReason { none, neverCooked, stale, favorite, fromTray }

class PlanPick {
  final RecipeDetail recipe;
  final PlanReason reason;
  const PlanPick(this.recipe, this.reason);
}

/// Höchstdauer (Minuten) für „unter der Woche schnell".
const kWeekPlannerQuickMinutes = 30;

class WeekPlanner {
  final List<RecipeDetail> recipes;
  final WeekPlanPrefs prefs;
  final Set<String> favorites;

  /// Letztes Koch- bzw. Plan-Datum je Rezept-ID (fehlt = nie).
  final Map<String, DateTime> lastCooked;

  /// Würfel-Auswahl je Mahlzeitentyp (`c:<id>` / `t:<id>`).
  final Map<String, List<String>> diceFilters;

  /// Prüft die Würfel-Auswahl (geteilte Logik aus dem Würfel).
  final bool Function(RecipeDetail, List<String>) matchesDice;

  /// Mealie-Regeln statt App-Auswahl (Würfel-System „Mealie-Regeln"): je
  /// Platz ([PlanSlot.key]) die Rezept-IDs, die die greifenden Regeln
  /// erfüllen. Fehlt ein Platz, greift dort keine Regel → alle Rezepte.
  /// `null` = App-Auswahl ([diceFilters]) verwenden.
  final Map<String, Set<String>>? ruleMatches;
  final DateTime today;
  final Random random;

  WeekPlanner({
    required this.recipes,
    required this.prefs,
    required this.favorites,
    required this.lastCooked,
    required this.diceFilters,
    required this.matchesDice,
    this.ruleMatches,
    required this.today,
    Random? random,
  }) : random = random ?? Random();

  /// Rezepte, die die harten Filter („Nur aus") erfüllen — für den Zähler.
  List<RecipeDetail> get pool => recipes.where(_matchesOnlyFrom).toList();

  bool _matchesOnlyFrom(RecipeDetail r) {
    if (prefs.categories.isNotEmpty &&
        !r.recipeCategory
            .any((c) => prefs.categories.any((s) => s.id == c.id))) {
      return false;
    }
    if (prefs.tags.isNotEmpty &&
        !r.tags.any((t) => prefs.tags.any((s) => s.id == t.id))) {
      return false;
    }
    return true;
  }

  bool _fitsSlot(RecipeDetail r, PlanSlot slot) {
    if (!_matchesOnlyFrom(r)) return false;
    if (prefs.useDiceRules) {
      final rules = ruleMatches;
      if (rules != null) {
        final ids = rules[slot.key];
        if (ids != null && !ids.contains(r.id)) return false;
      } else {
        final f = diceFilters[slot.type] ?? const [];
        if (f.isNotEmpty && !matchesDice(r, f)) return false;
      }
    }
    if (prefs.quickWeekdays && slot.date.weekday <= DateTime.friday) {
      final t = r.totalTime ?? 0;
      if (t <= 0 || t > kWeekPlannerQuickMinutes) return false;
    }
    return true;
  }

  double _weight(RecipeDetail r) {
    var w = 1.0;
    if (prefs.preferStale) {
      final last = lastCooked[r.id];
      if (last == null) {
        w *= 2.5;
      } else {
        final days = today.difference(last).inDays;
        w *= days > 60
            ? 3.0
            : days > 21
                ? 1.6
                : days < 7
                    ? 0.25
                    : 1.0;
      }
    }
    if (prefs.preferFavorites) {
      if (favorites.contains(r.id)) w *= 2.5;
      if ((r.rating ?? 0) >= 4) w *= 1.5;
    }
    return w;
  }

  PlanReason _reason(RecipeDetail r) {
    if (prefs.preferFavorites && favorites.contains(r.id)) {
      return PlanReason.favorite;
    }
    if (prefs.preferStale) {
      final last = lastCooked[r.id];
      if (last == null) return PlanReason.neverCooked;
      if (today.difference(last).inDays > 60) return PlanReason.stale;
    }
    return PlanReason.none;
  }

  RecipeDetail? _weightedPick(List<RecipeDetail> list) {
    if (list.isEmpty) return null;
    final weights = [for (final r in list) _weight(r)];
    final total = weights.fold<double>(0, (a, b) => a + b);
    var x = random.nextDouble() * total;
    for (var i = 0; i < list.length; i++) {
      x -= weights[i];
      if (x <= 0) return list[i];
    }
    return list.last;
  }

  /// Ein Rezept für [slot]. [used] = schon vergebene Rezept-IDs (diese
  /// Woche), [previous] = Rezept des vorigen Platzes (Abwechslung).
  PlanPick? pickFor(PlanSlot slot,
      {required Set<String> used, RecipeDetail? previous}) {
    final fitting = recipes.where((r) => _fitsSlot(r, slot)).toList();
    final fresh = fitting.where((r) => !used.contains(r.id)).toList();
    var candidates = fresh.isNotEmpty ? fresh : fitting;
    if (prefs.variety && previous != null) {
      final prevCats = {for (final c in previous.recipeCategory) c.id};
      final varied = candidates
          .where((r) => !r.recipeCategory.any((c) => prevCats.contains(c.id)))
          .toList();
      if (varied.isNotEmpty) candidates = varied;
    }
    final r = _weightedPick(candidates);
    return r == null ? null : PlanPick(r, _reason(r));
  }

  /// Alle [slots] (chronologisch) füllen. [locked] bleiben stehen,
  /// [alreadyPlanned] = Rezept-IDs, die in der Woche schon eingetragen sind.
  /// [preferred] (z. B. vom Rezept-Match-Tablett) kommen ZUERST dran, der
  /// Reihe nach auf die freien Plätze — bewusst ohne Filter, der Nutzer hat
  /// sie ausgesucht. Bleiben Plätze übrig, wird wie gewohnt vorgeschlagen;
  /// sind es mehr Rezepte als Plätze, bleiben die übrigen ungenutzt.
  Map<String, PlanPick?> planAll(
    List<PlanSlot> slots, {
    Map<String, PlanPick?> locked = const {},
    Set<String> alreadyPlanned = const {},
    List<RecipeDetail> preferred = const [],
  }) {
    final sorted = List.of(slots)
      ..sort((a, b) {
        final d = a.date.compareTo(b.date);
        return d != 0 ? d : a.type.compareTo(b.type);
      });
    final used = {
      ...alreadyPlanned,
      for (final p in locked.values)
        if (p != null) p.recipe.id,
    };
    final queue = [
      for (final r in preferred)
        if (!used.contains(r.id)) r,
    ];
    final result = <String, PlanPick?>{};
    RecipeDetail? previous;
    for (final s in sorted) {
      final pick = locked.containsKey(s.key)
          ? locked[s.key]
          : queue.isNotEmpty
              ? PlanPick(queue.removeAt(0), PlanReason.fromTray)
              : pickFor(s, used: used, previous: previous);
      result[s.key] = pick;
      if (pick != null) {
        used.add(pick.recipe.id);
        previous = pick.recipe;
      }
    }
    return result;
  }
}
