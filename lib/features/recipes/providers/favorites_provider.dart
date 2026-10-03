import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/settings_provider.dart';

// ---------------------------------------------------------------------------
// Favoriten („Herz") — Set der favorisierten Rezept-IDs des aktuellen Users.
//
// Geladen aus GET /api/users/self/favorites. `toggle` aktualisiert optimistisch
// und ruft POST/DELETE /api/users/{id}/favorites/{slug} (echter Slug!).
// ---------------------------------------------------------------------------

final favoritesProvider = AsyncNotifierProvider<FavoritesNotifier, Set<String>>(
    FavoritesNotifier.new);

class FavoritesNotifier extends AsyncNotifier<Set<String>> {
  static const _cacheKey = 'cache_favorite_recipe_ids';

  // Cache-first (Offline-Prinzip): letzter Stand sofort — z. B. für die
  // Favoriten-Kachel ohne Netz —, frischer Stand im Hintergrund.
  Future<Set<String>?> _loadCache() async {
    try {
      final l =
          (await SharedPreferences.getInstance()).getStringList(_cacheKey);
      return l?.toSet();
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveCache(Set<String> ids) async {
    try {
      await (await SharedPreferences.getInstance())
          .setStringList(_cacheKey, ids.toList());
    } catch (_) {}
  }

  @override
  Future<Set<String>> build() async {
    // Erst Settings awaiten (Cold-Start-Race), dann erst den ApiService greifen
    // — sonst hat Dio noch keine baseUrl. Gleiche Regel wie in recipesProvider.
    final settings = await ref.watch(settingsProvider.future);
    if (!settings.isConfigured) return <String>{};
    final api = ref.read(apiServiceProvider);
    final cached = await _loadCache();
    Future<Set<String>> fetch() async {
      final fresh = await api.fetchFavoriteRecipeIds();
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
      // Ältere/abweichende Server ohne den Endpoint → leer, App bleibt nutzbar.
      return <String>{};
    }
  }

  bool isFavorite(String recipeId) =>
      state.valueOrNull?.contains(recipeId) ?? false;

  /// Schaltet den Favoriten-Status um. [id] = Rezept-UUID (State-Key),
  /// [slug] = echter Slug (für den Endpoint). Optimistisch mit Rollback.
  Future<void> toggle({required String id, required String slug}) async {
    final current = state.valueOrNull ?? <String>{};
    final willFavorite = !current.contains(id);

    final next = {...current};
    if (willFavorite) {
      next.add(id);
    } else {
      next.remove(id);
    }
    state = AsyncData(next);

    try {
      await ref.read(apiServiceProvider).setFavorite(slug, willFavorite);
      await _saveCache(next);
    } catch (e) {
      // Bei Fehler den vorherigen Zustand wiederherstellen.
      state = AsyncData(current);
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final settings = ref.read(settingsProvider).valueOrNull;
      if (settings == null || !settings.isConfigured) return <String>{};
      final fresh = await ref.read(apiServiceProvider).fetchFavoriteRecipeIds();
      await _saveCache(fresh);
      return fresh;
    });
  }
}
