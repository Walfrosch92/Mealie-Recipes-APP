import '../models/shopping_item.dart';
import 'server_time.dart';

// ---------------------------------------------------------------------------
// Reihenfolge wie die Mealie-Webapp (Standardansicht, use-shopping-list-
// sorting.ts): offene Artikel nach `position`, dann `createdAt`; gleiche
// Artikel (gleiches Lebensmittel bzw. gleiche Notiz) stehen zusammen, die
// Gruppe dort, wo ihr erster Artikel steht. Abgehakte (use-shopping-list-
// state.ts): zuletzt geändert oben, bei Gleichstand höhere Position zuerst.
// ---------------------------------------------------------------------------

int _compareByPosition(ShoppingItem a, ShoppingItem b) {
  final pa = a.position ?? 0;
  final pb = b.position ?? 0;
  if (pa != pb) return pa.compareTo(pb);
  return (a.createdAt ?? '').compareTo(b.createdAt ?? '');
}

List<ShoppingItem> sortShoppingItemsLikeWebapp(List<ShoppingItem> items) {
  final sorted = List<ShoppingItem>.of(items)..sort(_compareByPosition);
  final groups = <String, List<ShoppingItem>>{};
  for (final i in sorted) {
    final food = i.food?.name ?? '';
    final key = food.isNotEmpty ? 'f:$food' : 'n:${i.note ?? ''}';
    groups.putIfAbsent(key, () => []).add(i);
  }
  return [for (final g in groups.values) ...g];
}

int compareCheckedLikeWebapp(ShoppingItem a, ShoppingItem b) {
  final ta = parseMealieTime(a.updatedAt);
  final tb = parseMealieTime(b.updatedAt);
  if (ta == tb || (ta != null && tb != null && ta.isAtSameMomentAs(tb))) {
    return (b.position ?? 0).compareTo(a.position ?? 0);
  }
  if (ta == null) return 1;
  if (tb == null) return -1;
  return tb.compareTo(ta);
}
