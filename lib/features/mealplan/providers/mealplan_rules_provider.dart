import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/mealplan_rule.dart';
import '../../../core/services/local_cache.dart';

// ---------------------------------------------------------------------------
// Mahlzeitenplan-Regeln des Haushalts (Mealie „Meal Plan Rules") —
// Cache-first: letzter Stand sofort (auch offline für die Anzeige), im
// Hintergrund frisch vom Server.
// ---------------------------------------------------------------------------

final mealplanRulesProvider =
    AsyncNotifierProvider<MealplanRulesNotifier, List<MealPlanRule>>(
        MealplanRulesNotifier.new);

class MealplanRulesNotifier extends AsyncNotifier<List<MealPlanRule>> {
  static const _key = 'mealplan_rules';

  @override
  Future<List<MealPlanRule>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = (await LocalCache.loadJsonList(_key))
        .map(MealPlanRule.tryParse)
        .whereType<MealPlanRule>()
        .toList();
    Future<List<MealPlanRule>> fetch() async {
      final fresh = await api.fetchMealplanRules();
      await LocalCache.saveJsonList(_key, fresh.map((r) => r.toJson()));
      return fresh;
    }

    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await fetch());
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    try {
      return await fetch();
    } catch (_) {
      return const [];
    }
  }

  Future<void> _store(List<MealPlanRule> list) async {
    state = AsyncData(list);
    await LocalCache.saveJsonList(_key, list.map((r) => r.toJson()));
  }

  List<MealPlanRule> get _current => state.valueOrNull ?? const [];

  Future<void> save(MealPlanRule rule) async {
    final api = ref.read(apiServiceProvider);
    if (rule.id.isEmpty) {
      final created = await api.createMealplanRule(rule);
      await _store([..._current, created]);
    } else {
      final updated = await api.updateMealplanRule(rule);
      await _store([
        for (final r in _current) r.id == updated.id ? updated : r,
      ]);
    }
  }

  Future<void> delete(MealPlanRule rule) async {
    await ref.read(apiServiceProvider).deleteMealplanRule(rule.id);
    await _store(_current.where((r) => r.id != rule.id).toList());
  }
}

// ── Treffer je Regel-Filter (Würfel offline) ────────────────────────────
// Die Auswertung der Mealie-Regeln macht der Server. Damit der Würfel auch
// offline nach Regeln würfelt, merken wir uns die zuletzt gelieferten
// Rezept-IDs je Filter (die neuesten 30 Filter).

const _kRuleMatchesKey = 'mealplan_rule_matches';
const _kRuleMatchesMax = 30;

Future<void> saveMealRuleMatches(String filter, Set<String> ids) async {
  final list = await LocalCache.loadJsonList(_kRuleMatchesKey);
  final next = [
    {'filter': filter, 'ids': ids.toList()},
    ...list.where((e) => e['filter'] != filter),
  ].take(_kRuleMatchesMax);
  await LocalCache.saveJsonList(_kRuleMatchesKey, next);
}

/// `null`, wenn für diesen Filter noch nie Treffer vom Server kamen.
Future<Set<String>?> loadMealRuleMatches(String filter) async {
  final list = await LocalCache.loadJsonList(_kRuleMatchesKey);
  for (final e in list) {
    if (e['filter'] == filter) {
      return {...((e['ids'] as List?) ?? const []).map((x) => x.toString())};
    }
  }
  return null;
}
