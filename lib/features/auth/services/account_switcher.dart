import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../core/accounts/account_storage.dart';
import '../../../core/accounts/saved_account.dart';
import '../../../core/api/api_service.dart';
import '../../../core/models/app_settings.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../core/services/log_manager.dart';
import '../../../app_root.dart' show AppRoot;
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/user_avatar.dart' show userAvatarUrl;
import '../providers/biometric_lock_provider.dart'
    show promptBiometricConfirmation;
import '../widgets/renew_token_sheet.dart';

// ---------------------------------------------------------------------------
// Benutzer wechseln — die Abläufe hinter Konto-Menü, Einstellungen und
// Anmeldeseite. Das Umräumen selbst macht AccountStorage innerhalb von
// AppRoot.restart (ohne lebenden ProviderScope, siehe AccountTransition).
//
// Grundsätze:
//  - Zu einem gespeicherten Konto geht es nur nach Entsperren: Geräte-
//    Entsperrung (nur wenn für dieses Konto erlaubt) oder Passwort/Token.
//    Bei Passwort/Token wird geprüft, dass es WIRKLICH dieser Mealie-
//    Benutzer ist (RenewTokenSheet.expectedUserId).
//  - Das aktive Konto wird nur abgelegt, wenn seine Identität (Server +
//    Benutzer-ID) feststeht — sonst ließe es sich später nicht zuordnen.
//  - Nach AppRoot.restart sind `ref` und `context` des Aufrufers tot.
// ---------------------------------------------------------------------------

/// Liste der gespeicherten Konten für die Oberfläche (ohne das aktive).
final savedAccountsProvider = FutureProvider<SavedAccountsView>((ref) async {
  final storage = await AccountStorage.open();
  final active = storage.activeAccountId;
  // Nur Konten mit vollständiger Ablage — ein Eintrag ohne (z. B. nach
  // einem Token-Tausch in den Einstellungen verwaist) ließe sich nicht
  // aktivieren.
  final list = storage
      .loadAccounts()
      .where((a) => a.id != active && storage.hasStash(a.id))
      .toList()
    ..sort((a, b) => b.lastUsed.compareTo(a.lastUsed));
  return SavedAccountsView(list, storage);
});

class SavedAccountsView {
  SavedAccountsView(this.accounts, this._storage);
  final List<SavedAccount> accounts;
  final AccountStorage _storage;

  File? avatarFor(SavedAccount a) {
    final f = _storage.avatarFile(a.id);
    return f.existsSync() ? f : null;
  }
}

/// Kann das Gerät entsperren (Biometrie oder Geräte-PIN)?
Future<bool> deviceUnlockAvailable() async {
  if (!(Platform.isIOS || Platform.isAndroid || Platform.isMacOS)) {
    return false;
  }
  try {
    return await LocalAuthentication().isDeviceSupported();
  } catch (_) {
    return false;
  }
}

// ── Aktives Konto erfassen ────────────────────────────────────────────────

class _ActiveIdentity {
  _ActiveIdentity(this.settings, this.user, this.avatar);
  final AppSettings settings;
  final Map<String, dynamic> user;
  final List<int>? avatar;

  String get userId => user['id']?.toString() ?? '';
}

Future<_ActiveIdentity?> _readActiveIdentity(WidgetRef ref) async {
  final settings = ref.read(settingsProvider).valueOrNull;
  if (settings == null || !settings.isConfigured) return null;
  final api = ref.read(apiServiceProvider);
  // Benutzer immer frisch vom Server, wenn möglich: der Cache könnte von
  // einem anderen Token stammen (Token in den Einstellungen getauscht).
  Map<String, dynamic>? user;
  try {
    user = await api.fetchCurrentUser().timeout(const Duration(seconds: 8));
  } catch (_) {
    user = ref.read(currentUserProvider);
  }
  if (user == null || (user['id']?.toString() ?? '').isEmpty) return null;
  return _ActiveIdentity(
      settings, user, await _avatarBytes(settings, user, api));
}

Future<List<int>?> _avatarBytes(
    AppSettings s, Map<String, dynamic> user, ApiService api) async {
  final id = user['id'].toString();
  final cacheKey = user['cacheKey']?.toString() ?? '';
  // Wie UserAvatar die URL baut (Revision 0 = Start).
  for (final server in {s.serverUrl, s.primaryServerUrl}) {
    try {
      final hit = await DefaultCacheManager()
          .getFileFromCache(userAvatarUrl(server, id, rev: '${cacheKey}0'));
      if (hit != null) return await hit.file.readAsBytes();
    } catch (_) {}
  }
  try {
    final bytes = await api
        .fetchImageBytesFromUrl(userAvatarUrl(s.serverUrl, id))
        .timeout(const Duration(seconds: 6));
    return bytes.isEmpty ? null : bytes;
  } catch (_) {
    return null; // kein Bild hochgeladen / offline → Anfangsbuchstabe
  }
}

SavedAccount _metaFor(_ActiveIdentity a, String id, bool biometric) =>
    SavedAccount(
      id: id,
      serverUrl: a.settings.primaryServerUrl,
      userId: a.userId,
      username: a.user['username']?.toString() ?? '',
      fullName: a.user['fullName']?.toString() ?? '',
      email: a.user['email']?.toString() ?? '',
      admin: a.user['admin'] == true,
      biometricAllowed: biometric,
      hasGeneratedToken: a.settings.generatedApiTokenId.isNotEmpty,
      authMethod: a.user['authMethod']?.toString() ?? '',
      lastUsed: DateTime.now(),
    );

/// Unter welcher ID das aktive Konto abgelegt wird. Das gemerkte aktive
/// Konto nur, wenn es wirklich derselbe Benutzer ist — sonst (Token in den
/// Einstellungen gegen das eines anderen Benutzers getauscht) wäre der
/// Eintrag falsch beschriftet.
({String id, SavedAccount? existing, String? staleId}) _resolveActiveId(
    AccountStorage storage, _ActiveIdentity a) {
  final activeId = storage.activeAccountId;
  final byActive = activeId.isEmpty ? null : storage.accountById(activeId);
  if (byActive != null && byActive.userId == a.userId) {
    return (id: byActive.id, existing: byActive, staleId: null);
  }
  final byMatch = storage.findAccount(a.settings.primaryServerUrl, a.userId);
  // byMatch mit Ablage gibt es hier nicht (dasselbe Konto kann nicht
  // gleichzeitig aktiv und abgelegt sein) — die alte Ablage würde ersetzt.
  return (
    id: byMatch?.id ?? AccountStorage.newAccountId(),
    existing: byMatch,
    staleId: byActive?.id,
  );
}

// ── Dialoge ───────────────────────────────────────────────────────────────

/// Bestätigung „Benutzer wechseln" mit Schalter für die Geräte-Entsperrung.
/// `null` = abgebrochen, sonst gewählter Schalterstand.
Future<bool?> _confirmSaveActive(BuildContext context, String name,
    {required bool initialBiometric}) async {
  final l = AppLocalizations.of(context)!;
  final canUnlock = await deviceUnlockAvailable();
  if (!context.mounted) return null;
  var biometric = initialBiometric && canUnlock;
  return showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.switchUserTitle, style: TextStyle(color: ctx.appFg)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.switchUserBody(name),
                style: TextStyle(color: ctx.appFgSub, height: 1.35)),
            if (canUnlock) ...[
              const SizedBox(height: 12),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                activeTrackColor: AppTokens.accent,
                value: biometric,
                onChanged: (v) => setState(() => biometric = v),
                title: Text(l.allowBiometricTitle,
                    style: TextStyle(color: ctx.appFg, fontSize: 15)),
                subtitle: Text(l.allowBiometricHint,
                    style: TextStyle(color: ctx.appFgSub, fontSize: 12)),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: Text(l.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, biometric),
            child: Text(l.switchUserTitle),
          ),
        ],
      ),
    ),
  );
}

// ── Entsperren eines gespeicherten Kontos ─────────────────────────────────

class _Unlock {
  _Unlock({this.newToken, this.generatedId, this.apiVersion, this.biometric});

  /// Neues Token aus Passwort-/Token-Anmeldung (sonst gespeichertes).
  final String? newToken;
  final String? generatedId;
  final String? apiVersion;

  /// Nach Passwort-Anmeldung gefragt: künftig Geräte-Entsperrung?
  final bool? biometric;
}

AppSettings _settingsFromStash(SavedAccount a, Map<String, Object> stash,
        {String token = ''}) =>
    AppSettings(
      serverUrl: a.serverUrl,
      apiToken: token,
      apiVersion: stash['apiVersion']?.toString() ?? 'v2',
      sendOptionalHeaders: stash['sendOptionalHeaders'] == true,
      optionalHeaderKey1: stash['optionalHeaderKey1']?.toString() ?? '',
      optionalHeaderValue1: stash['optionalHeaderValue1']?.toString() ?? '',
      optionalHeaderKey2: stash['optionalHeaderKey2']?.toString() ?? '',
      optionalHeaderValue2: stash['optionalHeaderValue2']?.toString() ?? '',
      optionalHeaderKey3: stash['optionalHeaderKey3']?.toString() ?? '',
      optionalHeaderValue3: stash['optionalHeaderValue3']?.toString() ?? '',
    );

Future<_Unlock?> _unlock(
    BuildContext context, SavedAccount a, AccountStorage storage) async {
  final l = AppLocalizations.of(context)!;
  final stash = storage.readStash(a.id);

  if (a.biometricAllowed && await deviceUnlockAvailable()) {
    final ok = await promptBiometricConfirmation(
        localizedReason: l.unlockAccountReason(a.displayName));
    if (ok) {
      final token = await storage.vault.read(a.id) ?? '';
      if (token.isNotEmpty) {
        // Gespeichertes Token noch gültig und vom richtigen Benutzer?
        // Offline → trotzdem wechseln (offline-first), der Server prüft
        // beim nächsten Kontakt ohnehin.
        try {
          final me =
              await ApiService(_settingsFromStash(a, stash, token: token))
                  .fetchCurrentUser()
                  .timeout(const Duration(seconds: 8));
          if (me['id']?.toString() == a.userId) return _Unlock();
          LogManager.shared.log('👤 Gespeichertes Token gehört zu anderem '
              'Benutzer → Anmeldung nötig');
        } on DioException catch (e) {
          final code = e.response?.statusCode;
          if (code != 401 && code != 403) {
            return _Unlock(); // offline / Server nicht erreichbar
          }
          LogManager.shared.log('👤 Gespeichertes Token ungültig → '
              'Anmeldung nötig');
        } catch (_) {
          return _Unlock(); // Zeitüberschreitung o. ä. → offline-first
        }
      }
    }
    if (!context.mounted) return null;
  }

  // Passwort bzw. Token.
  if (!context.mounted) return null;
  final settings = _settingsFromStash(a, stash);
  final result = await showModalBottomSheet<(String, String?, String)>(
    context: context,
    useRootNavigator: true,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => RenewTokenSheet(
      title: l.signInAs(a.displayName),
      serverUrl: a.serverUrl,
      sendOptionalHeaders: settings.sendOptionalHeaders,
      headerKey1: settings.optionalHeaderKey1,
      headerValue1: settings.optionalHeaderValue1,
      headerKey2: settings.optionalHeaderKey2,
      headerValue2: settings.optionalHeaderValue2,
      headerKey3: settings.optionalHeaderKey3,
      headerValue3: settings.optionalHeaderValue3,
      initialUsername: a.username,
      initialMode: a.canUsePassword ? AuthMode.password : AuthMode.token,
      expectedUserId: a.userId,
    ),
  );
  if (result == null || !context.mounted) return null;
  final (token, generatedId, ver) = result;

  // Gerade sicher angemeldet → jetzt (einmal) fragen, ob künftig die
  // Geräte-Entsperrung reicht.
  bool? biometric;
  if (!a.biometricAllowed && await deviceUnlockAvailable()) {
    if (!context.mounted) return null;
    biometric = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        title: Text(l.allowBiometricTitle, style: TextStyle(color: ctx.appFg)),
        content:
            Text(l.allowBiometricHint, style: TextStyle(color: ctx.appFgSub)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.notNow)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: Text(l.allow)),
        ],
      ),
    );
  }
  return _Unlock(
      newToken: token,
      generatedId: generatedId,
      apiVersion: ver,
      biometric: biometric);
}

// ── Öffentliche Abläufe ───────────────────────────────────────────────────

/// Benutzer wechseln: aktives Konto ablegen und — mit [target] — zu einem
/// gespeicherten Konto wechseln, ohne [target] zur Anmeldeseite (weiteres
/// Konto hinzufügen bzw. aus der Liste wählen).
Future<void> switchAccount(BuildContext context, WidgetRef ref,
    {SavedAccount? target}) async {
  final l = AppLocalizations.of(context)!;
  final messenger = ScaffoldMessenger.maybeOf(context);
  final storage = await AccountStorage.open();
  final settings = ref.read(settingsProvider).valueOrNull;
  final activeConfigured = settings?.isConfigured ?? false;

  // 1) Aktives Konto erfassen.
  _ActiveIdentity? active;
  ({String id, SavedAccount? existing, String? staleId})? activeSlot;
  var biometricForActive = false;
  if (activeConfigured) {
    active = await _readActiveIdentity(ref);
    if (active == null) {
      messenger?.showSnackBar(SnackBar(content: Text(l.accountSaveOffline)));
      return;
    }
    activeSlot = _resolveActiveId(storage, active);
    if (!context.mounted) return;
    final name = userDisplayNameOf(active.user);
    // Ohne Ziel immer bestätigen (es geht zur Anmeldeseite). Mit Ziel nur,
    // wenn das aktive Konto zum ersten Mal gespeichert wird (Frage nach
    // der Geräte-Entsperrung).
    if (target == null || activeSlot.existing == null) {
      final choice = await _confirmSaveActive(context, name,
          initialBiometric: activeSlot.existing?.biometricAllowed ?? false);
      if (choice == null || !context.mounted) return;
      biometricForActive = choice;
    } else {
      biometricForActive = activeSlot.existing!.biometricAllowed;
    }
  }

  // 2) Ziel entsperren.
  _Unlock? unlock;
  if (target != null) {
    if (!context.mounted) return;
    unlock = await _unlock(context, target, storage);
    if (unlock == null) return;
  }

  HapticFeedback.mediumImpact();
  final a = active;
  final slot = activeSlot;
  final u = unlock;
  try {
    await AppRoot.restart((storage) async {
      // Aktives Konto ablegen bzw. (Gast/halb eingerichtet) verwerfen.
      if (a != null && slot != null) {
        if (slot.staleId != null) await storage.deleteAccount(slot.staleId!);
        await storage.upsertAccount(_metaFor(a, slot.id, biometricForActive));
        final avatar = a.avatar;
        if (avatar != null) await storage.saveAvatar(slot.id, avatar);
        await storage.stashActive(slot.id);
      } else {
        await storage.clearActive();
      }
      if (target == null || u == null) return;

      // Neues Token aus der Anmeldung übernehmen (altes, von der App
      // erzeugtes Token des Kontos auf dem Server aufräumen).
      if (u.newToken != null) {
        final stash = storage.readStash(target.id);
        final oldGenerated = stash['generatedApiTokenId']?.toString() ?? '';
        await storage.vault.write(target.id, u.newToken!);
        await storage.patchStash(target.id, {
          'generatedApiTokenId': u.generatedId ?? '',
          if (u.apiVersion != null) 'apiVersion': u.apiVersion!,
        });
        if (oldGenerated.isNotEmpty && oldGenerated != u.generatedId) {
          await _deleteServerToken(
              _settingsFromStash(target, stash, token: u.newToken!),
              oldGenerated);
        }
      }
      await storage.restore(target.id);
      await storage.upsertAccount(target.copyWith(
        lastUsed: DateTime.now(),
        biometricAllowed: u.biometric ?? target.biometricAllowed,
        hasGeneratedToken: u.newToken != null
            ? (u.generatedId ?? '').isNotEmpty
            : target.hasGeneratedToken,
      ));
    });
  } catch (e) {
    LogManager.shared.log('❌ Benutzer wechseln: $e');
  }
}

/// Abmelden und vom Gerät entfernen: aktives Konto mit allen Daten weg,
/// Geräte-Einstellungen bleiben. Server-Adresse(n) und Zusatz-Header
/// bleiben für die Anmeldeseite vorausgefüllt.
Future<void> logoutAndRemove(BuildContext context, WidgetRef ref) async {
  final l = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.appCard,
      title: Text(l.signOutRemoveTitle, style: TextStyle(color: ctx.appFg)),
      content:
          Text(l.signOutRemoveConfirm, style: TextStyle(color: ctx.appFgSub)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(
          style: AppTokens.dangerButton,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.signOutRemoveTitle),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final current = ref.read(settingsProvider).valueOrNull;
  if (current != null && current.generatedApiTokenId.isNotEmpty) {
    await _deleteServerToken(current, current.generatedApiTokenId);
  }
  final keep = <String, Object>{
    if (current != null) ...{
      'serverUrl': current.primaryServerUrl,
      'wifiServerUrl': current.wifiServerUrl,
      'wifiSsid': current.wifiSsid,
      'sendOptionalHeaders': current.sendOptionalHeaders,
      'optionalHeaderKey1': current.optionalHeaderKey1,
      'optionalHeaderValue1': current.optionalHeaderValue1,
      'optionalHeaderKey2': current.optionalHeaderKey2,
      'optionalHeaderValue2': current.optionalHeaderValue2,
      'optionalHeaderKey3': current.optionalHeaderKey3,
      'optionalHeaderValue3': current.optionalHeaderValue3,
    },
  };
  try {
    await AppRoot.restart((storage) async {
      final activeId = storage.activeAccountId;
      await storage.clearActive();
      if (activeId.isNotEmpty) await storage.deleteAccount(activeId);
      for (final e in keep.entries) {
        final v = e.value;
        if (v is bool) {
          await storage.prefs.setBool(e.key, v);
        } else if (v is String && v.isNotEmpty) {
          await storage.prefs.setString(e.key, v);
        }
      }
    });
  } catch (e) {
    LogManager.shared.log('❌ Abmelden: $e');
  }
}

/// Gespeichertes (nicht aktives) Konto vom Gerät entfernen.
Future<bool> removeSavedAccount(BuildContext context, SavedAccount a) async {
  final l = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => AlertDialog(
      backgroundColor: ctx.appCard,
      title: Text(l.removeSavedAccount, style: TextStyle(color: ctx.appFg)),
      content: Text(l.removeSavedAccountConfirm(a.displayName),
          style: TextStyle(color: ctx.appFgSub)),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(
          style: AppTokens.dangerButton,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l.removeSavedAccount),
        ),
      ],
    ),
  );
  if (confirmed != true) return false;
  final storage = await AccountStorage.open();
  if (storage.activeAccountId == a.id) return false; // nie das aktive
  final stash = storage.readStash(a.id);
  final generated = stash['generatedApiTokenId']?.toString() ?? '';
  final token = await storage.vault.read(a.id) ?? '';
  if (generated.isNotEmpty && token.isNotEmpty) {
    await _deleteServerToken(
        _settingsFromStash(a, stash, token: token), generated);
  }
  await storage.deleteAccount(a.id);
  return true;
}

/// Geräte-Entsperrung für ein gespeichertes Konto abschalten.
Future<void> disableBiometricFor(SavedAccount a) async {
  final storage = await AccountStorage.open();
  await storage.upsertAccount(a.copyWith(biometricAllowed: false));
}

/// Nach einer Anmeldung auf der Anmeldeseite: ist das ein gespeichertes
/// Konto? Dann dessen abgelegte Daten aktivieren statt neu einzurichten.
/// true = gewechselt (Aufrufer ist danach tot).
Future<bool> adoptSavedAccountAfterLogin({
  required AppSettings settings,
  required String generatedTokenId,
}) async {
  final storage = await AccountStorage.open();
  if (storage.loadAccounts().isEmpty) return false;
  Map<String, dynamic> me;
  try {
    me = await ApiService(settings).fetchCurrentUser();
  } catch (_) {
    return false;
  }
  final userId = me['id']?.toString() ?? '';
  final match = storage.findAccount(settings.primaryServerUrl, userId);
  if (match == null || !storage.hasStash(match.id)) return false;
  final stash = storage.readStash(match.id);
  final oldGenerated = stash['generatedApiTokenId']?.toString() ?? '';
  await AppRoot.restart((storage) async {
    await storage.vault.write(match.id, settings.apiToken);
    await storage.patchStash(match.id, {
      'generatedApiTokenId': generatedTokenId,
      'apiVersion': settings.apiVersion,
    });
    if (oldGenerated.isNotEmpty && oldGenerated != generatedTokenId) {
      await _deleteServerToken(settings, oldGenerated);
    }
    // Die Anmeldeseite hat evtl. schon Konto-Werte geschrieben (z. B.
    // halbe Einrichtung) — die gehören zu keinem Konto.
    await storage.clearActive();
    await storage.restore(match.id);
    await storage.upsertAccount(match.copyWith(
        lastUsed: DateTime.now(),
        hasGeneratedToken: generatedTokenId.isNotEmpty));
  });
  return true;
}

/// „Alle Einstellungen zurücksetzen": aktives UND alle gespeicherten Konten
/// samt Daten, alle App-Einstellungen.
Future<void> resetEverything(AppSettings? current) async {
  if (current != null && current.generatedApiTokenId.isNotEmpty) {
    await _deleteServerToken(current, current.generatedApiTokenId);
  }
  final storage = await AccountStorage.open();
  for (final a in storage.loadAccounts()) {
    if (a.id == storage.activeAccountId) continue;
    final stash = storage.readStash(a.id);
    final generated = stash['generatedApiTokenId']?.toString() ?? '';
    final token = await storage.vault.read(a.id) ?? '';
    if (generated.isNotEmpty && token.isNotEmpty) {
      await _deleteServerToken(
          _settingsFromStash(a, stash, token: token), generated);
    }
  }
  try {
    await AppRoot.restart((storage) async {
      await storage.deleteAll();
      await storage.clearActive();
      await storage.prefs.clear();
      try {
        await const FlutterSecureStorage(
          mOptions: MacOsOptions(
            accountName: 'Walfrosch92.MealieRecipes',
            usesDataProtectionKeychain: false,
          ),
        ).deleteAll();
      } catch (_) {}
    });
  } catch (e) {
    LogManager.shared.log('❌ Zurücksetzen: $e');
  }
}

Future<void> _deleteServerToken(AppSettings s, String id) async {
  try {
    await ApiService(s)
        .deleteLongLiveToken(id)
        .timeout(const Duration(seconds: 6));
  } catch (e) {
    LogManager.shared.log('⚠️ Altes API-Token nicht gelöscht: $e');
  }
}

String userDisplayNameOf(Map<String, dynamic> u) {
  final full = (u['fullName'] as String?)?.trim() ?? '';
  if (full.isNotEmpty) return full;
  return (u['username'] as String?)?.trim() ?? '';
}
