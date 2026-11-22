import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/recipe_detail.dart';
import '../../../core/providers/settings_provider.dart';

// ---------------------------------------------------------------------------
// Eigene Bewertungen des Benutzers (recipeId → Sterne). Mealie trennt sie vom
// Rezept-Durchschnitt (`recipe.rating`): die Webapp zeigt beim Bewerten die
// EIGENE, der Server sortiert/filtert nach „eigene, sonst Durchschnitt"
// (repository_recipes._get_rating_col_alias). Cache-first wie die Favoriten.
// ---------------------------------------------------------------------------

final userRatingsProvider =
    AsyncNotifierProvider<UserRatingsNotifier, Map<String, double>>(
        UserRatingsNotifier.new);

/// Bewertung wie Mealie beim Sortieren/Filtern: eigene, sonst Durchschnitt
/// (0 = keine).
double? effectiveRating(RecipeDetail r, Map<String, double> own) {
  final mine = own[r.id];
  if (mine != null && mine > 0) return mine;
  final avg = r.rating;
  return (avg == null || avg == 0) ? null : avg;
}

class UserRatingsNotifier extends AsyncNotifier<Map<String, double>> {
  static const _cacheKey = 'cache_user_ratings';

  Future<Map<String, double>?> _loadCache() async {
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_cacheKey);
      if (raw == null) return null;
      return (jsonDecode(raw) as Map)
          .map((k, v) => MapEntry(k.toString(), (v as num).toDouble()));
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(Map<String, double> m) async {
    try {
      await (await SharedPreferences.getInstance())
          .setString(_cacheKey, jsonEncode(m));
    } catch (_) {}
  }

  @override
  Future<Map<String, double>> build() async {
    final settings = await ref.watch(settingsProvider.future);
    if (!settings.isConfigured) return const {};
    final api = ref.read(apiServiceProvider);
    final cached = await _loadCache();
    Future<Map<String, double>> fetch() async {
      final fresh = await api.fetchSelfRatings();
      await _saveCache(fresh);
      return fresh;
    }

    if (cached != null) {
      Future(() async {
        try {
          state = AsyncData(await fetch());
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    try {
      return await fetch();
    } catch (_) {
      return const {};
    }
  }

  /// Nach erfolgreichem Setzen/Entfernen lokal nachziehen (0 = entfernt).
  Future<void> setLocal(String recipeId, double rating) async {
    final next = {...?state.valueOrNull};
    if (rating > 0) {
      next[recipeId] = rating;
    } else {
      next.remove(recipeId);
    }
    state = AsyncData(next);
    await _saveCache(next);
  }

  Future<double?> fetchOwn(String recipeId) async {
    final fresh = await ref.read(apiServiceProvider).fetchSelfRatings();
    await _saveCache(fresh);
    state = AsyncData(fresh);
    return fresh[recipeId];
  }
}
