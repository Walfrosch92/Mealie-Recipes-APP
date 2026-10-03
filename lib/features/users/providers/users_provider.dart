import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/services/local_cache.dart';

// ---------------------------------------------------------------------------
// Benutzer für die Benutzerverwaltung — Admins sehen ALLE Benutzer
// (/api/admin/users), Nutzer mit „Verwalten" die Mitglieder ihres Haushalts
// (/api/households/members), alle anderen nur sich selbst (/users/self).
// Cache-first wie überall (Anzeige offline),
// Änderungen gehen nur online.
// ---------------------------------------------------------------------------

String userDisplayName(Map<String, dynamic> u) {
  final full = (u['fullName'] as String?)?.trim() ?? '';
  if (full.isNotEmpty) return full;
  return (u['username'] as String?)?.trim() ?? '';
}

final usersProvider =
    AsyncNotifierProvider<UsersNotifier, List<Map<String, dynamic>>>(
        UsersNotifier.new);

class UsersNotifier extends AsyncNotifier<List<Map<String, dynamic>>> {
  bool get _admin => ref.read(userPermissionsProvider).admin;
  bool get _manager => ref.read(userPermissionsProvider).mayManageUsers;
  String get _key => _admin
      ? 'users_admin'
      : _manager
          ? 'users_members'
          : 'users_self';

  @override
  Future<List<Map<String, dynamic>>> build() async {
    final api = ref.watch(apiServiceProvider);
    ref.watch(userPermissionsProvider.select((p) => p.admin));
    ref.watch(userPermissionsProvider.select((p) => p.mayManageUsers));
    final cached = await LocalCache.loadJsonList(_key);
    if (cached.isNotEmpty) {
      Future(() async {
        try {
          state = AsyncData(await _fetch(api));
        } catch (_) {/* Cache behalten */}
      });
      return _sorted(cached);
    }
    return _fetch(api);
  }

  Future<List<Map<String, dynamic>>> _fetch(ApiService api) async {
    final list = _sorted(_admin
        ? await api.fetchAllUsers()
        : _manager
            ? await api.fetchHouseholdMembers()
            // Normale Benutzer: nur das eigene Konto.
            : [await api.fetchCurrentUser()]);
    await LocalCache.saveJsonList(_key, list);
    return list;
  }

  List<Map<String, dynamic>> _sorted(List<Map<String, dynamic>> l) =>
      [...l]..sort((a, b) => userDisplayName(a)
          .toLowerCase()
          .compareTo(userDisplayName(b).toLowerCase()));

  Future<void> refresh() async {
    try {
      state = AsyncData(await _fetch(ref.read(apiServiceProvider)));
    } catch (_) {/* Stand behalten */}
  }

  List<Map<String, dynamic>> get _current => state.valueOrNull ?? const [];

  Future<void> _store(List<Map<String, dynamic>> list) async {
    final sorted = _sorted(list);
    state = AsyncData(sorted);
    await LocalCache.saveJsonList(_key, sorted);
  }

  void _replace(Map<String, dynamic> u) =>
      _store([for (final m in _current) m['id'] == u['id'] ? u : m]);

  Future<void> create(Map<String, dynamic> data) async {
    final created = await ref.read(apiServiceProvider).createUser(data);
    await _store([..._current, created]);
  }

  /// Admin: Benutzer mit den geänderten Feldern speichern (vorher den
  /// vollständigen Server-Stand holen — PUT ersetzt alles).
  Future<void> saveUser(String id, Map<String, dynamic> changes) async {
    final api = ref.read(apiServiceProvider);
    final full = await api.fetchUser(id);
    final updated = await api.updateUser({...full, ...changes});
    _replace(updated);
  }

  /// Eigenes Konto (jeder Benutzer): Name, Benutzername, E-Mail. Danach
  /// auch den angemeldeten Benutzer (Begrüßung, Rechte) aktualisieren.
  Future<void> saveSelf(Map<String, dynamic> changes) async {
    final updated = await ref.read(apiServiceProvider).updateSelf(changes);
    await ref.read(currentUserProvider.notifier).replace(updated);
    if (_current.any((m) => m['id'] == updated['id'])) {
      _replace(updated);
    } else {
      await _store([..._current, updated]);
    }
  }

  Future<void> delete(String id) async {
    await ref.read(apiServiceProvider).deleteUser(id);
    await _store(_current.where((m) => m['id'] != id).toList());
  }

  /// Nicht-Admin mit „Verwalten": nur die vier Rechte eines Mitglieds.
  Future<void> setPermissions(String id,
      {required bool canManageHousehold,
      required bool canManage,
      required bool canInvite,
      required bool canOrganize}) async {
    final updated = await ref.read(apiServiceProvider).setMemberPermissions(
          id,
          canManageHousehold: canManageHousehold,
          canManage: canManage,
          canInvite: canInvite,
          canOrganize: canOrganize,
        );
    _replace(updated);
  }
}
