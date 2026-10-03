import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/mealplan/providers/mealplan_provider.dart';
import '../../features/recipes/providers/recipes_provider.dart';
import '../../features/shopping_list/providers/shopping_list_provider.dart';
import '../../l10n/app_localizations.dart';
import '../models/app_settings.dart';
import '../models/mealplan_entry.dart';
import '../models/recipe_detail.dart';
import '../models/shopping_item.dart';
import '../models/shopping_reminder_location.dart';
import '../providers/settings_provider.dart';
import '../utils/ingredient_display.dart';
import 'log_manager.dart';
import 'shopping_reminder_bridge.dart';
import 'watch_bridge.dart';
import 'widget_bridge.dart';

// ---------------------------------------------------------------------------
// widgetSyncProvider — zentraler Riverpod-Knoten, der alle iOS-Home-Screen-
// Widget-Datenquellen (Mealplan, ShoppingList, Daily-Recipe-Pool, Sprache)
// beobachtet und bei Änderungen über `WidgetBridge` an die App-Group-
// UserDefaults pusht.
//
// Architektur: Bündel-Provider statt verstreute `ref.listen`s in jedem
// Feature-Provider. Vorteile:
//   • Single Source of Truth wenn neue Widget-Datenquellen dazukommen.
//   • Feature-Provider bleiben unwissend über Widget-Persistenz (saubere
//     Abhängigkeitsrichtung).
//   • In Tests trivial deaktivierbar (override).
//
// Aktivierung: `ref.watch(widgetSyncProvider)` in `MealieApp.build()` —
// dadurch lebt der Provider so lange wie die App, und alle internen
// `ref.listen`s bleiben aktiv.
// ---------------------------------------------------------------------------

/// Obergrenze für die Recipe-Pool-Liste, die der DailyRecipeWidget rotiert.
/// Hintergrund: das Swift-Widget zieht aus diesem Pool deterministisch per
/// Day-Index ein Rezept — der UserDefaults-Wert sollte nicht ins MB-Land
/// wachsen (App-Group-UserDefaults haben weiche Performance-Grenzen). 365
/// Einträge bedeuten ein Jahr ohne Wiederholung bei deterministischer
/// Tagesrotation und bleiben payload-mäßig schlank.
const _dailyRecipePoolCap = 365;

final widgetSyncProvider = Provider<void>((ref) {
  // -------------------------------------------------------------------------
  // 1) Sprache
  // -------------------------------------------------------------------------
  // Initial-Push beim ersten Build des Providers (Re-Install-Szenario:
  // UserDefaults sind leer, das Widget würde sonst auf den Swift-Default
  // "de" fallen, auch wenn der User in den Settings "en" stehen hat).
  final initialSettings = ref.read(settingsProvider).valueOrNull;
  if (initialSettings != null) {
    WidgetBridge.saveLanguage(initialSettings.selectedLanguage);
    WatchBridge.updateLanguage(initialSettings.selectedLanguage);
  }
  ref.listen(settingsProvider, (prev, next) {
    final nextLang = next.valueOrNull?.selectedLanguage;
    if (nextLang == null) return;
    final prevLang = prev?.valueOrNull?.selectedLanguage;
    if (prevLang == nextLang) return;
    WidgetBridge.saveLanguage(nextLang);
    WatchBridge.updateLanguage(nextLang);
  });

  // -------------------------------------------------------------------------
  // 1b) Zugang für die Selbst-Aktualisierung der Widgets
  // -------------------------------------------------------------------------
  // Die Widgets holen Einkaufsliste und Essensplan selbst vom Server
  // (Änderungen aus der Webapp/anderen Geräten ohne App-Start). Nur bei
  // Änderung neu übergeben; abgemeldet → Zugang löschen.
  String? lastAccessSig;
  void pushAccess(AppSettings? s) {
    final access = (s == null || !s.isConfigured || s.apiToken.isEmpty)
        ? null
        : <String, dynamic>{
            'url': s.serverUrl,
            'token': s.apiToken,
            if (s.optionalHeaders.isNotEmpty) 'headers': s.optionalHeaders,
            if (s.shoppingListId.isNotEmpty) 'listId': s.shoppingListId,
            'exact': s.addExactQuantities,
          };
    final sig = access == null ? '' : access.toString();
    if (sig == lastAccessSig) return;
    lastAccessSig = sig;
    WidgetBridge.saveServerAccess(access);
  }

  pushAccess(ref.read(settingsProvider).valueOrNull);
  ref.listen(settingsProvider, (_, next) {
    if (next.hasValue) pushAccess(next.valueOrNull);
  });

  // -------------------------------------------------------------------------
  // 2) Mealplan
  // -------------------------------------------------------------------------
  // Nur bei `data`-State pushen — bei loading/error würde sonst leerer
  // Inhalt das Widget plattmachen.
  ref.listen(mealplanProvider, (prev, next) {
    final data = next.valueOrNull;
    if (data == null) return;
    final lang =
        ref.read(settingsProvider).valueOrNull?.selectedLanguage ?? 'de';
    final l10n = lookupAppLocalizations(Locale(lang));
    WidgetBridge.saveMealplan(_mapMealplan(data, l10n));
  });

  // -------------------------------------------------------------------------
  // 3) ShoppingList
  // -------------------------------------------------------------------------
  // Abhaken von der Uhr: toggelt `checked` für das Item mit der gesendeten id
  // (synchronisiert zum Server wie ein Tap in der App).
  WatchBridge.ensureActionListener();
  WatchBridge.shoppingActionHandler = (itemId) {
    final items = ref.read(shoppingListProvider).valueOrNull ?? const [];
    ShoppingItem? found;
    for (final i in items) {
      if (i.id == itemId) {
        found = i;
        break;
      }
    }
    LogManager.shared.log('🛒 watch shoppingAction id=$itemId '
        'items=${items.length} found=${found != null}');
    if (found != null) {
      ref.read(shoppingListProvider.notifier).toggleChecked(found);
    }
  };

  void pushShopping(List<ShoppingItem> items) {
    // Artikeltexte spiegeln den „exakte Mengen"-Toggle: AN = Webapp-Ansicht
    // („150 g Joghurt"), AUS = 1x-Stückkauf-Sicht (nur der Name).
    final exact =
        ref.read(settingsProvider).valueOrNull?.addExactQuantities ?? false;
    WidgetBridge.saveShopping(_mapShopping(items, exact));
    // Auf die Smartwatch spiegeln (Apple Watch / Wear OS): alle Artikel mit
    // id/Anzeigetext/Kategorie/checked, sortiert wie die Shopping-List-View
    // (offen nach Kategorie, dann erledigte). Die Uhr kann so gruppieren und
    // abhaken.
    final labelOrder =
        (ref.read(shoppingLabelsProvider).valueOrNull ?? const [])
            .map((l) => l.name)
            .toList();
    WatchBridge.updateShopping(_mapShoppingForWatch(items, labelOrder, exact));
  }

  ref.listen(shoppingListProvider, (prev, next) {
    final items = next.valueOrNull;
    if (items == null) return;
    pushShopping(items);
  });

  // Toggle-Wechsel in den Settings ändert die Artikeltexte → Widget/Watch
  // sofort neu pushen, nicht erst bei der nächsten Listen-Änderung.
  ref.listen(settingsProvider, (prev, next) {
    final was = prev?.valueOrNull?.addExactQuantities;
    final now = next.valueOrNull?.addExactQuantities;
    if (was == now) return;
    final items = ref.read(shoppingListProvider).valueOrNull;
    if (items != null) pushShopping(items);
  });

  // -------------------------------------------------------------------------
  // 4) Daily-Recipe-Pool
  // -------------------------------------------------------------------------
  ref.listen(recipesProvider, (prev, next) {
    final recipes = next.valueOrNull;
    // Während des inkrementellen Cold-Loads liefert der Provider mehrfach
    // Teil-Listen — wir pushen jeden Zwischenstand, damit das Widget
    // möglichst früh überhaupt etwas zeigt. Leere Liste wäre allerdings
    // sinnloser Reset, also überspringen.
    if (recipes == null || recipes.isEmpty) return;
    WidgetBridge.saveDaily(_mapRecipes(recipes));
  });

  // -------------------------------------------------------------------------
  // 5) Shopping-Reminder-Geofences (Issue #29)
  // -------------------------------------------------------------------------
  // Pusht die gespeicherten Standorte an die native Seite, sobald sich Toggle
  // oder Liste ändern — die native Seite registriert/entfernt dann die
  // echten OS-Geofences. Das eigentliche "hat die Liste offene Artikel"-
  // Signal für den Trigger-Moment liest die native Seite direkt aus dem
  // ohnehin aktuellen Widget-Store (siehe ShoppingReminderBridge-Header),
  // wird hier also NICHT extra gepusht.
  void pushReminderLocations(AppSettings s) {
    ShoppingReminderBridge.setLocations(
        s.remindToShopEnabled ? s.shoppingReminderLocations : const []);
  }

  final initialReminderSettings = ref.read(settingsProvider).valueOrNull;
  if (initialReminderSettings != null) {
    pushReminderLocations(initialReminderSettings);
  }
  ref.listen(settingsProvider, (prev, next) {
    final s = next.valueOrNull;
    if (s == null) return;
    final prevS = prev?.valueOrNull;
    if (prevS != null &&
        prevS.remindToShopEnabled == s.remindToShopEnabled &&
        _sameReminderLocations(
            prevS.shoppingReminderLocations, s.shoppingReminderLocations)) {
      return;
    }
    pushReminderLocations(s);
  });
});

bool _sameReminderLocations(
    List<ShoppingReminderLocation> a, List<ShoppingReminderLocation> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].id != b[i].id ||
        a[i].name != b[i].name ||
        a[i].latitude != b[i].latitude ||
        a[i].longitude != b[i].longitude) {
      return false;
    }
  }
  return true;
}

// ---------------------------------------------------------------------------
// Mapper — wandeln App-Modelle in die Codable-Subsets der Swift-Widgets.
// Schema-Quelle: ios/MealieTimerWidget/WidgetSharedStore.swift
// ---------------------------------------------------------------------------

/// Mapping `entryType` → Widget-Slot. Swift-Widget filtert per Switch über
/// genau diese 3 Strings; Mealie-Eintragstypen wie "side" haben kein eigenes
/// Widget-Slot-Pendant und werden bewusst weggelassen (statt willkürlich auf
/// dinner gemappt zu werden).
const _slotKey = {
  'breakfast': 'breakfast',
  'lunch': 'lunch',
  'dinner': 'dinner',
};

String _slotName(String slot, AppLocalizations l10n) {
  switch (slot) {
    case 'breakfast':
      return l10n.breakfast;
    case 'lunch':
      return l10n.lunch;
    case 'dinner':
      return l10n.dinner;
  }
  return slot;
}

List<Map<String, dynamic>> _mapMealplan(
    Map<DateTime, List<MealplanEntry>> byDay, AppLocalizations l10n) {
  final out = <Map<String, dynamic>>[];
  byDay.forEach((_, entries) {
    for (final e in entries) {
      final slot = _slotKey[e.entryType];
      if (slot == null) continue; // side / unknown — skip, kein Widget-Slot
      // Rezeptname: bevorzugt verlinktes Rezept, fallback Freitext-Title.
      final recipeName = e.recipe?.name ?? e.title ?? '';
      if (recipeName.isEmpty) continue;
      out.add({
        'date': e.date,
        'slot': slot,
        'slotName': _slotName(slot, l10n),
        'recipeName': recipeName,
        if (e.recipe?.id != null) 'recipeId': e.recipe!.id,
      });
    }
  });
  return out;
}

List<Map<String, dynamic>> _mapShopping(List<ShoppingItem> items, bool exact) {
  return [
    for (final i in items)
      {
        'id': i.id,
        'name': _shoppingItemText(i, exact),
        'checked': i.checked,
        if (i.label?.name != null) 'category': i.label!.name,
      },
  ];
}

// Artikeltext für Widget & Watch — spiegelt den „exakte Mengen"-Toggle:
//   AN:  Webapp-Ansicht „<Menge> <Einheit> <Name>" („150 g Joghurt 1,5%").
//   AUS: 1x-Stückkauf-Sicht — Einheiten-Artikel nur mit Namen, reine
//        Stück-Artikel mit Anzahl („3 Butter"), bei 1x ohne Präfix-Rauschen.
// Bewusst aus quantity/unit/displayName gebaut statt displayText, weil
// displayText das server-seitige `display`-Feld bevorzugt, dessen Format
// wir nicht kontrollieren. Brüche + Plural von Einheit/Zutat wie in der
// Rezept-Detailansicht (Issue #32).
String _shoppingItemText(ShoppingItem i, bool exact) {
  final abbreviation = i.unit?.abbreviation;
  // unitCarriesName („Eier (Größe M)"): Einheit steckt schon im displayName —
  // als Stück-Artikel behandeln (Anzahl statt 1x, kein Einheiten-Präfix).
  final hasUnit = ((abbreviation?.isNotEmpty ?? false) ||
          (i.unit?.name?.isNotEmpty ?? false)) &&
      !i.unitCarriesName;
  if (!exact) {
    if (hasUnit) return i.displayName;
    // effectiveQuantity: Webapp-Adds ungeparster Zutaten haben quantity 0 —
    // ohne Normalisierung stünde „0 1 Möhre(n)" auf Widget und Uhr.
    final qty = i.effectiveQuantity;
    if (qty == 1) return i.displayName;
    final usePlural = shouldPluralize(qty);
    return '${formatQuantity(qty)} ${i.displayNamePlural(usePlural)}';
  }
  final qty = i.quantity ?? 0;
  final usePlural = shouldPluralize(qty);
  final unitLabel = (abbreviation?.isNotEmpty ?? false)
      ? abbreviation!
      : pluralize(i.unit?.name ?? '', i.unit?.pluralName, usePlural);
  return [
    if (qty > 0) formatQuantity(qty),
    if (hasUnit) unitLabel,
    i.displayNamePlural(usePlural),
  ].join(' ');
}

/// Alle Artikel für die Uhr: id + Anzeigetext + Kategorie + checked. Sortiert
/// wie die Shopping-List-View — offene zuerst nach Kategorie (in Label-
/// Reihenfolge, Unkategorisierte zuletzt) und innerhalb der Kategorie nach
/// Name, danach die erledigten. Die Uhr gruppiert in Erscheinungsreihenfolge
/// und kann abhaken. `category` leer = unkategorisiert.
List<Map<String, dynamic>> _mapShoppingForWatch(
    List<ShoppingItem> items, List<String> categoryOrder, bool exact) {
  String cat(ShoppingItem i) => i.label?.name ?? '';
  int catRank(String c) {
    if (c.isEmpty) return 1 << 30; // unkategorisiert ans Ende
    final idx = categoryOrder.indexOf(c);
    return idx == -1 ? (1 << 29) : idx;
  }

  final unchecked = items.where((i) => !i.checked).toList()
    ..sort((a, b) {
      final r = catRank(cat(a)).compareTo(catRank(cat(b)));
      if (r != 0) return r;
      final c = cat(a).compareTo(cat(b));
      if (c != 0) return c;
      return a.displayName.compareTo(b.displayName);
    });
  final checked = items.where((i) => i.checked).toList()
    ..sort((a, b) => a.displayName.compareTo(b.displayName));

  Map<String, dynamic> enc(ShoppingItem i) => {
        'id': i.id,
        // Gleicher Toggle-abhängiger Text wie das Home-Widget (statt
        // displayText, das dem unkontrollierten Server-`display` vertraut).
        'text': _shoppingItemText(i, exact),
        'category': cat(i),
        'categoryColor': _categoryColorHex(i.label?.color, cat(i)),
        'checked': i.checked,
      };

  return [
    for (final i in unchecked) enc(i),
    for (final i in checked) enc(i),
  ];
}

/// Auflösung der Kategorie-Farbe als 6-stelliger Hex-String (RRGGBB) — 1:1 zu
/// `shoppingCategoryColor` der Phone-View: Label-Hex bevorzugt, sonst eine
/// deterministische Palette per `name.hashCode`. Wird vom Handy berechnet und
/// an die Uhr gesendet, weil Swift/Kotlin einen anderen String-hashCode haben
/// und die Fallback-Farbe sonst nicht matchen würde.
String _categoryColorHex(String? hex, String name) {
  if (hex != null && hex.trim().isNotEmpty) {
    var h = hex.replaceAll('#', '').trim();
    if (h.length == 8) h = h.substring(2); // ARGB → RGB (Alpha strippen)
    if (h.length == 6 && int.tryParse(h, radix: 16) != null) {
      return h.toUpperCase();
    }
  }
  // Spiegelt die Material-Palette aus shoppingCategoryColor (gleiche Reihenfolge).
  const palette = [
    '009688',
    '3F51B5',
    'FF9800',
    '9C27B0',
    '4CAF50',
    'F44336',
    '2196F3',
    'E91E63',
    '795548',
    '00BCD4',
  ];
  return palette[name.hashCode.abs() % palette.length];
}

List<Map<String, dynamic>> _mapRecipes(List<RecipeDetail> recipes) {
  // Cap auf _dailyRecipePoolCap — der Pool wird deterministisch per
  // Tagesindex rotiert, mehr als ein Jahr Vorrat bringt nichts und
  // bläht den UserDefaults-Payload unnötig auf.
  final capped = recipes.length > _dailyRecipePoolCap
      ? recipes.sublist(0, _dailyRecipePoolCap)
      : recipes;
  return [
    for (final r in capped)
      {
        'id': r.id,
        'name': r.name,
        if (r.description != null && r.description!.isNotEmpty)
          'description': r.description,
        if (r.recipeCategory.isNotEmpty)
          'category': r.recipeCategory.first.name,
      },
  ];
}
