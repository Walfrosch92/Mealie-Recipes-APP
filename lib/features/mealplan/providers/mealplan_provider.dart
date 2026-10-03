import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/mealplan_entry.dart';
import '../../../core/services/local_cache.dart';

// ---------------------------------------------------------------------------
// Date helpers — mirror iOS Calendar.startOfWeek + ISO week number
// ---------------------------------------------------------------------------

DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime startOfWeek(DateTime d) {
  // Monday as first day of week (German locale / ISO)
  final day = startOfDay(d);
  return day.subtract(Duration(days: day.weekday - 1));
}

/// ISO-8601 week number — mirrors iOS calendarWeekNumber()
int isoWeekNumber(DateTime date) {
  final d = startOfDay(date);
  // Thursday in current week decides the year
  final thursday = d.add(Duration(days: 4 - (d.weekday)));
  final firstDayOfYear = DateTime(thursday.year, 1, 1);
  final diff = thursday.difference(firstDayOfYear).inDays;
  return 1 + (diff ~/ 7);
}

// ---------------------------------------------------------------------------
// Current week start (the week currently being viewed) — mirrors iOS currentWeekStart
// ---------------------------------------------------------------------------

final currentWeekStartProvider =
    StateProvider<DateTime>((ref) => startOfWeek(DateTime.now()));

// ---------------------------------------------------------------------------
// All mealplan entries grouped by day — mirrors iOS MealplanViewModel.entriesByDay
// ---------------------------------------------------------------------------

final mealplanProvider =
    AsyncNotifierProvider<MealplanNotifier, Map<DateTime, List<MealplanEntry>>>(
        MealplanNotifier.new);

class MealplanNotifier
    extends AsyncNotifier<Map<DateTime, List<MealplanEntry>>> {
  // Signatur der zuletzt übernommenen Server-Liste — der Hintergrund-Abgleich
  // schreibt den state nur bei tatsächlicher Änderung (kein Flackern).
  String? _lastSig;

  // OFFLINE-FIRST (App-weites Muster): gecachte Einträge sofort anzeigen,
  // im Hintergrund mit dem Server abgleichen; schlägt der Abgleich fehl,
  // bleibt der Cache-Stand stehen. Vorher lud der Provider bei jedem Build
  // direkt vom Server und der Essensplan war offline leer.
  @override
  Future<Map<DateTime, List<MealplanEntry>>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadMealplanEntries();
    if (cached.isNotEmpty) {
      _lastSig = _signature(cached);
      Future.microtask(_refreshFromServer);
      return _groupByDay(cached);
    }
    try {
      final entries = await api.fetchAllMealplanEntries();
      await LocalCache.saveMealplanEntries(entries);
      _lastSig = _signature(entries);
      return _groupByDay(entries);
    } catch (_) {
      // Mirror iOS MealplanViewModel.fetchMealplanAsync: bei Fehler keine
      // Daten verlieren — der iOS-Kommentar dazu lautet "WICHTIG: Behalte
      // alte Daten bei Fehler, leere sie nicht!". Beim allerersten Load
      // gibt es noch keinen Vorzustand, also leere Map (UI zeigt EmptyState).
      return {};
    }
  }

  Future<void> _refreshFromServer() async {
    try {
      final api = ref.read(apiServiceProvider);
      final entries = await api.fetchAllMealplanEntries();
      final sig = _signature(entries);
      if (sig == _lastSig) return; // unverändert → nichts anfassen
      await LocalCache.saveMealplanEntries(entries);
      _lastSig = sig;
      state = AsyncData(_groupByDay(entries));
    } catch (_) {/* offline / Server nicht erreichbar → Cache behalten */}
  }

  String _signature(List<MealplanEntry> entries) =>
      jsonEncode(entries.map((e) => e.toJson()).toList());

  Map<DateTime, List<MealplanEntry>> _groupByDay(List<MealplanEntry> entries) {
    final map = <DateTime, List<MealplanEntry>>{};
    for (final e in entries) {
      final parsed = DateTime.tryParse(e.date);
      if (parsed == null) continue;
      final key = startOfDay(parsed);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  List<MealplanEntry> _flatten(Map<DateTime, List<MealplanEntry>>? grouped) {
    if (grouped == null) return [];
    return [for (final list in grouped.values) ...list];
  }

  /// Aktuellen State in den Cache spiegeln (nach lokalen Mutationen).
  Future<void> _persistState() async {
    final flat = _flatten(state.valueOrNull);
    _lastSig = _signature(flat);
    await LocalCache.saveMealplanEntries(flat);
  }

  // mirrors iOS addMeal / addMealEntry — Payload-Struktur 1:1 zu Swifts
  //   Payload(date, entryType, recipeId, title)
  // mit der Mutex-Regel `title: recipeId == nil ? note : nil`.
  // Kein `text`-Feld im Payload (siehe MealplanEntryCreate-Kommentar).
  Future<void> addEntry({
    required String date,
    required String entryType,
    String? recipeId,
    String? title,
  }) async {
    final api = ref.read(apiServiceProvider);
    final hasRecipe = recipeId != null && recipeId.isNotEmpty;
    final created = await api.createMealplanEntry(MealplanEntryCreate(
      date: date,
      entryType: entryType,
      recipeId: hasRecipe ? recipeId : null,
      title: hasRecipe ? null : title,
    ));
    // Server-Echo direkt lokal einfügen statt invalidateSelf: der Provider
    // ist jetzt Cache-first — ein invalidate zeigte erst wieder den ALTEN
    // Cache-Stand und der neue Eintrag käme sichtbar verzögert mit dem
    // Hintergrund-Abgleich nach.
    final flat = _flatten(state.valueOrNull)..add(created);
    state = AsyncData(_groupByDay(flat));
    await _persistState();
  }

  // mirrors iOS removeMeal(_:)
  Future<void> deleteEntry(String id) async {
    // optimistic local removal
    final current = state.valueOrNull;
    if (current != null) {
      final updated = <DateTime, List<MealplanEntry>>{};
      current.forEach((day, list) {
        final filtered = list.where((e) => e.id != id).toList();
        if (filtered.isNotEmpty) updated[day] = filtered;
      });
      state = AsyncData(updated);
      await _persistState();
    }
    await ref.read(apiServiceProvider).deleteMealplanEntry(id);
  }

  // mirrors iOS refresh() → fetchMealplanAsync(): die alte Liste bleibt
  // während des Reloads sichtbar (kein AsyncLoading), und bei Fehler wird
  // der vorherige state beibehalten.
  Future<void> refresh() async {
    try {
      final api = ref.read(apiServiceProvider);
      final entries = await api.fetchAllMealplanEntries();
      await LocalCache.saveMealplanEntries(entries);
      _lastSig = _signature(entries);
      state = AsyncData(_groupByDay(entries));
    } catch (_) {
      // bewusst leer — alte Daten behalten, mirror Swift.
    }
  }
}

// ---------------------------------------------------------------------------
// Derived: entries for the currently viewed week, grouped by day
// ---------------------------------------------------------------------------

final currentWeekEntriesProvider =
    Provider<Map<DateTime, List<MealplanEntry>>>((ref) {
  final all = ref.watch(mealplanProvider).valueOrNull ?? {};
  final weekStart = ref.watch(currentWeekStartProvider);
  final weekStartDay = startOfDay(weekStart);
  final weekEndExclusive = weekStartDay.add(const Duration(days: 7));

  final result = <DateTime, List<MealplanEntry>>{};
  all.forEach((day, entries) {
    if (!day.isBefore(weekStartDay) && day.isBefore(weekEndExclusive)) {
      result[day] = entries;
    }
  });
  return result;
});

// ---------------------------------------------------------------------------
// Derived: available OTHER weeks that have entries — mirrors getAvailableWeeks()
// ---------------------------------------------------------------------------

class WeekInfo {
  final DateTime weekStart;
  final int count;
  const WeekInfo({required this.weekStart, required this.count});
}

final otherWeeksProvider = Provider<List<WeekInfo>>((ref) {
  final all = ref.watch(mealplanProvider).valueOrNull ?? {};
  final currentWeekStart = startOfDay(ref.watch(currentWeekStartProvider));

  // collect distinct week-starts (excluding current week) with counts
  final weekCounts = <DateTime, int>{};
  all.forEach((day, entries) {
    final ws = startOfWeek(day);
    if (ws == currentWeekStart) return;
    weekCounts[ws] = (weekCounts[ws] ?? 0) + entries.length;
  });

  final list = weekCounts.entries
      .map((e) => WeekInfo(weekStart: e.key, count: e.value))
      .toList()
    ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  return list;
});
