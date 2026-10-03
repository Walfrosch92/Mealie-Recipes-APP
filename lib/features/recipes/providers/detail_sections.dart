import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Ein-/Ausklappen der Bereiche in der Rezeptdetailansicht (Nährwerte,
// Utensilien, Notizen, Kommentare) — gilt für alle Rezepte, bleibt
// gespeichert.
//
// Bewusst NICHT in AppSettings: dort löste jeder Tipp ein Speichern aller
// ~40 Einstellungen aus, der neue Zustand kam erst danach an, und weil die
// Detailseite an den Einstellungen hängt, baute sie sich komplett neu auf —
// oft mitten in die Animation hinein (ruckelig). Hier schaltet der Zustand
// sofort um, gespeichert wird nur dieser eine Key, im Hintergrund.
// ---------------------------------------------------------------------------

abstract final class DetailSection {
  static const nutrition = 'nutrition';
  static const tools = 'tools';
  static const notes = 'notes';
  static const comments = 'comments';
  static const assets = 'assets';
  static const timeline = 'timeline';
}

const kCollapsedDetailSectionsKey = 'collapsedDetailSections';
const _prefsKey = kCollapsedDetailSectionsKey;

/// In `main()` synchron aus SharedPreferences vorbelegt, damit ein
/// zugeklappter Bereich schon im ersten Frame zu ist (kein Aufblitzen).
final initialCollapsedDetailSectionsProvider =
    Provider<Set<String>>((ref) => const {});

final collapsedDetailSectionsProvider =
    NotifierProvider<CollapsedDetailSections, Set<String>>(
        CollapsedDetailSections.new);

class CollapsedDetailSections extends Notifier<Set<String>> {
  @override
  Set<String> build() => ref.read(initialCollapsedDetailSectionsProvider);

  void toggle(String key) {
    HapticFeedback.selectionClick();
    final next = Set<String>.of(state);
    if (!next.remove(key)) next.add(key);
    state = next; // sofort — Speichern läuft hinterher
    unawaited(SharedPreferences.getInstance()
        .then((p) => p.setStringList(_prefsKey, next.toList()))
        .catchError((_) => false));
  }
}

/// Baut nur neu, wenn sich GENAU dieser Bereich ändert.
bool isDetailSectionExpanded(WidgetRef ref, String key) =>
    !ref.watch(collapsedDetailSectionsProvider.select((s) => s.contains(key)));

void toggleDetailSection(WidgetRef ref, String key) =>
    ref.read(collapsedDetailSectionsProvider.notifier).toggle(key);
