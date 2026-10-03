import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/shopping_item.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/utils/ingredient_parse.dart';

// ---------------------------------------------------------------------------
// Foods- & Einheiten-Katalog für die Einkaufsliste.
//
// Cache-first wie shoppingLabelsProvider: sofort aus dem lokalen Cache
// liefern (die Autovervollständigung funktioniert damit auch offline), im
// Hintergrund frisch vom Server holen und den Cache aktualisieren. Genutzt
// von der Eingabezeile der Einkaufsliste: Vorschläge beim Tippen + Auflösen
// des getippten Texts auf Server-IDs (strukturierte Adds im Exakt-Modus).
// ---------------------------------------------------------------------------

final foodsCatalogProvider =
    AsyncNotifierProvider<FoodsCatalogNotifier, List<ShoppingFood>>(
        FoodsCatalogNotifier.new);

class FoodsCatalogNotifier extends AsyncNotifier<List<ShoppingFood>> {
  @override
  Future<List<ShoppingFood>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadFoodsCatalog();
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          final fresh = await _fetch(api);
          await LocalCache.saveFoodsCatalog(fresh);
          state = AsyncData(fresh);
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    try {
      final fresh = await _fetch(api);
      await LocalCache.saveFoodsCatalog(fresh);
      return fresh;
    } catch (_) {
      return [];
    }
  }

  Future<List<ShoppingFood>> _fetch(ApiService api) async {
    final raw = await api.fetchFoods();
    return raw
        .map((f) => ShoppingFood(
              id: f['id'] as String?,
              name: (f['name'] as String?)?.trim(),
              pluralName: (f['pluralName'] as String?)?.trim(),
              householdsWithIngredientFood:
                  (f['householdsWithIngredientFood'] as List?)
                      ?.map((h) => h.toString())
                      .toList(),
              onHand: f['onHand'] as bool?,
              labelId: f['labelId'] as String?,
            ))
        .where((f) => (f.name ?? '').isNotEmpty)
        .toList();
  }
}

final unitsCatalogProvider =
    AsyncNotifierProvider<UnitsCatalogNotifier, List<ShoppingUnit>>(
        UnitsCatalogNotifier.new);

class UnitsCatalogNotifier extends AsyncNotifier<List<ShoppingUnit>> {
  @override
  Future<List<ShoppingUnit>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadUnitsCatalog();
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          final fresh = await _fetch(api);
          await LocalCache.saveUnitsCatalog(fresh);
          state = AsyncData(fresh);
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    try {
      final fresh = await _fetch(api);
      await LocalCache.saveUnitsCatalog(fresh);
      return fresh;
    } catch (_) {
      return [];
    }
  }

  Future<List<ShoppingUnit>> _fetch(ApiService api) async {
    final raw = await api.fetchUnits();
    return raw
        .map((u) => ShoppingUnit(
              id: u['id'] as String?,
              name: (u['name'] as String?)?.trim(),
              pluralName: (u['pluralName'] as String?)?.trim(),
              abbreviation: (u['abbreviation'] as String?)?.trim(),
            ))
        .where((u) => (u.name ?? '').isNotEmpty)
        .toList();
  }
}

// ---------------------------------------------------------------------------
// Auflösen von getipptem Text auf Server-Objekte (mit id).
// ---------------------------------------------------------------------------

/// Exakter (case-insensitiver) Namenstreffer im Foods-Katalog → der Add geht
/// als echtes Food-Item (foodId + isFood) raus. Ohne Treffer legt
/// `ShoppingListNotifier.addItem` das Food im Exakt-Modus serverseitig an.
ShoppingFood? resolveFoodByName(List<ShoppingFood> foods, String input) {
  final q = input.trim().toLowerCase();
  if (q.isEmpty) return null;
  for (final f in foods) {
    if ((f.id ?? '').isEmpty) continue;
    // Auch die Pluralform — sonst legt „Eier" neben „Ei (Eier)" ein zweites
    // Lebensmittel an.
    if ((f.name ?? '').trim().toLowerCase() == q ||
        (f.pluralName ?? '').trim().toLowerCase() == q) {
      return f;
    }
  }
  return null;
}

/// Einheit per Name ODER Abkürzung auflösen („Gramm" wie „g"). Findet beides
/// nichts, werden die bekannten Mehrsprach-Tokens ([commonUnitTokens], z. B.
/// „el" → „Esslöffel") auf ihren kanonischen Namen abgebildet und der erneut
/// gegen den Katalog gesucht — so trifft auch eine Server-Einheit ohne
/// hinterlegte Abkürzung.
ShoppingUnit? resolveUnitByName(List<ShoppingUnit> units, String input) {
  final q = input.trim().toLowerCase();
  if (q.isEmpty) return null;
  for (final u in units) {
    if ((u.id ?? '').isEmpty) continue;
    if ((u.name ?? '').toLowerCase() == q ||
        ((u.abbreviation ?? '').isNotEmpty &&
            u.abbreviation!.toLowerCase() == q)) {
      return u;
    }
  }
  final canonical = commonUnitTokens[q]?.toLowerCase();
  if (canonical != null && canonical != q) {
    for (final u in units) {
      if ((u.id ?? '').isEmpty) continue;
      if ((u.name ?? '').toLowerCase() == canonical) return u;
    }
  }
  return null;
}
