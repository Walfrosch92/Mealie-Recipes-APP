import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/services/local_cache.dart';
import '../../shopping_list/providers/foods_units_provider.dart';

// ---------------------------------------------------------------------------
// Verwaltung von Lebensmitteln / Einheiten (Home-Kacheln).
//
// Hält die ROHEN Server-Objekte (Map), weil Mealie beim PUT das komplette
// Objekt ersetzt — nur so bleiben Aliase, Label, Haushalte, Standardmenge
// usw. beim Umbenennen erhalten. Cache-first wie überall. Nach jeder
// Änderung werden die Autovervollständigungs-Kataloge (Einkaufsliste,
// Editor) neu geladen.
// ---------------------------------------------------------------------------

enum FoodUnitKind {
  food('foods'),
  unit('units');

  final String path;
  const FoodUnitKind(this.path);

  static FoodUnitKind? fromPath(String? p) {
    for (final k in values) {
      if (k.path == p) return k;
    }
    return null;
  }
}

final foodsUnitsAdminProvider = AsyncNotifierProvider.family<
    FoodsUnitsAdminNotifier, List<Map<String, dynamic>>, FoodUnitKind>(
  FoodsUnitsAdminNotifier.new,
);

String foodUnitName(Map<String, dynamic> m) =>
    (m['name'] as String?)?.trim() ?? '';

class FoodsUnitsAdminNotifier
    extends FamilyAsyncNotifier<List<Map<String, dynamic>>, FoodUnitKind> {
  String get _key => 'admin_${arg.path}';

  @override
  Future<List<Map<String, dynamic>>> build(FoodUnitKind arg) async {
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
    final raw = arg == FoodUnitKind.food
        ? await api.fetchFoods()
        : await api.fetchUnits();
    final list = _sorted(raw);
    await LocalCache.saveJsonList(_key, list);
    return list;
  }

  List<Map<String, dynamic>> _sorted(List<Map<String, dynamic>> l) => [...l]
    ..sort((a, b) =>
        foodUnitName(a).toLowerCase().compareTo(foodUnitName(b).toLowerCase()));

  Future<void> refresh() async {
    try {
      state = AsyncData(await _fetch(ref.read(apiServiceProvider)));
    } catch (_) {/* Stand behalten */}
  }

  Future<void> _store(List<Map<String, dynamic>> list) async {
    final sorted = _sorted(list);
    state = AsyncData(sorted);
    await LocalCache.saveJsonList(_key, sorted);
    // Autovervollständigung (Einkaufsliste/Editor) auf neuen Stand bringen.
    if (arg == FoodUnitKind.food) {
      ref.invalidate(foodsCatalogProvider);
    } else {
      ref.invalidate(unitsCatalogProvider);
    }
  }

  List<Map<String, dynamic>> get _current => state.valueOrNull ?? const [];

  /// Anlegen (ohne `id`) oder Aktualisieren ([data] = vollständiges Objekt).
  Future<void> save(Map<String, dynamic> data) async {
    final api = ref.read(apiServiceProvider);
    final id = data['id'] as String?;
    if (id == null || id.isEmpty) {
      final created = arg == FoodUnitKind.food
          ? await api.createFoodFull(data)
          : await api.createUnitFull(data);
      await _store([..._current, created]);
    } else {
      final updated = arg == FoodUnitKind.food
          ? await api.updateFood(data)
          : await api.updateUnit(data);
      await _store([
        for (final m in _current) m['id'] == id ? updated : m,
      ]);
    }
  }

  Future<void> delete(Map<String, dynamic> item) async {
    final api = ref.read(apiServiceProvider);
    final id = item['id'] as String;
    if (arg == FoodUnitKind.food) {
      await api.deleteFood(id);
    } else {
      await api.deleteUnit(id);
    }
    await _store(_current.where((m) => m['id'] != id).toList());
  }

  /// [from] in [to] zusammenführen — [from] verschwindet.
  Future<void> merge(Map<String, dynamic> from, Map<String, dynamic> to) async {
    final api = ref.read(apiServiceProvider);
    final fromId = from['id'] as String;
    final toId = to['id'] as String;
    if (arg == FoodUnitKind.food) {
      await api.mergeFoods(fromId, toId);
    } else {
      await api.mergeUnits(fromId, toId);
    }
    await _store(_current.where((m) => m['id'] != fromId).toList());
  }
}
