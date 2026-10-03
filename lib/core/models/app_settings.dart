// Pure data model for app settings — no SharedPreferences logic here.
// Persistence is handled by SettingsRepository in core/providers/.

import 'shopping_reminder_location.dart';

class AppSettings {
  final String serverUrl;
  final String apiToken;
  final String householdId;
  final String shoppingListId;

  /// ID eines von der App per Benutzer/Passwort-Login SELBST erzeugten
  /// API-Tokens (POST /api/users/api-tokens) — leer, wenn `apiToken` manuell
  /// eingegeben wurde. Erlaubt Aufräumen beim Reset (DELETE .../{id}), damit
  /// sich im Mealie-Profil nicht bei jedem Reset+Neu-Login ein weiteres
  /// Token ansammelt.
  final String generatedApiTokenId;

  /// "v2" or "v3"
  final String apiVersion;

  final String selectedLanguage; // e.g. "en", "de"

  /// Zielsprache des KI-Rezeptimports (Mealie `translateLanguage`).
  /// LEER = der App-Sprache folgen — so bleibt der Standard automatisch
  /// richtig, wenn der Nutzer später die App-Sprache wechselt. Ein bewusst
  /// gewählter Wert (z. B. „uk", weil die Oberfläche das nicht anbietet)
  /// bleibt dagegen bestehen. Auflösung über [effectiveImportLanguage].
  final String importLanguage;
  final bool showRecipeImages;
  final bool enableLogging;
  final bool isBiometricLockEnabled;
  final bool enableCriticalAlerts;
  final bool sendOptionalHeaders;

  final String optionalHeaderKey1;
  final String optionalHeaderValue1;
  final String optionalHeaderKey2;
  final String optionalHeaderValue2;
  final String optionalHeaderKey3;
  final String optionalHeaderValue3;

  final List<String> collapsedShoppingCategories;

  /// User-defined order of shopping categories (by label name). Categories not
  /// present here fall back to the server label order.
  final List<String> shoppingCategoryOrder;

  /// User-defined order of the home quick-access tiles (by stable key, e.g.
  /// "recipes"/"shopping"/…). Empty → default order.
  final List<String> quickAccessOrder;

  /// ALT (bis 2026-09-28): aus „Weiteres" zusätzlich angepinnte Kacheln.
  /// Nur noch für die einmalige Übernahme in [homeTiles] gelesen.
  final List<String> homePinnedTiles;

  /// Kacheln auf dem Startbildschirm (Keys wie 'recipes', 'tools' …), per
  /// Pin in „Weiteres" gewählt. `null` = noch nie geändert → Standard-Set
  /// (siehe `effectiveHomeTiles` im Home-Screen). „Weiteres" selbst ist
  /// immer da und zählt zur Obergrenze von 8.
  final List<String>? homeTiles;

  /// Eigene Reihenfolge der Kacheln in „Weiteres" (Ziehen).
  final List<String> moreTilesOrder;

  /// App-Theme: 'system' (Default), 'light' oder 'dark'.
  final String themeMode;

  /// Zutaten mit exakter Rezeptmenge zur Einkaufsliste hinzufügen
  /// (z. B. „200 g Butter") statt als 1x ganze Einheit („1 Butter").
  final bool addExactQuantities;

  /// Lets the user skip the server connection in setup and use the app
  /// purely for offline / peer-to-peer features (e.g. joining a Cook Friends
  /// session). Treated like `isConfigured` by the setup redirect.
  final bool isGuestMode;

  /// "Erinnere mich zum Einkaufen" (Issue #29): Geofence-Erinnerung an bis zu
  /// 3 gespeicherten Standorten (z. B. Supermärkte). Benachrichtigt nur, wenn
  /// die Einkaufsliste offene Artikel hat — auch bei komplett geschlossener
  /// App (native Geofences, siehe ShoppingReminderBridge).
  final bool remindToShopEnabled;
  final List<ShoppingReminderLocation> shoppingReminderLocations;

  /// Alle Rezeptbilder dauerhaft aufs Gerät laden (RecipeImageStore), damit
  /// sie offline angezeigt werden. Standard AUS: bei großen Bibliotheken
  /// sind das schnell mehrere hundert MB.
  final bool offlineRecipeImages;

  /// Würfel im Mahlzeitenplan: pro Mahlzeit ('breakfast'/'lunch'/'dinner')
  /// die gewählten Kategorien und Schlagworte als `c:<id>` bzw. `t:<id>`.
  /// Leer = automatische Stichwort-Erkennung wie bisher. Nur lokal (Mealie
  /// hat dafür kein Feld).
  final Map<String, List<String>> mealDiceFilters;

  /// „Nicht mehr anzeigen" für den Hinweis zur automatischen Auswahl.
  final bool hideMealDiceAutoHint;

  /// Welches System der Würfel im Mahlzeitenplan nutzt: `false` = App-
  /// Auswahl (Zahnrad-Kategorien/Schlagworte, sonst Stichwörter), `true` =
  /// Mealie-Regeln des Haushalts (wie der Zufallsknopf der Webapp).
  final bool mealDiceUseMealieRules;

  const AppSettings({
    this.serverUrl = '',
    this.apiToken = '',
    this.householdId = 'Family',
    this.shoppingListId = '',
    this.generatedApiTokenId = '',
    this.apiVersion = 'v2',
    this.selectedLanguage = 'en',
    this.importLanguage = '',
    this.showRecipeImages = true,
    this.enableLogging = false,
    this.isBiometricLockEnabled = false,
    this.enableCriticalAlerts = false,
    this.sendOptionalHeaders = false,
    this.optionalHeaderKey1 = '',
    this.optionalHeaderValue1 = '',
    this.optionalHeaderKey2 = '',
    this.optionalHeaderValue2 = '',
    this.optionalHeaderKey3 = '',
    this.optionalHeaderValue3 = '',
    this.collapsedShoppingCategories = const [],
    this.shoppingCategoryOrder = const [],
    this.quickAccessOrder = const [],
    this.homePinnedTiles = const [],
    this.homeTiles,
    this.moreTilesOrder = const [],
    this.themeMode = 'system',
    this.addExactQuantities = false,
    this.isGuestMode = false,
    this.remindToShopEnabled = false,
    this.shoppingReminderLocations = const [],
    this.offlineRecipeImages = false,
    this.mealDiceFilters = const {},
    this.hideMealDiceAutoHint = false,
    this.mealDiceUseMealieRules = false,
  });

  /// Sprache, in der importierte Rezepte ankommen sollen — der explizit
  /// gewählte Wert, sonst die App-Sprache.
  String get effectiveImportLanguage =>
      importLanguage.isEmpty ? selectedLanguage : importLanguage;

  bool get isConfigured => serverUrl.isNotEmpty && apiToken.isNotEmpty;
  bool get setupComplete => isConfigured || isGuestMode;

  Map<String, String> get optionalHeaders {
    final headers = <String, String>{};
    if (!sendOptionalHeaders) return headers;
    if (optionalHeaderKey1.isNotEmpty) {
      headers[optionalHeaderKey1] = optionalHeaderValue1;
    }
    if (optionalHeaderKey2.isNotEmpty) {
      headers[optionalHeaderKey2] = optionalHeaderValue2;
    }
    if (optionalHeaderKey3.isNotEmpty) {
      headers[optionalHeaderKey3] = optionalHeaderValue3;
    }
    return headers;
  }

  AppSettings copyWith({
    String? serverUrl,
    String? apiToken,
    String? householdId,
    String? shoppingListId,
    String? generatedApiTokenId,
    String? apiVersion,
    String? selectedLanguage,
    String? importLanguage,
    bool? showRecipeImages,
    bool? enableLogging,
    bool? isBiometricLockEnabled,
    bool? enableCriticalAlerts,
    bool? sendOptionalHeaders,
    String? optionalHeaderKey1,
    String? optionalHeaderValue1,
    String? optionalHeaderKey2,
    String? optionalHeaderValue2,
    String? optionalHeaderKey3,
    String? optionalHeaderValue3,
    List<String>? collapsedShoppingCategories,
    List<String>? shoppingCategoryOrder,
    List<String>? quickAccessOrder,
    List<String>? homePinnedTiles,
    List<String>? homeTiles,
    List<String>? moreTilesOrder,
    String? themeMode,
    bool? addExactQuantities,
    bool? isGuestMode,
    bool? remindToShopEnabled,
    List<ShoppingReminderLocation>? shoppingReminderLocations,
    bool? offlineRecipeImages,
    Map<String, List<String>>? mealDiceFilters,
    bool? hideMealDiceAutoHint,
    bool? mealDiceUseMealieRules,
  }) {
    return AppSettings(
      serverUrl: serverUrl ?? this.serverUrl,
      apiToken: apiToken ?? this.apiToken,
      householdId: householdId ?? this.householdId,
      shoppingListId: shoppingListId ?? this.shoppingListId,
      generatedApiTokenId: generatedApiTokenId ?? this.generatedApiTokenId,
      apiVersion: apiVersion ?? this.apiVersion,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      importLanguage: importLanguage ?? this.importLanguage,
      showRecipeImages: showRecipeImages ?? this.showRecipeImages,
      enableLogging: enableLogging ?? this.enableLogging,
      isBiometricLockEnabled:
          isBiometricLockEnabled ?? this.isBiometricLockEnabled,
      enableCriticalAlerts: enableCriticalAlerts ?? this.enableCriticalAlerts,
      sendOptionalHeaders: sendOptionalHeaders ?? this.sendOptionalHeaders,
      optionalHeaderKey1: optionalHeaderKey1 ?? this.optionalHeaderKey1,
      optionalHeaderValue1: optionalHeaderValue1 ?? this.optionalHeaderValue1,
      optionalHeaderKey2: optionalHeaderKey2 ?? this.optionalHeaderKey2,
      optionalHeaderValue2: optionalHeaderValue2 ?? this.optionalHeaderValue2,
      optionalHeaderKey3: optionalHeaderKey3 ?? this.optionalHeaderKey3,
      optionalHeaderValue3: optionalHeaderValue3 ?? this.optionalHeaderValue3,
      collapsedShoppingCategories:
          collapsedShoppingCategories ?? this.collapsedShoppingCategories,
      shoppingCategoryOrder:
          shoppingCategoryOrder ?? this.shoppingCategoryOrder,
      quickAccessOrder: quickAccessOrder ?? this.quickAccessOrder,
      homePinnedTiles: homePinnedTiles ?? this.homePinnedTiles,
      homeTiles: homeTiles ?? this.homeTiles,
      moreTilesOrder: moreTilesOrder ?? this.moreTilesOrder,
      themeMode: themeMode ?? this.themeMode,
      addExactQuantities: addExactQuantities ?? this.addExactQuantities,
      isGuestMode: isGuestMode ?? this.isGuestMode,
      remindToShopEnabled: remindToShopEnabled ?? this.remindToShopEnabled,
      shoppingReminderLocations:
          shoppingReminderLocations ?? this.shoppingReminderLocations,
      offlineRecipeImages: offlineRecipeImages ?? this.offlineRecipeImages,
      mealDiceFilters: mealDiceFilters ?? this.mealDiceFilters,
      hideMealDiceAutoHint: hideMealDiceAutoHint ?? this.hideMealDiceAutoHint,
      mealDiceUseMealieRules:
          mealDiceUseMealieRules ?? this.mealDiceUseMealieRules,
    );
  }
}
