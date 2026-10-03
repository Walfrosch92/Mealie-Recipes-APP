import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/models/organizer_item.dart';
import '../../../core/services/local_cache.dart';
import '../../../core/services/log_manager.dart';
import '../../recipes/providers/recipes_provider.dart';

// ---------------------------------------------------------------------------
// Kategorien / Schlagworte / Utensilien verwalten — ein Provider pro Art.
//
// Offline-first wie überall: sofort aus dem Cache, im Hintergrund vom Server
// abgleichen; schlägt der Abgleich fehl, bleibt der Cache stehen.
// Änderungen (Anlegen/Umbenennen/Löschen) gehen direkt an den Server und
// werden danach lokal nachgezogen — inkl. aller geladenen Rezepte, damit
// Detailansicht/Filter sofort den neuen Namen zeigen.
// ---------------------------------------------------------------------------

final organizersProvider = AsyncNotifierProvider.family<OrganizersNotifier,
    List<OrganizerItem>, OrganizerKind>(OrganizersNotifier.new);

class OrganizersNotifier
    extends FamilyAsyncNotifier<List<OrganizerItem>, OrganizerKind> {
  @override
  Future<List<OrganizerItem>> build(OrganizerKind kind) async {
    final cached = await LocalCache.loadOrganizers(kind);
    if (cached.isEmpty) return _fetch();
    unawaited(_refreshInBackground());
    return _sorted(cached);
  }

  Future<List<OrganizerItem>> _fetch() async {
    final items =
        _sorted(await ref.read(apiServiceProvider).fetchOrganizers(arg));
    await LocalCache.saveOrganizers(arg, items);
    return items;
  }

  Future<void> _refreshInBackground() async {
    try {
      final items = await _fetch();
      state = AsyncData(items);
    } catch (e) {
      LogManager.shared.log('⚠️ ${arg.path} nicht aktualisiert: $e');
    }
  }

  /// Pull-to-Refresh.
  Future<void> refresh() => _refreshInBackground();

  List<OrganizerItem> _sorted(List<OrganizerItem> items) => List.of(items)
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

  Future<void> _set(List<OrganizerItem> items) async {
    final sorted = _sorted(items);
    state = AsyncData(sorted);
    await LocalCache.saveOrganizers(arg, sorted);
  }

  List<OrganizerItem> get _current => state.valueOrNull ?? const [];

  /// Legt [name] an — oder liefert einen bereits vorhandenen Eintrag gleichen
  /// Namens (Mealie hat einen UNIQUE-Slug pro Gruppe; ein Duplikat endet in
  /// HTTP 500). Vorher frisch vom Server holen, der Cache kann veraltet sein.
  Future<OrganizerItem> create(String name) async {
    final api = ref.read(apiServiceProvider);
    final target = name.trim().toLowerCase();
    final server = await api.fetchOrganizers(arg);
    for (final i in server) {
      if (i.name.trim().toLowerCase() == target) {
        await _set(server);
        return i;
      }
    }
    final created = await api.createOrganizer(arg, name.trim());
    await _set([...server, created]);
    return created;
  }

  Future<void> rename(OrganizerItem item, String name) async {
    final updated = await ref
        .read(apiServiceProvider)
        .updateOrganizer(arg, item.copyWith(name: name.trim()));
    await _set([
      for (final i in _current) i.id == item.id ? updated : i,
    ]);
    await ref
        .read(recipesProvider.notifier)
        .renameOrganizerEverywhere(arg, item.id, updated.name);
  }

  Future<void> delete(OrganizerItem item) async {
    await ref.read(apiServiceProvider).deleteOrganizer(arg, item.id);
    await _set(_current.where((i) => i.id != item.id).toList());
    await ref
        .read(recipesProvider.notifier)
        .stripOrganizerEverywhere(arg, item.id);
  }

  /// Nur Utensilien: „im eigenen Haushalt vorhanden" umschalten. Andere
  /// Haushalte in `householdsWithTool` bleiben unangetastet.
  Future<void> setOnHand(
      OrganizerItem item, String householdSlug, bool onHand) async {
    final others =
        item.householdsWithTool.where((h) => h != householdSlug).toList();
    final next = item.copyWith(
        householdsWithTool: onHand ? [...others, householdSlug] : others);
    // Optimistisch umschalten, bei Fehler zurück.
    final before = _current;
    await _set([for (final i in before) i.id == item.id ? next : i]);
    try {
      await ref.read(apiServiceProvider).updateOrganizer(arg, next);
    } catch (e) {
      await _set(before);
      rethrow;
    }
  }
}

/// Slug des eigenen Haushalts (für „Utensil vorhanden"). Cache-first: der
/// zuletzt bekannte Slug gilt sofort (auch offline), der Server-Stand wird
/// im Hintergrund nachgezogen. `null` nur, wenn er noch nie ermittelt werden
/// konnte — der Schalter wird dann versteckt.
final ownHouseholdSlugProvider =
    AsyncNotifierProvider<OwnHouseholdSlugNotifier, String?>(
        OwnHouseholdSlugNotifier.new);

class OwnHouseholdSlugNotifier extends AsyncNotifier<String?> {
  static const _key = 'own_household';

  @override
  Future<String?> build() async {
    final api = ref.watch(apiServiceProvider);
    final cached = await LocalCache.loadJsonList(_key);
    final cachedSlug = cached.isEmpty ? null : cached.first['slug']?.toString();
    if (cachedSlug != null && cachedSlug.isNotEmpty) {
      Future(() async {
        final fresh = await _fetch(api);
        if (fresh != null && fresh != cachedSlug) state = AsyncData(fresh);
      });
      return cachedSlug;
    }
    return _fetch(api);
  }

  Future<String?> _fetch(ApiService api) async {
    try {
      final h = await api.fetchSelfHousehold();
      final slug = h?['slug']?.toString();
      if (slug == null || slug.isEmpty) return null;
      await LocalCache.saveJsonList(_key, [
        {'id': h?['id'], 'slug': slug, 'name': h?['name']}
      ]);
      return slug;
    } catch (_) {
      return null;
    }
  }
}
