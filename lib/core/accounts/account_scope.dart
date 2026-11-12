import 'dart:async';

import 'package:dio/dio.dart' show CancelToken;
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

import '../services/log_manager.dart';

// ---------------------------------------------------------------------------
// Konto-Bereich der lokalen Daten (Benutzer wechseln, Variante „eigene
// Zwischenspeicher pro Konto").
//
// Alles, was die App speichert, gehört entweder zum GERÄT (Sprache, Design,
// Timer, …) oder zum aktiven KONTO (Server, Token, Caches, offene
// Offline-Änderungen, Kochsessions, …). Beim Wechsel wandert der Konto-Teil
// komplett in den Ablageordner des alten Kontos und der des neuen zurück.
//
// Regel: Was NICHT ausdrücklich Gerät ist, gehört zum Konto. Ein neu
// hinzugefügter Schlüssel wandert dadurch automatisch mit — vergisst man
// ihn hier, landet er im Zweifel beim Konto (kein Vermischen), nicht
// umgekehrt.
// ---------------------------------------------------------------------------

/// SharedPreferences-Schlüssel, die zum GERÄT gehören (bleiben beim Wechsel).
const Set<String> kDevicePrefsKeys = {
  // App-Einstellungen, die für jeden auf diesem Gerät gelten.
  'selectedLanguage',
  'importLanguage',
  'importTranslate',
  'importOrganizers',
  'importStreamPhotos',
  'importVideoAi',
  'importPreset',
  'showRecipeImages',
  'enableLogging',
  'isBiometricLockEnabled',
  'enableCriticalAlerts',
  'themeMode',
  'offlineRecipeImages',
  'hideMealDiceAutoHint',
  // Reine Anzeige-Zustände.
  'collapsedDetailSections',
  'recipeListSort',
  'whatsNewDismissedBuild',
  // Timer laufen gerätebezogen weiter (auch der Foreground-Service-Isolate
  // liest/schreibt diese).
  'timers_v1',
  'timer_fg_title',
  'timer_fg_end_ms',
  'timer_fg_suffix',
  // Geräte-Identität fürs „Rezept senden" (mDNS/Postfach).
  'recipe_send_device_id',
  'recipe_send_device_since',
  // Desktop-Updater.
  'desktopAutoUpdate',
  'desktopPendingUpdatePath',
  'desktopPendingUpdateVersion',
  'desktopLastUpdateCheck',
  // Einmal-Migration der alten Swift-App (AppDelegate.swift). Wanderte das
  // Flag mit dem Konto weg, liefe die Migration beim nächsten Start erneut
  // und schriebe Server + Token der ALTEN App in den leeren Bereich.
  'legacy_swift_migration_done',
  // Konten-Verwaltung selbst.
  kSavedAccountsPrefsKey,
  kActiveAccountPrefsKey,
  kRestoringAccountPrefsKey,
};

/// Präfixe für Geräte-Schlüssel (eingeklappte Hinweise).
const List<String> kDevicePrefsPrefixes = [
  'hint_',
  'finder_description_collapsed',
];

/// Liste der gespeicherten Konten (JSON).
const kSavedAccountsPrefsKey = 'saved_accounts_v1';

/// ID des gerade aktiven gespeicherten Kontos (leer = noch keins).
const kActiveAccountPrefsKey = 'active_account_id';

/// Journal: ein Zurückspielen dieses Kontos läuft (Absturz-Wiederherstellung).
const kRestoringAccountPrefsKey = 'account_restoring_id';

/// Gehört [key] (ohne `flutter.`-Präfix) zum Gerät?
bool isDevicePrefsKey(String key) =>
    kDevicePrefsKeys.contains(key) ||
    kDevicePrefsPrefixes.any((p) => key.startsWith(p));

/// Ordner unter Application Support, die zum aktiven Konto gehören.
/// (Rezept-Cache, Offline-Rezeptbilder, Fotos von offline „Gekocht"-Einträgen.)
const List<String> kAccountSupportDirs = [
  'MealieCache',
  'MealieImages',
  'pending_cooked',
];

/// Ordner unter dem App-Cache, die beim Wechsel geleert werden (reine Caches
/// mit Konto-Inhalten: heruntergeladene Rezept-Anhänge).
/// `MealieCache` dort ist der alte Ort des Rezept-Caches (vor 2026-09, wird
/// beim ersten Zugriff nach Application Support verschoben) — ein Rest
/// davon darf nie in ein anderes Konto „wandern".
const List<String> kAccountCacheDirs = ['recipe_assets', 'MealieCache'];

class AccountScope {
  AccountScope._();

  /// Wird bei jedem Kontowechsel hochgezählt. ApiService merkt sich den
  /// Stand beim Erzeugen und verwirft Antworten aus einer älteren Epoche —
  /// so kann keine noch laufende Anfrage des alten Kontos nach dem Wechsel
  /// Daten in den Speicher des neuen schreiben.
  static int epoch = 0;

  /// Während des Umräumens: Schreibzugriffe auf Konto-Schlüssel sperren.
  static bool _frozen = false;
  static bool get frozen => _frozen;

  /// Zone-Markierung der Umräum-Routine. Bewusst KEIN globaler Schalter:
  /// sonst kämen während deren awaits auch verirrte Schreibzugriffe anderer
  /// (alter) Code-Pfade durch. Fortsetzungen laufen in der Zone, in der sie
  /// begonnen wurden — nur die Routine selbst trägt die Markierung.
  static const _privilegedKey = #mealieAccountSwitchPrivileged;

  /// Wird bei jedem Wechsel abgebrochen und ersetzt. ApiService hängt ihn
  /// an jede Anfrage: laufende Anfragen des alten Kontos enden SOFORT mit
  /// Fehler — noch innerhalb der Sperre. Ohne das käme die Antwort einer
  /// hängenden Anfrage evtl. erst nach dem Wechsel an, und der Aufrufer
  /// (z. B. eine Offline-Warteschlange) schriebe dann in das neue Konto.
  static CancelToken get requestCancelToken => _cancelToken;
  static CancelToken _cancelToken = CancelToken();

  static void freeze() {
    _frozen = true;
    epoch++;
    _cancelToken.cancel('account switched');
    _cancelToken = CancelToken();
  }

  static void unfreeze() {
    _frozen = false;
  }

  /// Für Zustände, die sich die Epoche beim Erzeugen merken (Notifier mit
  /// eigenen Sockets/Native-Callbacks): gehöre ich noch zum aktiven Konto?
  static bool isCurrent(int capturedEpoch) =>
      !_frozen && capturedEpoch == epoch;

  /// Die Umräum-Routine selbst darf schreiben.
  static Future<T> privileged<T>(Future<T> Function() op) =>
      runZoned(op, zoneValues: {_privilegedKey: true});

  static bool get _blocked => _frozen && Zone.current[_privilegedKey] != true;

  /// Einmal in `main()` vor dem ersten SharedPreferences-Zugriff.
  static void installPrefsGuard() {
    final current = SharedPreferencesStorePlatform.instance;
    if (current is GuardedPrefsStore) return;
    SharedPreferencesStorePlatform.instance = GuardedPrefsStore(current);
  }

  /// Anzahl verworfener Schreibzugriffe (Selbsttest/Log).
  static int blockedWrites = 0;
}

/// Leitet alles an den echten Speicher weiter — außer Schreibzugriffen auf
/// Konto-Schlüssel, solange [AccountScope.frozen] ist. Die In-Memory-Kopie
/// von SharedPreferences sieht einen verworfenen Wert kurz trotzdem; der
/// Wechsel lädt deshalb am Ende per `reload()` neu von der Platte.
class GuardedPrefsStore extends SharedPreferencesStorePlatform {
  GuardedPrefsStore(this._inner);
  final SharedPreferencesStorePlatform _inner;

  static String _plain(String key) =>
      key.startsWith('flutter.') ? key.substring(8) : key;

  bool _reject(String key, String op) {
    if (!AccountScope._blocked || isDevicePrefsKey(_plain(key))) return false;
    AccountScope.blockedWrites++;
    LogManager.shared.log('🔒 Kontowechsel: $op "${_plain(key)}" verworfen');
    return true;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    if (_reject(key, 'set')) return false;
    return _inner.setValue(valueType, key, value);
  }

  @override
  Future<bool> remove(String key) async {
    if (_reject(key, 'remove')) return false;
    return _inner.remove(key);
  }

  @override
  Future<bool> clear() async {
    if (AccountScope._blocked) {
      AccountScope.blockedWrites++;
      return false;
    }
    return _inner.clear();
  }

  @override
  // ignore: deprecated_member_use
  Future<bool> clearWithPrefix(String prefix) async {
    if (AccountScope._blocked) return false;
    // ignore: deprecated_member_use
    return _inner.clearWithPrefix(prefix);
  }

  @override
  Future<bool> clearWithParameters(ClearParameters parameters) async {
    if (AccountScope._blocked) return false;
    return _inner.clearWithParameters(parameters);
  }

  @override
  Future<Map<String, Object>> getAll() => _inner.getAll();

  @override
  // ignore: deprecated_member_use
  Future<Map<String, Object>> getAllWithPrefix(String prefix) =>
      // ignore: deprecated_member_use
      _inner.getAllWithPrefix(prefix);

  @override
  Future<Map<String, Object>> getAllWithParameters(
          GetAllParameters parameters) =>
      _inner.getAllWithParameters(parameters);
}
