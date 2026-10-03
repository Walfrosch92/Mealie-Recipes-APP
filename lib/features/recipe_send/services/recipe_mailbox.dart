import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/api/api_service.dart';
import '../../../core/services/log_manager.dart';

// ---------------------------------------------------------------------------
// Rezept-Postfach auf dem Mealie-Server — Zustellung, auch wenn das Zielgerät
// gerade nicht online ist.
//
// Mealie hat keinen Nachrichtendienst. Deshalb dient eine eigene, in der App
// ausgeblendete Einkaufsliste ([kRecipeMailboxListName]) als Briefkasten:
//   • Geräte-Eintrag  {t:"dev",  id, name, user, seen} — jedes Gerät trägt sich
//     ein, damit es auch offline in der „Senden an"-Auswahl erscheint.
//   • Sendung          {t:"send", sendId, to, toName, from, fromName,
//                       recipeId, recipeName, ts}
// Der Empfänger holt seine Sendungen beim Start/Zurückkehren ab, lädt das
// Rezept per ID vom (gemeinsamen) Mealie-Server und löscht den Eintrag.
// Funktioniert für alle Geräte im selben Mealie-Haushalt — Einkaufslisten
// sind haushaltsbezogen.
// ---------------------------------------------------------------------------

const _notePrefix = 'mealie-recipes:';
const _listIdPrefsKey = 'recipe_mailbox_list_id';

/// Geräte-Eintrag nur so oft erneuern (spart Schreibzugriffe).
const _heartbeatEvery = Duration(hours: 12);

/// Geräte, die so lange nicht mehr da waren, werden nicht mehr angeboten.
const _deviceMaxAge = Duration(days: 60);

/// Nicht abgeholte Sendungen verfallen danach.
const _sendMaxAge = Duration(days: 30);

class MailboxDevice {
  final String id;
  final String name;
  final DateTime seen;
  const MailboxDevice(this.id, this.name, this.seen);
}

class MailboxDelivery {
  final String itemId;
  final String sendId;
  final String recipeId;
  final String recipeName;
  final String fromName;
  const MailboxDelivery({
    required this.itemId,
    required this.sendId,
    required this.recipeId,
    required this.recipeName,
    required this.fromName,
  });
}

class MailboxSnapshot {
  final List<MailboxDevice> devices;
  final List<MailboxDelivery> deliveries;
  const MailboxSnapshot(this.devices, this.deliveries);
}

class _Entry {
  final String itemId;
  final Map<String, dynamic> data;
  const _Entry(this.itemId, this.data);

  String get type => data['t'] as String? ?? '';
  DateTime? get time =>
      DateTime.tryParse((data['seen'] ?? data['ts'] ?? '') as String);
}

class RecipeMailbox {
  final ApiService api;
  final String deviceId;
  final String deviceName;

  /// Mealie-Benutzer-ID dieses Geräts (kann beim Start noch fehlen).
  final String? Function() userId;

  /// Seit wann es diese Geräte-ID gibt. Nur Einträge, die zuletzt VORHER
  /// gesehen wurden, können von einer früheren Installation stammen — ein
  /// zweites, noch aktives Gerät gleichen Namens meldet sich danach erneut.
  final DateTime deviceSince;

  RecipeMailbox({
    required this.api,
    required this.deviceId,
    required this.deviceName,
    String? Function()? userId,
    DateTime? deviceSince,
  })  : userId = userId ?? (() => null),
        deviceSince = deviceSince ?? DateTime.now();

  /// Eigene frühere Geräte-IDs (App neu installiert → neue ID, alter Eintrag
  /// steht noch im Postfach). Sendungen an sie gehören auch diesem Gerät.
  final Set<String> _ownStaleIds = {};

  // ── Liste finden/anlegen ──────────────────────────────────────────────────

  Future<String?> _listId({required bool create}) async {
    final prefs = await SharedPreferences.getInstance();
    final lists = await api.fetchShoppingLists(includeMailbox: true);
    final mailboxes = lists.where(isRecipeMailboxList).toList();
    if (mailboxes.isNotEmpty) {
      // Mehrere (zwei Geräte legten gleichzeitig an)? Die älteste gewinnt —
      // alle Geräte landen so verlässlich in derselben.
      mailboxes.sort((a, b) => ((a['createdAt'] ?? a['id']) as String)
          .compareTo((b['createdAt'] ?? b['id']) as String));
      final id = mailboxes.first['id'] as String;
      await prefs.setString(_listIdPrefsKey, id);
      return id;
    }
    if (!create) return null;
    final created = await api.createShoppingList(kRecipeMailboxListName);
    final id = created['id'] as String?;
    if (id != null) await prefs.setString(_listIdPrefsKey, id);
    LogManager.shared.log('📨 SendTo: Postfach-Liste angelegt');
    return id;
  }

  Future<List<_Entry>> _entries(String listId) async {
    final items = await api.fetchShoppingListItemsRaw(listId);
    final out = <_Entry>[];
    for (final i in items) {
      final note = (i['note'] as String?) ?? '';
      final id = i['id'] as String?;
      if (id == null || !note.startsWith(_notePrefix)) continue;
      try {
        final data = jsonDecode(note.substring(_notePrefix.length));
        if (data is Map) out.add(_Entry(id, data.cast<String, dynamic>()));
      } catch (_) {/* fremder/kaputter Eintrag — ignorieren */}
    }
    return out;
  }

  Future<void> _add(String listId, Map<String, dynamic> data) =>
      api.addRawShoppingItem(listId, '$_notePrefix${jsonEncode(data)}');

  // ── Abgleich (Start/Rückkehr) ─────────────────────────────────────────────

  /// Eigenen Geräte-Eintrag auffrischen, Abgelaufenes aufräumen und
  /// bekannte Geräte + Sendungen an dieses Gerät liefern. Legt die Liste bei
  /// Bedarf an — ein Gerät muss sich eintragen, BEVOR es offline geht, sonst
  /// könnte man es dann nicht auswählen.
  Future<MailboxSnapshot> sync() async {
    final listId = await _listId(create: true);
    if (listId == null) return const MailboxSnapshot([], []);
    final entries = await _entries(listId);
    await _heartbeat(listId, entries);
    final now = DateTime.now();
    _claimOwnStaleEntries(entries);

    final devices = <String, MailboxDevice>{};
    final deliveries = <MailboxDelivery>[];
    for (final e in entries) {
      final t = e.time;
      final age = t == null ? null : now.difference(t);
      if (e.type == 'dev') {
        final id = e.data['id'] as String? ?? '';
        if (id.isEmpty || id == deviceId) continue;
        if (_ownStaleIds.contains(id)) {
          await _tryDelete(e.itemId); // eigener Alt-Eintrag
          continue;
        }
        if (age == null || age > _deviceMaxAge) {
          await _tryDelete(e.itemId);
          continue;
        }
        final known = devices[id];
        if (known == null || known.seen.isBefore(t!)) {
          devices[id] = MailboxDevice(id, e.data['name'] as String? ?? '', t!);
        }
      } else if (e.type == 'send') {
        if (age == null || age > _sendMaxAge) {
          await _tryDelete(e.itemId);
          continue;
        }
        if (!_isForMe(e.data)) continue;
        deliveries.add(MailboxDelivery(
          itemId: e.itemId,
          sendId: e.data['sendId'] as String? ?? '',
          recipeId: e.data['recipeId'] as String? ?? '',
          recipeName: e.data['recipeName'] as String? ?? '',
          fromName: e.data['fromName'] as String? ?? '',
        ));
      }
    }
    return MailboxSnapshot(devices.values.toList(), deliveries);
  }

  /// Alt-Einträge DIESES Geräts erkennen: gleicher Gerätename, gleicher
  /// Mealie-Benutzer, zuletzt gesehen bevor es diese Geräte-ID gab.
  /// Einträge ohne Benutzer (erste Postfach-Version) zählen bei gleichem
  /// Namen ebenfalls. iOS nennt alle Geräte schlicht „iPad"/„iPhone" — ohne
  /// den Benutzer-Abgleich gingen Sendungen nach einer Neuinstallation an
  /// die tote alte ID.
  void _claimOwnStaleEntries(List<_Entry> entries) {
    final me = userId();
    final myName = deviceName.trim().toLowerCase();
    if (myName.isEmpty) return;
    for (final e in entries) {
      if (e.type != 'dev') continue;
      final id = e.data['id'] as String? ?? '';
      if (id.isEmpty || id == deviceId) continue;
      final name = (e.data['name'] as String? ?? '').trim().toLowerCase();
      if (name != myName) continue;
      final user = e.data['user'] as String?;
      final sameUser = user == null || (me != null && user == me);
      final seen = e.time;
      final olderThanMe = seen != null && seen.isBefore(deviceSince);
      if (sameUser && olderThanMe) _ownStaleIds.add(id);
    }
  }

  bool _isForMe(Map<String, dynamic> d) {
    final to = d['to'] as String? ?? '';
    if (to == deviceId || _ownStaleIds.contains(to)) return true;
    // Peers ohne Geräte-ID im mDNS-TXT werden über den Namen adressiert.
    final toName = (d['toName'] as String? ?? '').trim().toLowerCase();
    return to.startsWith('name:') &&
        toName.isNotEmpty &&
        toName == deviceName.trim().toLowerCase();
  }

  Future<void> _heartbeat(String listId, List<_Entry> entries) async {
    final mine = entries
        .where((e) => e.type == 'dev' && e.data['id'] == deviceId)
        .toList()
      ..sort((a, b) =>
          (b.time ?? DateTime(2000)).compareTo(a.time ?? DateTime(2000)));
    final newest = mine.isEmpty ? null : mine.first;
    final fresh = newest != null &&
        newest.data['name'] == deviceName &&
        newest.data['user'] == userId() &&
        newest.time != null &&
        DateTime.now().difference(newest.time!) < _heartbeatEvery;
    if (fresh) {
      for (final old in mine.skip(1)) {
        await _tryDelete(old.itemId);
      }
      return;
    }
    await _add(listId, {
      't': 'dev',
      'id': deviceId,
      'name': deviceName,
      if (userId() != null) 'user': userId(),
      'seen': DateTime.now().toUtc().toIso8601String(),
    });
    for (final old in mine) {
      await _tryDelete(old.itemId);
    }
  }

  // ── Senden / Abholen ──────────────────────────────────────────────────────

  Future<void> send({
    required String sendId,
    required String targetDeviceId,
    required String targetName,
    required String recipeId,
    required String recipeName,
  }) async {
    final listId = await _listId(create: true);
    if (listId == null) throw StateError('Postfach-Liste nicht verfügbar');
    await _add(listId, {
      't': 'send',
      'sendId': sendId,
      'to': targetDeviceId,
      'toName': targetName,
      'from': deviceId,
      'fromName': deviceName,
      'recipeId': recipeId,
      'recipeName': recipeName,
      'ts': DateTime.now().toUtc().toIso8601String(),
    });
    // Beim ersten Senden auch sich selbst eintragen (damit der Empfänger
    // später zurückschicken kann).
    await _heartbeat(listId, await _entries(listId));
  }

  /// Abgeholte Sendung entfernen.
  Future<void> remove(String itemId) => _tryDelete(itemId);

  Future<void> _tryDelete(String itemId) async {
    try {
      await api.deleteShoppingItem(itemId);
    } catch (e) {
      LogManager.shared.log('⚠️ SendTo: Postfach-Eintrag nicht gelöscht: $e');
    }
  }
}
