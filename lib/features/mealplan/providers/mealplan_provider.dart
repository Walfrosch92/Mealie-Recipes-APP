import 'dart:convert';

import 'package:collection/collection.dart' show mergeSort;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/mealplan_entry.dart';
import '../../../core/providers/cached_json_list.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/utils/meal_types.dart';

// ---------------------------------------------------------------------------
// Date helpers — mirror iOS Calendar.startOfWeek + ISO week number
// ---------------------------------------------------------------------------

DateTime startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);

/// Kalendertage addieren (Mitternacht bleibt Mitternacht). NIE
/// `add(Duration(days: n))` für Kalendertage: über die Zeitumstellung hinweg
/// sind das 23/25 Stunden zu viel/wenig — „nächste Woche" landete am
/// 25.10. auf Sonntag 23:00 und damit wieder in derselben Woche.
DateTime addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

/// Wochenanfang von [d]. [firstWeekday] in Dart-Zählung (1 = Montag …
/// 7 = Sonntag); kommt aus Mealies Haushalts-Einstellung, siehe
/// [weekStartWeekdayProvider].
DateTime startOfWeek(DateTime d, [int firstWeekday = DateTime.monday]) {
  final back = (d.weekday - firstWeekday + 7) % 7;
  return addDays(startOfDay(d), -back);
}

/// Mealie `firstDayOfWeek` (0 = Sonntag, 1 = Montag … 6 = Samstag, wie die
/// Webapp) → Dart-Wochentag (1 = Montag … 7 = Sonntag).
int dartWeekdayFromMealie(int mealieDay) =>
    mealieDay % 7 == 0 ? DateTime.sunday : mealieDay % 7;

/// Wochenbeginn des EIGENEN Haushalts aus Mealie (Haushalts-Einstellung
/// „Erster Tag der Woche"). Kommt aus der zwischengespeicherten
/// Haushaltsliste (/api/groups/households) → auch offline. Unbekannt
/// (noch nie geladen, alte Mealie-Version) → Montag wie bisher.
final weekStartWeekdayProvider = Provider<int>((ref) {
  final own = ref.watch(userPermissionsProvider).householdId;
  final households = ref.watch(householdsListProvider).valueOrNull;
  if (own == null || households == null) return DateTime.monday;
  for (final h in households) {
    if (h['id']?.toString() != own) continue;
    final v = (h['preferences'] as Map?)?['firstDayOfWeek'];
    if (v is num) return dartWeekdayFromMealie(v.toInt());
  }
  return DateTime.monday;
});

/// Wochenbeginn in Mealie ändern (eigener Haushalt; Recht „Haushalt
/// verwalten"). PUT ersetzt ALLE Haushalts-Einstellungen → aktuellen Stand
/// holen, nur `firstDayOfWeek` ändern. Danach die Haushaltsliste neu laden,
/// damit Essensplan und Webapp sofort übereinstimmen.
Future<void> setHouseholdFirstDayOfWeek(WidgetRef ref, int mealieDay) async {
  final api = ref.read(apiServiceProvider);
  final current = await api.fetchHouseholdPreferences();
  const keys = [
    'privateHousehold',
    'lockRecipeEditsFromOtherHouseholds',
    'firstDayOfWeek',
    'showAnnouncements',
    'recipePublic',
    'recipeShowNutrition',
    'recipeShowAssets',
    'recipeLandscapeView',
    'recipeDisableComments',
  ];
  await api.updateHouseholdPreferences({
    for (final k in keys)
      if (current.containsKey(k)) k: current[k],
    'firstDayOfWeek': mealieDay,
  });
  await ref.read(householdsListProvider.notifier).refresh();
}

/// ISO-8601 week number — mirrors iOS calendarWeekNumber()
int isoWeekNumber(DateTime date) {
  // In UTC rechnen: lokal fehlte im Sommer eine Stunde zum 1. Januar,
  // `inDays` rundete ab — 2026 war die KW von April bis Oktober um 1 zu klein.
  final d = DateTime.utc(date.year, date.month, date.day);
  // Thursday in current week decides the year
  final thursday = DateTime.utc(d.year, d.month, d.day + 4 - d.weekday);
  final firstDayOfYear = DateTime.utc(thursday.year, 1, 1);
  final diff = thursday.difference(firstDayOfYear).inDays;
  return 1 + (diff ~/ 7);
}

// ---------------------------------------------------------------------------
// Current week start (the week currently being viewed) — mirrors iOS currentWeekStart
// ---------------------------------------------------------------------------

// Hängt am Wochenbeginn aus Mealie: ändert er sich, springt die Ansicht auf
// die aktuelle Woche mit dem neuen Starttag.
final currentWeekStartProvider = StateProvider<DateTime>(
    (ref) => startOfWeek(DateTime.now(), ref.watch(weekStartWeekdayProvider)));

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
    // Innerhalb eines Tages in Mahlzeiten-Reihenfolge (Frühstück … Nachspeise)
    // — stabil, damit gleiche Typen ihre Reihenfolge behalten.
    for (final list in map.values) {
      mergeSort(list,
          compare: (a, b) =>
              mealTypeOrder(a.entryType).compareTo(mealTypeOrder(b.entryType)));
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

  /// Eintrag verschieben (Tag und/oder Mahlzeit). Optimistisch lokal,
  /// danach mit dem Server-Echo ersetzen; bei Fehler alter Stand zurück und
  /// Fehler weiterreichen (UI zeigt ihn).
  Future<void> moveEntry(MealplanEntry entry,
      {required String date, required String entryType}) async {
    final before = state.valueOrNull;
    final moved = MealplanEntry.fromJson(
        {...entry.toJson(), 'date': date, 'entryType': entryType});
    List<MealplanEntry> replaced(MealplanEntry with_) => [
          for (final e in _flatten(state.valueOrNull))
            if (e.id == entry.id) with_ else e
        ];
    state = AsyncData(_groupByDay(replaced(moved)));
    try {
      final saved = await ref
          .read(apiServiceProvider)
          .updateMealplanEntry(entry, date: date, entryType: entryType);
      state = AsyncData(_groupByDay(replaced(saved)));
      await _persistState();
    } catch (e) {
      if (before != null) state = AsyncData(before);
      rethrow;
    }
  }

  /// Portionen-Faktor eines Eintrags setzen (Mealie ≥ 3.29) — optimistisch
  /// wie [moveEntry], das Rezept selbst bleibt unverändert.
  Future<void> setRecipeScale(MealplanEntry entry, double scale) async {
    final before = state.valueOrNull;
    List<MealplanEntry> replaced(MealplanEntry with_) => [
          for (final e in _flatten(state.valueOrNull))
            if (e.id == entry.id) with_ else e
        ];
    state = AsyncData(_groupByDay(replaced(
        MealplanEntry.fromJson({...entry.toJson(), 'recipeScale': scale}))));
    try {
      final saved = await ref.read(apiServiceProvider).updateMealplanEntry(
          entry,
          date: entry.date,
          entryType: entry.entryType,
          recipeScale: scale);
      state = AsyncData(_groupByDay(replaced(saved)));
      await _persistState();
    } catch (e) {
      if (before != null) state = AsyncData(before);
      rethrow;
    }
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
    }
    try {
      await ref.read(apiServiceProvider).deleteMealplanEntry(id);
      await _persistState();
    } catch (e) {
      // Wie moveEntry: scheitert der Server (offline, kein Recht), den
      // Eintrag zurückholen — sonst fehlte er lokal und tauchte beim
      // nächsten Abgleich kommentarlos wieder auf.
      if (current != null) state = AsyncData(current);
      rethrow;
    }
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
  final weekEndExclusive = addDays(weekStartDay, 7);

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
  final firstWeekday = ref.watch(weekStartWeekdayProvider);

  // collect distinct week-starts (excluding current week) with counts
  final weekCounts = <DateTime, int>{};
  all.forEach((day, entries) {
    final ws = startOfWeek(day, firstWeekday);
    if (ws == currentWeekStart) return;
    weekCounts[ws] = (weekCounts[ws] ?? 0) + entries.length;
  });

  final list = weekCounts.entries
      .map((e) => WeekInfo(weekStart: e.key, count: e.value))
      .toList()
    ..sort((a, b) => a.weekStart.compareTo(b.weekStart));
  return list;
});
