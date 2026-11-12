import 'package:flutter/painting.dart' show PaintingBinding;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/shopping_list/services/google_tasks_import_service.dart';
import '../../features/timer/services/notification_service.dart';
import '../services/connection_monitor.dart';
import '../services/log_manager.dart';
import '../services/recipe_detail_cache.dart';
import '../services/recipe_image_store.dart';
import '../services/shopping_reminder_bridge.dart';
import '../services/watch_bridge.dart';
import '../services/widget_bridge.dart';
import '../utils/platform_features.dart';
import 'account_scope.dart';
import 'account_storage.dart';

// ---------------------------------------------------------------------------
// Der eigentliche Kontowechsel — läuft NUR, während kein ProviderScope lebt
// (AppRoot hat ihn vorher aus dem Baum genommen, alle Provider sind
// entsorgt). Ablauf:
//   1. freeze: Epoche hoch (alle alten ApiService-Instanzen sind tot),
//      Konto-Schlüssel in SharedPreferences gesperrt.
//   2. Ausstehendes des alten Kontos zu Ende schreiben bzw. abwarten
//      (Rezept-Cache-Debounce, Bild-Downloads), kurze Ruhephase.
//   3. [work] (Ablegen/Zurückspielen) — als einziger Code schreibberechtigt.
//   4. Singletons vergessen, native Oberflächen (Widgets, Uhr, Geofences)
//      leeren, SharedPreferences von der Platte neu lesen, entsperren.
// Danach baut AppRoot einen frischen ProviderScope auf.
// ---------------------------------------------------------------------------

class AccountTransition {
  AccountTransition._();

  static Future<void> run(Future<void> Function(AccountStorage) work) async {
    AccountScope.freeze();
    // Statische Rückrufe zeigen noch auf Notifier des alten Kontos (Uhr-
    // Aktionen, Timer-Benachrichtigung). Der neue Scope setzt sie neu.
    WatchBridge.timerActionHandler = null;
    WatchBridge.cookingActionHandler = null;
    WatchBridge.shoppingActionHandler = null;
    NotificationService.onTimerTap = null;
    final storage = await AccountStorage.open();
    try {
      await RecipeDetailCacheManager.shared.flushForAccountSwitch();
      await RecipeImageStore.shared.quiesceForAccountSwitch();
      // Ruhephase für Fortsetzungen, die schon nach ihrem letzten await
      // stehen (z. B. JSON-Parsing im Isolate). Ihre Prefs-Schreibzugriffe
      // prallen am Guard ab, Dio-Antworten an der Epoche.
      await Future<void>.delayed(const Duration(milliseconds: 600));
      await AccountScope.privileged(() => work(storage));
    } catch (e) {
      LogManager.shared.log('❌ Kontowechsel fehlgeschlagen: $e');
      // Halb erledigten Zustand sofort auflösen (gleiche Logik wie beim
      // Start nach einem Absturz).
      try {
        await AccountScope.privileged(storage.recover);
      } catch (_) {}
      rethrow;
    } finally {
      RecipeDetailCacheManager.shared.resetForAccountSwitch();
      RecipeImageStore.shared.resetForAccountSwitch();
      ConnectionMonitor.instance.resetForAccountSwitch();
      PaintingBinding.instance.imageCache
        ..clear()
        ..clearLiveImages();
      await _clearNativeSurfaces();
      final prefs = await SharedPreferences.getInstance();
      // Verworfene Schreibzugriffe stehen evtl. noch in der In-Memory-Kopie.
      await prefs.reload();
      AccountScope.unfreeze();
      // Das Protokoll enthält Adressen/Antworten des vorigen Kontos — es
      // landet sonst im Support-Mail-Anhang des nächsten.
      final blocked = AccountScope.blockedWrites;
      LogManager.shared.clear();
      LogManager.shared.log('👤 Kontowechsel abgeschlossen '
          '(verworfene Schreibzugriffe: $blocked)');
    }
  }

  /// Home-Widgets, Uhr und Geofences zeigen sonst bis zum ersten Push des
  /// neuen Kontos die Daten des alten.
  static Future<void> _clearNativeSurfaces() async {
    await WidgetBridge.saveServerAccess(null);
    await WidgetBridge.saveShopping(const []);
    await WidgetBridge.saveMealplan(const []);
    await WidgetBridge.saveDaily(const []);
    await WidgetBridge.reload();
    await WatchBridge.clearShopping();
    await WatchBridge.clearCookingMode();
    await ShoppingReminderBridge.setLocations(const []);
    // Google-Anmeldung des Aufgaben-Imports gehört zur Person, nicht zum
    // Gerät — sonst könnte das nächste Konto die Google Tasks des vorigen
    // importieren.
    if (PlatformFeatures.taskImport) {
      try {
        await GoogleTasksImportService.signOut();
      } catch (_) {}
    }
  }
}
