import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_service.dart';
import '../services/local_cache.dart';

// ---------------------------------------------------------------------------
// Cache-first für einfache Server-Listen (JSON-Objekte): sofort aus dem
// lokalen Cache anzeigen, im Hintergrund frisch holen und speichern, bei
// Fehlschlag den Cache behalten. Nur ohne Cache wird auf den Server gewartet.
// ---------------------------------------------------------------------------

abstract class CachedJsonListNotifier
    extends AsyncNotifier<List<Map<String, dynamic>>> {
  /// Schlüssel in LocalCache (ohne `cache_`-Präfix).
  String get cacheKey;

  Future<List<Map<String, dynamic>>> fetch(ApiService api);

  @override
  Future<List<Map<String, dynamic>>> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadJsonList(cacheKey);
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await _fetchAndStore(api));
        } catch (_) {/* Cache behalten */}
      });
      return cached;
    }
    return _fetchAndStore(api);
  }

  Future<List<Map<String, dynamic>>> _fetchAndStore(ApiService api) async {
    final list = await fetch(api);
    await LocalCache.saveJsonList(cacheKey, list);
    return list;
  }

  /// Nach Änderungen: frisch holen, bei Fehlschlag den Stand behalten.
  Future<void> refresh() async {
    try {
      state = AsyncData(await _fetchAndStore(ref.read(apiServiceProvider)));
    } catch (_) {/* Stand behalten */}
  }
}

/// Alle Haushalte der Gruppe (Auswahllisten: Benutzer bearbeiten,
/// Filter-Baukasten).
final householdsListProvider =
    AsyncNotifierProvider<_HouseholdsListNotifier, List<Map<String, dynamic>>>(
        _HouseholdsListNotifier.new);

class _HouseholdsListNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'households_list';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchHouseholds();
}

/// Mitglieder des eigenen Haushalts (Filter-Baukasten „Benutzer").
final householdMembersProvider = AsyncNotifierProvider<
    _HouseholdMembersNotifier,
    List<Map<String, dynamic>>>(_HouseholdMembersNotifier.new);

class _HouseholdMembersNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'household_members';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchHouseholdMembers();
}

/// Alle Benutzer der Gruppe (Rezept-Besitzer wählen).
final groupMembersProvider =
    AsyncNotifierProvider<_GroupMembersNotifier, List<Map<String, dynamic>>>(
        _GroupMembersNotifier.new);

class _GroupMembersNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'group_members';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) =>
      api.fetchGroupMembers();
}

/// Server-Infos (/api/app/about) als Ein-Element-Liste — Version und
/// `enableOpenai`. Cache-first wie alles andere.
final serverInfoProvider =
    AsyncNotifierProvider<_ServerInfoNotifier, List<Map<String, dynamic>>>(
        _ServerInfoNotifier.new);

class _ServerInfoNotifier extends CachedJsonListNotifier {
  @override
  String get cacheKey => 'server_info';
  @override
  Future<List<Map<String, dynamic>>> fetch(ApiService api) async =>
      [await api.fetchServerInfo()];
}
