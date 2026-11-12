import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/shopping_reminder_location.dart';
import '../services/log_manager.dart';
import '../services/wifi_name.dart';
import '../utils/meal_types.dart';

// ---------------------------------------------------------------------------
// Keys
// ---------------------------------------------------------------------------

const _kServerUrl = 'serverUrl';
const _kWifiServerUrl = 'wifiServerUrl';
const _kWifiSsid = 'wifiSsid';
const _kHouseholdId = 'householdId';
const _kShoppingListId = 'shoppingListId';
const _kApiVersion = 'apiVersion';
const _kSelectedLanguage = 'selectedLanguage';
const _kImportLanguage = 'importLanguage';
const _kImportTranslate = 'importTranslate';
const _kImportOrganizers = 'importOrganizers';
const _kImportStreamPhotos = 'importStreamPhotos';
const _kImportVideoAi = 'importVideoAi';
const _kImportPreset = 'importPreset';
const _kShowRecipeImages = 'showRecipeImages';
const _kTabletSidebar = 'tabletSidebar';
const _kEnableLogging = 'enableLogging';
const _kBiometricLock = 'isBiometricLockEnabled';
const _kCriticalAlerts = 'enableCriticalAlerts';
const _kSendOptionalHeaders = 'sendOptionalHeaders';
const _kOptHeaderKey1 = 'optionalHeaderKey1';
const _kOptHeaderVal1 = 'optionalHeaderValue1';
const _kOptHeaderKey2 = 'optionalHeaderKey2';
const _kOptHeaderVal2 = 'optionalHeaderValue2';
const _kOptHeaderKey3 = 'optionalHeaderKey3';
const _kOptHeaderVal3 = 'optionalHeaderValue3';
const _kCollapsedCategories = 'collapsedShoppingCategories';
const _kCategoryOrder = 'shoppingCategoryOrder';
const _kQuickAccessOrder = 'quickAccessOrder';
const _kHomePinnedTiles = 'homePinnedTiles';
const _kHomeTiles = 'homeTiles';
const _kMoreTilesOrder = 'moreTilesOrder';
const _kThemeMode = 'themeMode';
const _kAddExactQuantities = 'addExactQuantities';
const _kGuestMode = 'isGuestMode';
const _kGeneratedApiTokenId = 'generatedApiTokenId';
const _kRemindToShop = 'remindToShopEnabled';
const _kShoppingReminderLocations = 'shoppingReminderLocations';
const _kOfflineRecipeImages = 'offlineRecipeImages';
// Würfel-Filter im Mahlzeitenplan: ein Key pro Mahlzeit.
const _kMealDiceFilterPrefix = 'mealDiceFilter_';
// Alle Mealie-Mahlzeitentypen (vorher nur Frühstück/Mittag/Abend).
const _kMealDiceSlots = kMealTypes;
const _kHideMealDiceAutoHint = 'hideMealDiceAutoHint';
const _kMealDiceUseMealieRules = 'mealDiceUseMealieRules';

// API token stored in secure storage
const _kApiToken = 'apiToken';

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

/// Gespeichertes Farbschema ('system'/'light'/'dark'), in main.dart VOR dem
/// ersten Frame gelesen. Ohne das zeigt die App bis zum async Settings-Load
/// das System-Schema — Sheets, die in diesen ersten Frames aufgehen
/// („Was ist neu“), bekamen dann z. B. hellen Hintergrund bei dunkler App.
final initialThemeModeProvider = Provider<String>((ref) => 'system');

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late final FlutterSecureStorage _secure;
  late final SharedPreferences _prefs;

  @override
  Future<AppSettings> build() async {
    _secure = const FlutterSecureStorage(
      // macOS: klassischer Schlüsselbund — der Data-Protection-Keychain
      // (Standard) braucht die Keychain-Sharing-Berechtigung samt
      // Developer-Team, sonst schlägt jeder Zugriff fehl (-34018).
      // Eigener Dienstname, damit der Deinstaller (macos/packaging) genau
      // diesen Eintrag löschen kann, ohne andere Flutter-Apps zu treffen.
      mOptions: MacOsOptions(
        accountName: 'Walfrosch92.MealieRecipes',
        usesDataProtectionKeychain: false,
      ),
    );
    _prefs = await SharedPreferences.getInstance();
    final loaded = _load();
    // Honor the persisted logging preference at startup so prints captured
    // by the zone hook before settings load don't get recorded behind the
    // user's back.
    LogManager.shared.enabled = loaded.enableLogging;
    ref.onDispose(_stopWifiWatch);
    if (loaded.hasWifiServer) {
      // VOR dem ersten API-Aufruf wissen, welches WLAN — sonst ginge der
      // Start-Abgleich erst an die falsche Adresse. Kurz begrenzt, damit ein
      // hängender Plattformaufruf den App-Start nicht aufhält.
      _ssid = await readWifiName()
          .timeout(const Duration(milliseconds: 1500), onTimeout: () => null);
      _startWifiWatch();
    }
    return _route(loaded);
  }

  // ── WLAN-Umschaltung ──────────────────────────────────────────────────
  // Ist eine WLAN-Adresse eingerichtet, beobachtet der Notifier Netzwechsel
  // (und das Zurückkehren in die App) und setzt `serverUrl` auf die passende
  // Adresse. apiServiceProvider hängt an `serverUrl` → alle Aufrufe gehen
  // danach an die neue Adresse.

  String? _ssid;
  StreamSubscription<List<ConnectivityResult>>? _connSub;
  AppLifecycleListener? _lifecycle;

  /// Zuletzt gelesener WLAN-Name (`null` = kein WLAN / nicht lesbar).
  String? get currentWifiName => _ssid;

  AppSettings _route(AppSettings s) {
    final url = s.serverUrlForSsid(_ssid);
    if (url == s.serverUrl) return s;
    return s.copyWith(serverUrl: url, standardServerUrl: s.primaryServerUrl);
  }

  void _startWifiWatch() {
    if (_connSub != null) return;
    try {
      _connSub = Connectivity()
          .onConnectivityChanged
          .listen((_) => recheckWifi(), onError: (_) {});
      _lifecycle = AppLifecycleListener(onResume: recheckWifi);
    } catch (_) {
      // Plattform ohne Plugin (Tests) → keine automatische Umschaltung.
    }
  }

  void _stopWifiWatch() {
    _connSub?.cancel();
    _connSub = null;
    _lifecycle?.dispose();
    _lifecycle = null;
  }

  /// WLAN-Namen neu lesen und ggf. die Adresse umschalten. Direkt nach dem
  /// Verbinden meldet Android den Namen manchmal noch nicht → einmal kurz
  /// später nachsehen.
  Future<void> recheckWifi() async {
    final cur = state.valueOrNull;
    if (cur == null || !cur.hasWifiServer) return;
    var ssid = await readWifiName();
    if (ssid == null) {
      await Future<void>.delayed(const Duration(seconds: 2));
      ssid = await readWifiName();
    }
    _ssid = ssid;
    final latest = state.valueOrNull;
    if (latest == null) return;
    final routed = _route(latest);
    if (routed.serverUrl != latest.serverUrl) {
      LogManager.shared.log('📶 WLAN ${ssid ?? '–'} → Server-Adresse '
          '${routed.usingWifiServer ? 'WLAN' : 'Standard'}');
      state = AsyncData(routed);
    }
  }

  AppSettings _load() {
    final token = _prefs.getString(_kApiToken) ?? '';
    return AppSettings(
      // Ältere Stände ohne Bereinigung (Schrägstrich am Ende → „//api").
      serverUrl: (_prefs.getString(_kServerUrl) ?? '')
          .trim()
          .replaceAll(RegExp(r'/+$'), ''),
      wifiServerUrl: (_prefs.getString(_kWifiServerUrl) ?? '')
          .trim()
          .replaceAll(RegExp(r'/+$'), ''),
      wifiSsid: _prefs.getString(_kWifiSsid) ?? '',
      apiToken: token,
      householdId: _prefs.getString(_kHouseholdId) ?? '',
      shoppingListId: _prefs.getString(_kShoppingListId) ?? '',
      apiVersion: _prefs.getString(_kApiVersion) ?? 'v2',
      selectedLanguage: _prefs.getString(_kSelectedLanguage) ?? 'en',
      // Leer = der App-Sprache folgen (siehe AppSettings.importLanguage).
      // 'no' → 'nb': Norwegisch hieß in der Importliste früher 'no', seit es
      // App-Sprache ist, einheitlich 'nb' (wie Locale/arb).
      importLanguage: switch (_prefs.getString(_kImportLanguage) ?? '') {
        'no' => 'nb',
        final v => v,
      },
      importTranslate: _prefs.getBool(_kImportTranslate) ?? true,
      importStreamPhotos: _prefs.getBool(_kImportStreamPhotos) ?? true,
      importVideoAi: _prefs.getBool(_kImportVideoAi) ?? true,
      importPreset: switch (_prefs.getString(_kImportPreset)) {
        final v? when const ['fast', 'thorough', 'custom'].contains(v) => v,
        _ => 'thorough',
      },
      importOrganizers: switch (_prefs.getString(_kImportOrganizers)) {
        final v? when const ['create', 'existing', 'none'].contains(v) => v,
        _ => 'create',
      },
      showRecipeImages: _prefs.getBool(_kShowRecipeImages) ?? true,
      tabletSidebar: _prefs.getBool(_kTabletSidebar) ?? true,
      enableLogging: _prefs.getBool(_kEnableLogging) ?? false,
      isBiometricLockEnabled: _prefs.getBool(_kBiometricLock) ?? false,
      enableCriticalAlerts: _prefs.getBool(_kCriticalAlerts) ?? false,
      sendOptionalHeaders: _prefs.getBool(_kSendOptionalHeaders) ?? false,
      optionalHeaderKey1: _prefs.getString(_kOptHeaderKey1) ?? '',
      optionalHeaderValue1: _prefs.getString(_kOptHeaderVal1) ?? '',
      optionalHeaderKey2: _prefs.getString(_kOptHeaderKey2) ?? '',
      optionalHeaderValue2: _prefs.getString(_kOptHeaderVal2) ?? '',
      optionalHeaderKey3: _prefs.getString(_kOptHeaderKey3) ?? '',
      optionalHeaderValue3: _prefs.getString(_kOptHeaderVal3) ?? '',
      collapsedShoppingCategories:
          _prefs.getStringList(_kCollapsedCategories) ?? [],
      shoppingCategoryOrder: _prefs.getStringList(_kCategoryOrder) ?? [],
      quickAccessOrder: _prefs.getStringList(_kQuickAccessOrder) ?? [],
      homePinnedTiles: _prefs.getStringList(_kHomePinnedTiles) ?? [],
      homeTiles: _prefs.getStringList(_kHomeTiles),
      moreTilesOrder: _prefs.getStringList(_kMoreTilesOrder) ?? [],
      themeMode: _prefs.getString(_kThemeMode) ?? 'system',
      addExactQuantities: _prefs.getBool(_kAddExactQuantities) ?? false,
      generatedApiTokenId: _prefs.getString(_kGeneratedApiTokenId) ?? '',
      // Gastmodus ist BEWUSST flüchtig — er übersteht keinen App-Neustart.
      // Ein Gast, der die App schließt und neu öffnet, landet wieder im Setup
      // (kann erneut „Als Gast fortfahren" oder sich mit einem Server
      // verbinden). Innerhalb einer Sitzung bleibt der Modus über den
      // In-Memory-State (Riverpod) erhalten, nicht über SharedPreferences.
      isGuestMode: false,
      remindToShopEnabled: _prefs.getBool(_kRemindToShop) ?? false,
      shoppingReminderLocations: _loadReminderLocations(),
      offlineRecipeImages: _prefs.getBool(_kOfflineRecipeImages) ?? false,
      mealDiceFilters: {
        for (final slot in _kMealDiceSlots)
          slot:
              _prefs.getStringList('$_kMealDiceFilterPrefix$slot') ?? const [],
      },
      hideMealDiceAutoHint: _prefs.getBool(_kHideMealDiceAutoHint) ?? false,
      mealDiceUseMealieRules: _prefs.getBool(_kMealDiceUseMealieRules) ?? false,
    );
  }

  List<ShoppingReminderLocation> _loadReminderLocations() {
    final raw = _prefs.getString(_kShoppingReminderLocations);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) =>
              ShoppingReminderLocation.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  /// Entfernt aus der Würfel-Auswahl (alle Mahlzeiten) Einträge mit [prefix]
  /// (`c:` / `t:`), deren ID nicht mehr in [validIds] steht — sonst bleiben
  /// gelöschte Kategorien/Schlagworte als unsichtbare „Geister" gewählt
  /// (Zähler „(1)", aber kein Chip zum Abwählen; TestFlight-Feedback).
  Future<void> pruneMealDiceFilters(String prefix, Set<String> validIds) async {
    final current = state.valueOrNull;
    if (current == null) return;
    var changed = false;
    final next = {
      for (final e in current.mealDiceFilters.entries)
        e.key: e.value.where((k) {
          final keep = !k.startsWith(prefix) ||
              validIds.contains(k.substring(prefix.length));
          if (!keep) changed = true;
          return keep;
        }).toList(),
    };
    if (changed) await save(current.copyWith(mealDiceFilters: next));
  }

  Future<void> save(AppSettings next) async {
    // Secure storage NUR schreiben, wenn sich das Token wirklich geändert
    // hat — der Keychain- (iOS) bzw. Keystore-Zugriff
    // (Android) ist mit Abstand die teuerste Operation hier, lief bisher
    // aber bei JEDER Autosave-Auslösung mit (Listen-Dropdown, jedes
    // debouncte Textfeld, jeder Toggle) — auch wenn sich am Token gar nichts
    // änderte. Das machte z. B. den Einkaufslisten-Wechsel in den Settings
    // spürbar träge.
    final tokenChanged = next.apiToken.isNotEmpty &&
        next.apiToken != state.valueOrNull?.apiToken;
    if (tokenChanged) {
      try {
        await _secure.write(key: _kApiToken, value: next.apiToken);
      } catch (_) {
        // Fallback to prefs on emulators that lack secure storage
      }
    }
    // Die einzelnen SharedPreferences-Writes sind voneinander unabhängig —
    // PARALLEL statt sequenziell schreiben. Jeder `await` einzeln ist ein
    // eigener Platform-Channel-Roundtrip; 25 davon nacheinander summierten
    // sich bei JEDER Änderung zu spürbarer Latenz. `Future.wait` wartet auf
    // alle, bevor der State aktualisiert wird — Konsistenz bleibt erhalten.
    await Future.wait([
      // Immer die eingetragene Adresse — nie die gerade aktive WLAN-Adresse.
      _prefs.setString(_kServerUrl, next.primaryServerUrl),
      _prefs.setString(_kWifiServerUrl, next.wifiServerUrl),
      _prefs.setString(_kWifiSsid, next.wifiSsid),
      _prefs.setString(_kApiToken, next.apiToken),
      _prefs.setString(_kHouseholdId, next.householdId),
      _prefs.setString(_kShoppingListId, next.shoppingListId),
      _prefs.setString(_kApiVersion, next.apiVersion),
      _prefs.setString(_kSelectedLanguage, next.selectedLanguage),
      _prefs.setString(_kImportLanguage, next.importLanguage),
      _prefs.setBool(_kImportTranslate, next.importTranslate),
      _prefs.setString(_kImportOrganizers, next.importOrganizers),
      _prefs.setBool(_kImportStreamPhotos, next.importStreamPhotos),
      _prefs.setBool(_kImportVideoAi, next.importVideoAi),
      _prefs.setString(_kImportPreset, next.importPreset),
      _prefs.setBool(_kShowRecipeImages, next.showRecipeImages),
      _prefs.setBool(_kTabletSidebar, next.tabletSidebar),
      _prefs.setBool(_kEnableLogging, next.enableLogging),
      _prefs.setBool(_kBiometricLock, next.isBiometricLockEnabled),
      _prefs.setBool(_kCriticalAlerts, next.enableCriticalAlerts),
      _prefs.setBool(_kSendOptionalHeaders, next.sendOptionalHeaders),
      _prefs.setString(_kOptHeaderKey1, next.optionalHeaderKey1),
      _prefs.setString(_kOptHeaderVal1, next.optionalHeaderValue1),
      _prefs.setString(_kOptHeaderKey2, next.optionalHeaderKey2),
      _prefs.setString(_kOptHeaderVal2, next.optionalHeaderValue2),
      _prefs.setString(_kOptHeaderKey3, next.optionalHeaderKey3),
      _prefs.setString(_kOptHeaderVal3, next.optionalHeaderValue3),
      _prefs.setStringList(
          _kCollapsedCategories, next.collapsedShoppingCategories),
      _prefs.setStringList(_kCategoryOrder, next.shoppingCategoryOrder),
      _prefs.setStringList(_kQuickAccessOrder, next.quickAccessOrder),
      _prefs.setStringList(_kHomePinnedTiles, next.homePinnedTiles),
      if (next.homeTiles != null)
        _prefs.setStringList(_kHomeTiles, next.homeTiles!),
      _prefs.setStringList(_kMoreTilesOrder, next.moreTilesOrder),
      _prefs.setString(_kThemeMode, next.themeMode),
      _prefs.setBool(_kAddExactQuantities, next.addExactQuantities),
      _prefs.setString(_kGeneratedApiTokenId, next.generatedApiTokenId),
      // Gastmodus NICHT als true persistieren — er ist flüchtig (siehe
      // _load()). Den In-Memory-State (unten) setzen wir trotzdem mit
      // next.isGuestMode, damit der Modus innerhalb der laufenden Sitzung
      // gilt.
      _prefs.setBool(_kGuestMode, false),
      _prefs.setBool(_kRemindToShop, next.remindToShopEnabled),
      _prefs.setString(
        _kShoppingReminderLocations,
        jsonEncode(
            next.shoppingReminderLocations.map((l) => l.toJson()).toList()),
      ),
      _prefs.setBool(_kOfflineRecipeImages, next.offlineRecipeImages),
      for (final slot in _kMealDiceSlots)
        _prefs.setStringList('$_kMealDiceFilterPrefix$slot',
            next.mealDiceFilters[slot] ?? const []),
      _prefs.setBool(_kHideMealDiceAutoHint, next.hideMealDiceAutoHint),
      _prefs.setBool(_kMealDiceUseMealieRules, next.mealDiceUseMealieRules),
    ]);

    LogManager.shared.enabled = next.enableLogging;
    if (next.hasWifiServer) {
      final wasWatching = _connSub != null;
      _startWifiWatch();
      // Gerade eingerichtet/geändert → WLAN jetzt lesen statt erst beim
      // nächsten Netzwechsel.
      if (!wasWatching ||
          next.wifiSsid != state.valueOrNull?.wifiSsid ||
          next.wifiServerUrl != state.valueOrNull?.wifiServerUrl) {
        _ssid = await readWifiName();
      }
    } else {
      _stopWifiWatch();
    }
    state = AsyncData(_route(next));
  }

  Future<void> reset() async {
    _stopWifiWatch();
    await _prefs.clear();
    try {
      await _secure.deleteAll();
    } catch (_) {}
    state = const AsyncData(AppSettings());
  }
}
