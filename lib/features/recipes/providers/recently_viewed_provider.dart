import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// „Zuletzt angesehen" (Kachel) — IDs der zuletzt geöffneten Rezepte, neueste
// zuerst, nur lokal auf diesem Gerät (Mealie kennt keinen Verlauf). Wird beim
// Öffnen der Detailansicht gefüllt und gegen den Rezept-Cache aufgelöst →
// offline nutzbar; gelöschte Rezepte fallen dabei einfach weg.
// ---------------------------------------------------------------------------

const _kRecentlyViewed = 'recently_viewed_recipe_ids';
const _maxEntries = 30;

final recentlyViewedProvider =
    NotifierProvider<RecentlyViewedNotifier, List<String>>(
        RecentlyViewedNotifier.new);

class RecentlyViewedNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    _load();
    return const [];
  }

  Future<void> _load() async {
    try {
      final ids = (await SharedPreferences.getInstance())
          .getStringList(_kRecentlyViewed);
      if (ids == null || ids.isEmpty) return;
      // Wurde vor dem Laden schon etwas geöffnet, steht es vorne — den
      // gespeicherten Verlauf dahinter anhängen statt ihn zu verlieren.
      final merged = [
        ...state,
        ...ids.where((id) => !state.contains(id)),
      ].take(_maxEntries).toList();
      final hadNew = state.isNotEmpty;
      state = merged;
      if (hadNew) _save();
    } catch (_) {}
  }

  /// Rezept an den Anfang setzen (doppelte Einträge werden verschoben).
  void record(String recipeId) {
    if (recipeId.isEmpty) return;
    if (state.isNotEmpty && state.first == recipeId) return;
    state = [
      recipeId,
      ...state.where((id) => id != recipeId),
    ].take(_maxEntries).toList();
    _save();
  }

  void remove(String recipeId) {
    state = state.where((id) => id != recipeId).toList();
    _save();
  }

  void clear() {
    state = const [];
    _save();
  }

  Future<void> _save() async {
    try {
      await (await SharedPreferences.getInstance())
          .setStringList(_kRecentlyViewed, state);
    } catch (_) {}
  }
}
