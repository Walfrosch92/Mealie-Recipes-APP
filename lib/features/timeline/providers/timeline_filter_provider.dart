import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/timeline_event.dart';
import '../../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Filter nach Eintragstyp (wie die Webapp): `comment` (Gekocht & Notizen),
// `info`, `system`. Gilt für Gesamt-Zeitleiste und Rezept-Abschnitt, wird
// lokal gespeichert. Leere Auswahl ist nicht erlaubt (mind. ein Typ).
// ---------------------------------------------------------------------------

const kTimelineEventTypes = ['comment', 'info', 'system'];
const _prefsKey = 'timelineEventTypes';

final timelineTypeFilterProvider =
    NotifierProvider<TimelineTypeFilterNotifier, Set<String>>(
        TimelineTypeFilterNotifier.new);

class TimelineTypeFilterNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    Future(() async {
      try {
        final saved =
            (await SharedPreferences.getInstance()).getStringList(_prefsKey);
        final valid = saved?.where(kTimelineEventTypes.contains).toSet();
        if (valid != null && valid.isNotEmpty) state = valid;
      } catch (_) {}
    });
    return kTimelineEventTypes.toSet();
  }

  void toggle(String type) {
    final next = {...state};
    if (!next.remove(type)) next.add(type);
    if (next.isEmpty) return;
    state = next;
    SharedPreferences.getInstance()
        .then((p) => p.setStringList(_prefsKey, next.toList()))
        .catchError((_) => true);
  }
}

/// Einträge, deren Typ im Filter ist (unbekannte Typen zählen als `info`).
List<TimelineEvent> applyTimelineFilter(
        List<TimelineEvent> events, Set<String> types) =>
    [
      for (final e in events)
        if (types.contains(
            kTimelineEventTypes.contains(e.eventType) ? e.eventType : 'info'))
          e,
    ];

String timelineTypeLabel(AppLocalizations l, String type) => switch (type) {
      'comment' => l.timelineTypeComment,
      'system' => l.timelineTypeSystem,
      _ => l.timelineTypeInfo,
    };

/// Filter-Knopf (Trichter; gefüllt, wenn nicht alle Typen gezeigt werden).
class TimelineFilterButton extends ConsumerWidget {
  const TimelineFilterButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final types = ref.watch(timelineTypeFilterProvider);
    final active = types.length < kTimelineEventTypes.length;
    return IconButton(
      tooltip: l.timelineFilter,
      visualDensity: VisualDensity.compact,
      icon: Icon(active ? Icons.filter_alt_rounded : Icons.filter_alt_outlined,
          color: active ? AppTokens.accentDeep : context.appFgSub),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        useRootNavigator: true,
        backgroundColor: context.appCard,
        builder: (_) => const _FilterSheet(),
      ),
    );
  }
}

class _FilterSheet extends ConsumerWidget {
  const _FilterSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final types = ref.watch(timelineTypeFilterProvider);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
            child: Text(l.timelineFilter,
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    color: context.appFg,
                    fontSize: 17,
                    fontWeight: FontWeight.w800)),
          ),
          for (final t in kTimelineEventTypes)
            CheckboxListTile(
              value: types.contains(t),
              title: Text(timelineTypeLabel(l, t),
                  style: TextStyle(color: context.appFg)),
              // Letzten aktiven Typ nicht abwählbar machen.
              onChanged: types.length == 1 && types.contains(t)
                  ? null
                  : (_) =>
                      ref.read(timelineTypeFilterProvider.notifier).toggle(t),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
