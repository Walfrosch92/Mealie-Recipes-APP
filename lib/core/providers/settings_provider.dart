import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';
import '../models/shopping_reminder_location.dart';
import '../services/log_manager.dart';

// ---------------------------------------------------------------------------
// Keys
// ---------------------------------------------------------------------------

const _kServerUrl = 'serverUrl';
const _kHouseholdId = 'householdId';
const _kShoppingListId = 'shoppingListId';
const _kApiVersion = 'apiVersion';
const _kSelectedLanguage = 'selectedLanguage';
const _kImportLanguage = 'importLanguage';
const _kShowRecipeImages = 'showRecipeImages';
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
const _kMealDiceSlots = ['breakfast', 'lunch', 'dinner'];
const _kHideMealDiceAutoHint = 'hideMealDiceAutoHint';
const _kMealDiceUseMealieRules = 'mealDiceUseMealieRules';

// API token stored in secure storage
const _kApiToken = 'apiToken';

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  late final FlutterSecureStorage _secure;
  late final SharedPreferences _prefs;

  @override
  Future<AppSettings> build() async {
    _secure = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      // macOS: klassischer Schlüsselbund — der Data-Protection-Keychain
      // (Standard) braucht die Keychain-Sharing-Berechtigung samt
      // Developer-Team, sonst schlägt jeder Zugriff fehl (-34018).
      // Eigener Dienstname, damit der Deinstaller (macos/packaging) genau
      // diesen Eintrag löschen kann, ohne andere Flutter-Apps zu treffen.
      mOptions: MacOsOptions(
        accountName: 'Walfrosch92.MealieRecipes',
        useDataProtectionKeyChain: false,
      ),
    );
    _prefs = await SharedPreferences.getInstance();
    final loaded = _load();
    // Honor the persisted logging preference at startup so prints captured
    // by the zone hook before settings load don't get recorded behind the
    // user's back.
    LogManager.shared.enabled = loaded.enableLogging;
    return loaded;
  }

  AppSettings _load() {
    final token = _prefs.getString(_kApiToken) ?? '';
    return AppSettings(
      serverUrl: _prefs.getString(_kServerUrl) ?? '',
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
      showRecipeImages: _prefs.getBool(_kShowRecipeImages) ?? true,
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

  Future<void> save(AppSettings next) async {
    // Secure storage NUR schreiben, wenn sich das Token wirklich geändert
    // hat — der Keychain- (iOS) bzw. EncryptedSharedPreferences-Zugriff
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
      _prefs.setString(_kServerUrl, next.serverUrl),
      _prefs.setString(_kApiToken, next.apiToken),
      _prefs.setString(_kHouseholdId, next.householdId),
      _prefs.setString(_kShoppingListId, next.shoppingListId),
      _prefs.setString(_kApiVersion, next.apiVersion),
      _prefs.setString(_kSelectedLanguage, next.selectedLanguage),
      _prefs.setString(_kImportLanguage, next.importLanguage),
      _prefs.setBool(_kShowRecipeImages, next.showRecipeImages),
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
    state = AsyncData(next);
  }

  Future<void> reset() async {
    await _prefs.clear();
    try {
      await _secure.deleteAll();
    } catch (_) {}
    state = const AsyncData(AppSettings());
  }

  Future<void> toggleCollapsedCategory(String categoryId) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final list = List<String>.from(current.collapsedShoppingCategories);
    if (list.contains(categoryId)) {
      list.remove(categoryId);
    } else {
      list.add(categoryId);
    }
    await save(current.copyWith(collapsedShoppingCategories: list));
  }
}
