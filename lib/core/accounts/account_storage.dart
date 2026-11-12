import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/log_manager.dart';
import 'account_scope.dart';
import 'saved_account.dart';

// ---------------------------------------------------------------------------
// Ablage der Konten auf dem Gerät.
//
//   <ApplicationSupport>/accounts/<id>/
//       prefs.json   Konto-Schlüssel aus SharedPreferences (ohne Token)
//       files/       Konto-Ordner (Rezept-Cache, Offline-Bilder, …)
//       avatar       zuletzt bekanntes Profilbild
//   Sicherer Speicher: account_token_<id>
//
// Ein Konto ist entweder AKTIV (seine Daten liegen an den normalen Orten)
// oder ABGELEGT (prefs.json + files/ vorhanden). Nie beides: [restore]
// löscht die Ablage, sobald sie zurückgespielt ist — sonst könnte ein
// späterer Absturz einen veralteten Stand wieder hervorholen.
//
// Absturzsicherheit: prefs.json wird atomar geschrieben, BEVOR irgendetwas
// verschoben oder gelöscht wird. Ein abgebrochener Wechsel wird beim
// nächsten Start von [recover] zu Ende geführt (siehe dort).
// ---------------------------------------------------------------------------

/// Token pro Konto im sicheren Speicher (abstrahiert für Tests).
abstract class TokenVault {
  Future<String?> read(String accountId);
  Future<void> write(String accountId, String token);
  Future<void> delete(String accountId);

  /// Token des AKTIVEN Kontos, das der SettingsNotifier zusätzlich unter
  /// `apiToken` in den sicheren Speicher schreibt — gehört zum Konto und
  /// darf nach dem Ablegen nicht liegen bleiben.
  Future<void> deleteActiveToken();
}

class SecureTokenVault implements TokenVault {
  const SecureTokenVault();

  // Gleiche Optionen wie im SettingsNotifier (macOS: klassischer
  // Schlüsselbund, siehe dort).
  static const _storage = FlutterSecureStorage(
    mOptions: MacOsOptions(
      accountName: 'Walfrosch92.MealieRecipes',
      usesDataProtectionKeychain: false,
    ),
  );

  static String _key(String id) => 'account_token_$id';

  @override
  Future<String?> read(String accountId) => _storage.read(key: _key(accountId));

  @override
  Future<void> write(String accountId, String token) =>
      _storage.write(key: _key(accountId), value: token);

  @override
  Future<void> delete(String accountId) =>
      _storage.delete(key: _key(accountId));

  @override
  Future<void> deleteActiveToken() => _storage.delete(key: 'apiToken');
}

/// Schlüssel des Wiederherstellungs-Journals (Gerät). Gesetzt = ein
/// [AccountStorage.restore] für diese ID läuft bzw. wurde unterbrochen.
const _kRestoringKey = kRestoringAccountPrefsKey;

class AccountStorage {
  AccountStorage({
    required this.prefs,
    required this.supportDir,
    required this.cacheDir,
    this.vault = const SecureTokenVault(),
  });

  final SharedPreferences prefs;
  final Directory supportDir;
  final Directory cacheDir;
  final TokenVault vault;

  static Future<AccountStorage> open() async => AccountStorage(
        prefs: await SharedPreferences.getInstance(),
        supportDir: await getApplicationSupportDirectory(),
        cacheDir: await getApplicationCacheDirectory(),
      );

  static const _tokenKey = 'apiToken';

  // ── Liste der Konten ──────────────────────────────────────────────────────

  List<SavedAccount> loadAccounts() {
    final raw = prefs.getString(kSavedAccountsPrefsKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final out = <SavedAccount>[];
      for (final e in jsonDecode(raw) as List) {
        if (e is! Map) continue;
        final a = SavedAccount.fromJson(Map<String, dynamic>.from(e));
        if (a != null) out.add(a);
      }
      return out;
    } catch (_) {
      return [];
    }
  }

  Future<void> _saveAccounts(List<SavedAccount> list) => prefs.setString(
      kSavedAccountsPrefsKey, jsonEncode([for (final a in list) a.toJson()]));

  /// Eintrag anlegen oder ersetzen (gleiche ID).
  Future<void> upsertAccount(SavedAccount account) async {
    final list = loadAccounts()..removeWhere((a) => a.id == account.id);
    list.add(account);
    await _saveAccounts(list);
  }

  SavedAccount? accountById(String id) {
    for (final a in loadAccounts()) {
      if (a.id == id) return a;
    }
    return null;
  }

  SavedAccount? findAccount(String server, String userId) {
    for (final a in loadAccounts()) {
      if (a.matches(server, userId)) return a;
    }
    return null;
  }

  String get activeAccountId => prefs.getString(kActiveAccountPrefsKey) ?? '';

  Future<void> _setActive(String id) => id.isEmpty
      ? prefs.remove(kActiveAccountPrefsKey)
      : prefs.setString(kActiveAccountPrefsKey, id);

  static String newAccountId() {
    final r = Random.secure();
    return List.generate(16, (_) => r.nextInt(16).toRadixString(16)).join();
  }

  // ── Pfade ─────────────────────────────────────────────────────────────────

  Directory accountDir(String id) {
    // Defensiv: die ID landet in einem Pfad.
    if (!RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(id)) {
      throw ArgumentError('invalid account id: $id');
    }
    return Directory('${supportDir.path}/accounts/$id');
  }

  File _prefsFile(String id) => File('${accountDir(id).path}/prefs.json');
  Directory _filesDir(String id) => Directory('${accountDir(id).path}/files');
  File avatarFile(String id) => File('${accountDir(id).path}/avatar');

  Directory _activeDir(String name) => Directory('${supportDir.path}/$name');

  bool hasStash(String id) => _prefsFile(id).existsSync();

  Future<void> saveAvatar(String id, List<int> bytes) async {
    if (bytes.isEmpty) return;
    final f = avatarFile(id);
    await f.parent.create(recursive: true);
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(f.path);
  }

  // ── Aktiver Bereich ───────────────────────────────────────────────────────

  /// Alle Konto-Schlüssel, die gerade in SharedPreferences liegen.
  Set<String> activeAccountKeys() =>
      prefs.getKeys().where((k) => !isDevicePrefsKey(k)).toSet();

  /// Hat der aktive Bereich Konto-Daten? (Schlüssel oder Ordner.)
  bool get activeHasData =>
      activeAccountKeys().isNotEmpty ||
      kAccountSupportDirs.any((n) => _activeDir(n).existsSync());

  /// Konto-Teil des aktiven Bereichs komplett löschen (Gerät bleibt).
  Future<void> clearActive() async {
    for (final k in activeAccountKeys()) {
      await prefs.remove(k);
    }
    for (final n in kAccountSupportDirs) {
      await _deleteDir(_activeDir(n));
    }
    await _clearAccountCaches();
    await _deleteActiveSecureToken();
  }

  Future<void> _deleteActiveSecureToken() async {
    try {
      await vault.deleteActiveToken();
    } catch (_) {}
  }

  Future<void> _clearAccountCaches() async {
    for (final n in kAccountCacheDirs) {
      await _deleteDir(Directory('${cacheDir.path}/$n'));
    }
  }

  // ── Ablegen ───────────────────────────────────────────────────────────────

  /// Konto-Teil des aktiven Bereichs als Konto [id] ablegen. Danach ist der
  /// aktive Bereich leer (nur Geräte-Daten). Eine ältere Ablage von [id]
  /// wird ersetzt.
  Future<void> stashActive(String id) async {
    final dir = accountDir(id);
    await dir.create(recursive: true);
    // Alte Ablage (prefs + Ordner) weg — das Profilbild bleibt.
    await _deleteFile(_prefsFile(id));
    await _deleteDir(_filesDir(id));

    // 1) Schlüssel einsammeln und ATOMAR schreiben, bevor sich etwas ändert.
    final bundle = <String, Object>{};
    for (final k in activeAccountKeys()) {
      final v = prefs.get(k);
      if (v != null) bundle[k] = v;
    }
    final token = bundle.remove(_tokenKey);
    if (token is String && token.isNotEmpty) {
      await vault.write(id, token);
    }
    await _writeAtomically(_prefsFile(id), jsonEncode(_encodeBundle(bundle)));

    // 2) Ordner verschieben.
    await _moveActiveDirsTo(id);

    // 3) Erst jetzt aus dem aktiven Bereich entfernen.
    for (final k in activeAccountKeys()) {
      await prefs.remove(k);
    }
    await _clearAccountCaches();
    await _deleteActiveSecureToken();
    await _setActive('');
    LogManager.shared.log('👤 Konto $id abgelegt (${bundle.length} Werte)');
  }

  Future<void> _moveActiveDirsTo(String id) async {
    final files = _filesDir(id);
    await files.create(recursive: true);
    for (final n in kAccountSupportDirs) {
      final src = _activeDir(n);
      if (!src.existsSync()) continue;
      final dst = Directory('${files.path}/$n');
      await _deleteDir(dst);
      await src.rename(dst.path);
    }
  }

  // ── Zurückspielen ─────────────────────────────────────────────────────────

  /// Konto [id] zum aktiven machen. Der aktive Bereich muss vorher leer sein
  /// (nach [stashActive] bzw. [clearActive]) — verbliebene Konto-Daten
  /// werden sicherheitshalber gelöscht, nie mit dem Konto vermischt.
  Future<void> restore(String id, {bool recovering = false}) async {
    if (!hasStash(id)) {
      throw StateError('Keine Ablage für Konto $id');
    }
    await prefs.setString(_kRestoringKey, id);
    // Aktive Konto-Schlüssel weg. Ordner nur bei einem frischen Wechsel —
    // beim Wiederaufnehmen sind bereits zurückverschobene Ordner die des
    // Kontos selbst.
    for (final k in activeAccountKeys()) {
      await prefs.remove(k);
    }
    if (!recovering) {
      for (final n in kAccountSupportDirs) {
        await _deleteDir(_activeDir(n));
      }
      await _clearAccountCaches();
    }

    // 1) Ordner zurück.
    final files = _filesDir(id);
    for (final n in kAccountSupportDirs) {
      final src = Directory('${files.path}/$n');
      if (!src.existsSync()) continue;
      final dst = _activeDir(n);
      await _deleteDir(dst);
      await src.rename(dst.path);
    }

    // 2) Schlüssel + Token.
    final bundle =
        _decodeBundle(jsonDecode(await _prefsFile(id).readAsString()) as Map);
    for (final e in bundle.entries) {
      if (isDevicePrefsKey(e.key)) continue; // nie Geräte-Werte überschreiben
      await _setTyped(e.key, e.value);
    }
    final token = await vault.read(id) ?? '';
    await prefs.setString(_tokenKey, token);

    // 3) Ablage verbrauchen.
    await _deleteFile(_prefsFile(id));
    await _deleteDir(files);
    await _setActive(id);
    await prefs.remove(_kRestoringKey);
    LogManager.shared.log('👤 Konto $id aktiviert (${bundle.length} Werte)');
  }

  /// Gespeicherte Werte eines abgelegten Kontos lesen (z. B. Server-Header
  /// für die erneute Anmeldung), ohne es zu aktivieren.
  Map<String, Object> readStash(String id) {
    try {
      return _decodeBundle(
          jsonDecode(_prefsFile(id).readAsStringSync()) as Map);
    } catch (_) {
      return const {};
    }
  }

  /// Einzelne Werte in der Ablage ändern (neues Token nach erneuter
  /// Anmeldung → `generatedApiTokenId`).
  Future<void> patchStash(String id, Map<String, Object> values) async {
    final bundle = Map<String, Object>.of(readStash(id));
    bundle.addAll(values);
    await _writeAtomically(_prefsFile(id), jsonEncode(_encodeBundle(bundle)));
  }

  // ── Entfernen ─────────────────────────────────────────────────────────────

  /// Abgelegtes Konto komplett vom Gerät entfernen.
  Future<void> deleteAccount(String id) async {
    await _deleteDir(accountDir(id));
    try {
      await vault.delete(id);
    } catch (_) {}
    final list = loadAccounts()..removeWhere((a) => a.id == id);
    await _saveAccounts(list);
    if (activeAccountId == id) await _setActive('');
  }

  /// „Alle Einstellungen zurücksetzen": alle Ablagen weg.
  Future<void> deleteAll() async {
    for (final a in loadAccounts()) {
      try {
        await vault.delete(a.id);
      } catch (_) {}
    }
    await _deleteDir(Directory('${supportDir.path}/accounts'));
    await prefs.remove(kSavedAccountsPrefsKey);
    await prefs.remove(kActiveAccountPrefsKey);
    await prefs.remove(_kRestoringKey);
  }

  // ── Absturz-Wiederherstellung ─────────────────────────────────────────────

  /// Beim Start VOR allem anderen: einen unterbrochenen Wechsel abschließen.
  ///  - Journal „restoring = X" und Ablage X noch da → [restore] wieder-
  ///    aufnehmen (zurückverschobene Ordner bleiben).
  ///  - Journal gesetzt, Ablage schon verbraucht → nur Abschluss nachholen.
  ///  - Aktives Konto X hat (noch) eine vollständige Ablage → das Ablegen
  ///    war unterbrochen: Rest verschieben, aktiven Bereich leeren.
  /// Gibt true zurück, wenn etwas zu tun war.
  Future<bool> recover() async {
    final restoring = prefs.getString(_kRestoringKey) ?? '';
    if (restoring.isNotEmpty) {
      if (hasStash(restoring)) {
        LogManager.shared.log('👤 Unterbrochener Kontowechsel → fortsetzen');
        await restore(restoring, recovering: true);
      } else {
        await _setActive(restoring);
        await prefs.remove(_kRestoringKey);
      }
      return true;
    }
    final active = activeAccountId;
    if (active.isNotEmpty && hasStash(active)) {
      LogManager.shared.log('👤 Unterbrochenes Ablegen → abschließen');
      await _moveActiveDirsTo(active);
      for (final k in activeAccountKeys()) {
        await prefs.remove(k);
      }
      await _clearAccountCaches();
      await _setActive('');
      return true;
    }
    return false;
  }

  // ── Hilfen ────────────────────────────────────────────────────────────────

  Future<void> _setTyped(String key, Object value) async {
    switch (value) {
      case final bool v:
        await prefs.setBool(key, v);
      case final int v:
        await prefs.setInt(key, v);
      case final double v:
        await prefs.setDouble(key, v);
      case final String v:
        await prefs.setString(key, v);
      case final List<String> v:
        await prefs.setStringList(key, v);
    }
  }

  static Map<String, dynamic> _encodeBundle(Map<String, Object> bundle) => {
        for (final e in bundle.entries)
          e.key: switch (e.value) {
            final bool v => {'t': 'b', 'v': v},
            final int v => {'t': 'i', 'v': v},
            final double v => {'t': 'd', 'v': v},
            final List v => {'t': 'l', 'v': v.map((x) => '$x').toList()},
            final v => {'t': 's', 'v': '$v'},
          },
      };

  static Map<String, Object> _decodeBundle(Map raw) {
    final out = <String, Object>{};
    for (final e in raw.entries) {
      final m = e.value;
      if (m is! Map) continue;
      final v = m['v'];
      final Object? typed = switch (m['t']) {
        'b' => v == true,
        'i' => (v as num?)?.toInt(),
        'd' => (v as num?)?.toDouble(),
        'l' => v is List ? v.map((x) => '$x').toList() : null,
        _ => v?.toString(),
      };
      if (typed != null) out[e.key.toString()] = typed;
    }
    return out;
  }

  static Future<void> _writeAtomically(File f, String contents) async {
    await f.parent.create(recursive: true);
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(contents, flush: true);
    await tmp.rename(f.path);
  }

  static Future<void> _deleteDir(Directory d) async {
    try {
      if (d.existsSync()) await d.delete(recursive: true);
    } catch (e) {
      LogManager.shared.log('⚠️ Ordner nicht gelöscht ${d.path}: $e');
    }
  }

  static Future<void> _deleteFile(File f) async {
    try {
      if (f.existsSync()) await f.delete();
    } catch (_) {}
  }
}
