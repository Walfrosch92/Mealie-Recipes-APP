import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/utils/server_time.dart';

// ---------------------------------------------------------------------------
// „Wirklich gekocht" für den Haken im Essensplan.
//
// Mealie trägt per nächtlichem Job JEDEN Rezept-Eintrag des Tages als
// „<Name> made this for dinner" (Typ `info`) in die Zeitleiste ein und setzt
// lastMade — auch wenn gar nicht gekocht wurde. Der Haken zählt deshalb nur
// echte „Ich hab's gemacht"-Einträge (Typ `comment`, wie die Webapp sie
// anlegt) und nicht lastMade.
//
// Markierung = "<recipeId>|<yyyy-mm-dd lokal>". Cache-first je Woche.
// ---------------------------------------------------------------------------

String cookedMarkKey(String recipeId, DateTime localDay) =>
    '$recipeId|${localDay.year.toString().padLeft(4, '0')}-'
    '${localDay.month.toString().padLeft(2, '0')}-'
    '${localDay.day.toString().padLeft(2, '0')}';

/// Server-Markierungen ab [weekStart] für 14 Tage (auch nachträglich in der
/// Folgewoche gekocht).
final cookedMarksProvider = AsyncNotifierProvider.autoDispose
    .family<CookedMarksNotifier, Set<String>, DateTime>(
  CookedMarksNotifier.new,
);

class CookedMarksNotifier
    extends AutoDisposeFamilyAsyncNotifier<Set<String>, DateTime> {
  String get _key => 'cooked_marks_${arg.toIso8601String().substring(0, 10)}';

  @override
  Future<Set<String>> build(DateTime arg) async {
    final api = ref.watch(apiServiceProvider);
    final cached = {
      for (final m in await LocalCache.loadJsonList(_key))
        if (m['k'] is String) m['k'] as String
    };
    Future<Set<String>> fetch() async {
      // Je einen Tag Puffer — gefiltert wird lokal nach Ortszeit.
      final events = await api.fetchTimelineEventsBetween(
          arg.subtract(const Duration(days: 1)),
          arg.add(const Duration(days: 15)));
      final marks = <String>{
        for (final e in events)
          if (e.eventType == 'comment' && e.recipeId.isNotEmpty)
            if (parseMealieTime(e.timestamp) case final t?)
              cookedMarkKey(e.recipeId, t),
      };
      await LocalCache.saveJsonList(_key, [
        for (final k in marks) {'k': k}
      ]);
      return marks;
    }

    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await fetch());
        } catch (_) {/* offline → Cache behalten */}
      });
      return cached;
    }
    try {
      return await fetch();
    } catch (_) {
      return const {};
    }
  }
}

/// Lokal gerade erfasstes „Ich hab's gemacht" (auch offline vorgemerkt) —
/// zeigt den Haken sofort, bis der Server-Stand nachzieht.
final localCookedMarksProvider = StateProvider<Set<String>>((_) => const {});
