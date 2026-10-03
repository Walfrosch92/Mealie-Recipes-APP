import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// WidgetBridge — Dart-Seite der `mealie/widget` MethodChannel-Brücke.
//
// Pusht die Widget-Datenmodelle als JSON-Strings auf die native Seite, wo
// sie ins persistente Key-Value-Store geschrieben werden und ein
// Widget-Reload getriggert wird.
//
//   • iOS  → `ios/Runner/WidgetBridge.swift` schreibt in App-Group
//            UserDefaults und ruft `WidgetCenter.reloadTimelines`.
//   • Android → `MainActivity.kt` schreibt in DataStore<Preferences>
//            (siehe `android/.../widgets/WidgetSharedStore.kt`) und
//            ruft `GlanceAppWidgetManager.update(...)` pro Widget-Kind.
//
// Beide Plattformen verwenden dieselbe Channel-API und dasselbe JSON-
// Schema — der einzige Unterschied ist welche `kind`-Strings im
// `reload`-Aufruf bekannt sind (Swift-`Widget.kind` Identifier sind
// auf Android im `MainActivity.reload(...)`-Switch gemappt).
//
// Schema der gepushten JSON-Objekte ist 1:1 zu den Swift-Codables in
// `ios/MealieTimerWidget/WidgetSharedStore.swift` resp. den Kotlin-
// `@Serializable`-Klassen in `WidgetSharedStore.kt`:
//   • WidgetMealEntry      { date, slot, slotName, recipeName, recipeId? }
//   • WidgetShoppingItem   { id, name, checked, category? }
//   • WidgetRecipeSummary  { id, name, description?, category? }
// ---------------------------------------------------------------------------

class WidgetBridge {
  static const _channel = MethodChannel('mealie/widget');

  WidgetBridge._();

  /// Sprache des Widgets (für die statische l10n-Tabelle im Swift-Code).
  /// `lang` muss einer der 5-Sprachen-Codes `de|en|es|fr|nl` sein.
  static Future<void> saveLanguage(String lang) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('saveLanguage', {'lang': lang});
    } catch (_) {/* widget-bridge ist best-effort */}
  }

  /// Mealplan-Einträge → MealplanWidget.
  /// `entries` ist Liste<Map> mit den Keys date/slot/slotName/recipeName/recipeId.
  static Future<void> saveMealplan(List<Map<String, dynamic>> entries) async {
    if (!_supported) return;
    try {
      await _channel
          .invokeMethod('saveMealplan', {'json': jsonEncode(entries)});
    } catch (_) {}
  }

  /// Shopping-Items → ShoppingListWidget.
  /// `items` ist Liste<Map> mit Keys id/name/checked/category.
  static Future<void> saveShopping(List<Map<String, dynamic>> items) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('saveShopping', {'json': jsonEncode(items)});
    } catch (_) {}
  }

  /// Recipe-Pool für DailyRecipeWidget (rotiert tagesweise per Day-Index).
  /// `recipes` ist Liste<Map> mit Keys id/name/description/category.
  static Future<void> saveDaily(List<Map<String, dynamic>> recipes) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('saveDaily', {'json': jsonEncode(recipes)});
    } catch (_) {}
  }

  /// Optional: manueller Reload eines bestimmten Widget-Kinds oder aller.
  /// `kind` muss matchen mit `MealplanWidget` | `ShoppingListWidget` |
  /// `DailyRecipeWidget` (Swift-Widget.kind).
  /// Zugangsdaten für die Selbst-Aktualisierung der Widgets (Server, Token,
  /// Zusatz-Header, aktive Liste, „exakte Mengen"). Nativ geschützt
  /// abgelegt (iOS Keychain, Android Keystore). Leer = löschen (Abmelden).
  static Future<void> saveServerAccess(Map<String, dynamic>? access) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('saveServerAccess',
          {'json': access == null ? '' : jsonEncode(access)});
    } catch (_) {}
  }

  static Future<void> reload({String? kind}) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('reload', {if (kind != null) 'kind': kind});
    } catch (_) {}
  }

  /// iOS (WidgetKit) und Android (Jetpack Glance) implementieren beide
  /// die `mealie/widget`-MethodChannel-Pipeline. Andere Plattformen
  /// (Desktop, Web) haben keine Home-Screen-Widgets — Aufrufe werden
  /// einfach geschluckt.
  static bool get _supported => Platform.isIOS || Platform.isAndroid;
}
