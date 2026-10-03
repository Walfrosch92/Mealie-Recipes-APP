import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/local_cache.dart';
import '../models/pending_changes.dart';

// ---------------------------------------------------------------------------
// PendingShoppingChangesNotifier — Persistierung der 5 Pending-Listen.
//
// 1:1 zu Swifts ShoppingListViewModel.loadAllPendingChanges / save…Changes:
// jeder Typ wird unter einem eigenen UserDefaults-Schlüssel gehalten und nach
// jeder Mutation synchron geschrieben. Hier dasselbe via LocalCache (Shared-
// Preferences).
// ---------------------------------------------------------------------------

final pendingShoppingChangesProvider = NotifierProvider<
    PendingShoppingChangesNotifier, PendingShoppingChangesState>(
  PendingShoppingChangesNotifier.new,
);

class PendingShoppingChangesNotifier
    extends Notifier<PendingShoppingChangesState> {
  @override
  PendingShoppingChangesState build() {
    // Erstmal leerer Stand, im Hintergrund vom Disk laden.
    Future.microtask(_loadAll);
    return const PendingShoppingChangesState();
  }

  Future<void> _loadAll() async {
    final results = await Future.wait([
      LocalCache.loadPendingCheckChanges(),
      LocalCache.loadPendingQuantityChanges(),
      LocalCache.loadPendingDeleteChanges(),
      LocalCache.loadPendingAddChanges(),
      LocalCache.loadPendingCategoryChanges(),
    ]);
    state = PendingShoppingChangesState(
      checks: results[0] as List<PendingCheckChange>,
      quantities: results[1] as List<PendingQuantityChange>,
      deletes: results[2] as List<PendingDeleteChange>,
      adds: results[3] as List<PendingAddChange>,
      categories: results[4] as List<PendingCategoryChange>,
    );
  }

  // ── Check ────────────────────────────────────────────────────────────────

  Future<void> addCheck(PendingCheckChange change) async {
    if (state.checks.contains(change)) return;
    // Bei mehrfachem Toggle des gleichen Items behalten wir nur den letzten
    // Stand pro itemId — das macht der Server-Sync sowieso konsistent.
    final filtered = state.checks
        .where((c) => c.itemId != change.itemId)
        .toList()
      ..add(change);
    state = state.copyWith(checks: filtered);
    await LocalCache.savePendingCheckChanges(filtered);
  }

  Future<void> clearChecks() async {
    state = state.copyWith(checks: const []);
    await LocalCache.savePendingCheckChanges(const []);
  }

  // ── Quantity ─────────────────────────────────────────────────────────────

  Future<void> addQuantity(PendingQuantityChange change) async {
    final filtered = state.quantities
        .where((c) => c.itemId != change.itemId)
        .toList()
      ..add(change);
    state = state.copyWith(quantities: filtered);
    await LocalCache.savePendingQuantityChanges(filtered);
  }

  Future<void> clearQuantities() async {
    state = state.copyWith(quantities: const []);
    await LocalCache.savePendingQuantityChanges(const []);
  }

  // ── Delete ───────────────────────────────────────────────────────────────

  Future<void> addDelete(PendingDeleteChange change) async {
    if (state.deletes.contains(change)) return;
    final list = [...state.deletes, change];
    state = state.copyWith(deletes: list);
    await LocalCache.savePendingDeleteChanges(list);
  }

  Future<void> clearDeletes() async {
    state = state.copyWith(deletes: const []);
    await LocalCache.savePendingDeleteChanges(const []);
  }

  // ── Add ──────────────────────────────────────────────────────────────────

  Future<void> addAdd(PendingAddChange change) async {
    if (state.adds.contains(change)) return;
    final list = [...state.adds, change];
    state = state.copyWith(adds: list);
    await LocalCache.savePendingAddChanges(list);
  }

  Future<void> removeAdd(String id) async {
    final list = state.adds.where((a) => a.id != id).toList();
    state = state.copyWith(adds: list);
    await LocalCache.savePendingAddChanges(list);
  }

  Future<void> clearAdds() async {
    state = state.copyWith(adds: const []);
    await LocalCache.savePendingAddChanges(const []);
  }

  // ── Category ─────────────────────────────────────────────────────────────

  Future<void> addCategory(PendingCategoryChange change) async {
    final filtered = state.categories
        .where((c) => c.itemId != change.itemId)
        .toList()
      ..add(change);
    state = state.copyWith(categories: filtered);
    await LocalCache.savePendingCategoryChanges(filtered);
  }

  Future<void> clearCategories() async {
    state = state.copyWith(categories: const []);
    await LocalCache.savePendingCategoryChanges(const []);
  }
}
