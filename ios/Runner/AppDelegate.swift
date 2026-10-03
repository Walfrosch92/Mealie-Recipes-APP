import CoreLocation
import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  // Cold-Start-Deep-Link. Unter dem Implicit-Engine-Pattern registrieren sich
  // die Flutter-Plugins erst in didInitializeImplicitFlutterEngine — also NACH
  // didFinishLaunchingWithOptions. Die Launch-URL (Widget-Tap aus geschlossener
  // App) in launchOptions[.url] ist für app_links damit verloren →
  // getInitialLink() liefert null → erste Weiterleitung schlug fehl. Wir merken
  // sie uns hier nativ und geben sie über den `mealie/deeplink`-Kanal an Dart.
  private var pendingLaunchURL: URL?
  // Referenz auf den `mealie/deeplink`-Kanal, damit warme Widget-Taps (die bei
  // aktivem UIScene NUR über den SceneDelegate ankommen) aktiv an Dart gepusht
  // werden können statt nur passiv über getInitialLink abgeholt zu werden.
  private var deepLinkChannel: FlutterMethodChannel?

  // Warmer Tap (App lief schon, vom SceneDelegate.openURLContexts aufgerufen):
  // aktiv an Dart pushen. pendingLaunchURL als Fallback, falls der Dart-Handler
  // im seltenen Race noch nicht hängt.
  func deliverDeepLink(_ url: URL) {
    pendingLaunchURL = url
    deepLinkChannel?.invokeMethod("onDeepLink", arguments: url.absoluteString)
  }

  // Cold-Start (vom SceneDelegate.willConnectTo aufgerufen, BEVOR die Engine
  // steht): URL nur merken — kein Channel-Push, der Kanal existiert erst nach
  // didInitializeImplicitFlutterEngine. Dart fragt sie per getInitialLink ab.
  func stashColdStartURL(_ url: URL) {
    pendingLaunchURL = url
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Cold-Start-URL festhalten, BEVOR irgendetwas anderes läuft.
    if let url = launchOptions?[.url] as? URL {
      pendingLaunchURL = url
    }

    // One-shot Migration von der bisherigen Swift-Version dieser App. Muss
    // VOR `super.application(...)` laufen, weil dadurch das Flutter-Engine
    // hochgefahren wird und shared_preferences die `flutter.*`-Keys liest.
    Self.runLegacySwiftToFlutterMigrationIfNeeded()
    Self.excludeLocalStoresFromBackup()

    // CloudKit-Bridge: Remote-Notification-Registrierung VOR
    // `super.application(...)` damit das System die APN-Token-Round-Trip
    // möglichst früh starten kann. Der eigentliche MethodChannel-Setup
    // läuft in didInitializeImplicitFlutterEngine, weil dort erst der
    // Flutter-BinaryMessenger verfügbar ist.
    UNUserNotificationCenter.current().delegate = self
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    application.registerForRemoteNotifications()

    // "Erinnere mich zum Einkaufen" (Issue #29): der CLLocationManager-Delegate
    // muss VOR allem anderen stehen, falls dieser Start selbst durch einen
    // Geofence-Eintritt ausgelöst wurde (launchOptions[.location]) — iOS
    // liefert den didEnterRegion-Callback kurz nach dem Start, unabhängig
    // davon ob die Flutter-Engine schon steht.
    ShoppingReminderManager.shared.start()

    // SendTo: Gerät bei jedem Launch in der iCloud-KV-Registry eintragen
    // (1:1 zu Swifts RecipeSendService.init()). Sonst ist ein Gerät, das die
    // Send-Sheet noch nie geöffnet hat, für andere Apple-ID-Geräte unsichtbar.
    CloudKitBridge.shared.registerAtLaunch()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Auch den (selteneren) Fall abdecken, dass iOS die Cold-Launch-URL erst per
  // open: nachreicht statt über launchOptions. super-Aufruf leitet weiterhin an
  // alle Plugins (inkl. app_links) weiter — Warm-Taps laufen unverändert.
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    pendingLaunchURL = url
    return super.application(app, open: url, options: options)
  }

  // HINWEIS Cold-Start-Deep-Link (Widget-Tap aus geschlossener App): Bei aktivem
  // UIScene-Lifecycle kommt die Launch-URL über
  // `SceneDelegate.scene(_:willConnectTo:)` (connectionOptions.urlContexts)
  // herein → `stashColdStartURL` → Dart holt sie per getInitialLink ab. Der
  // SceneDelegate ruft im Cold-Start-Fall bewusst KEIN `super` auf, damit die
  // URL nicht während der Engine-Init an app_links weitergereicht wird und die
  // Engine crasht (TaskRunners::GetUITaskRunner, flutter#183586). Details im
  // SceneDelegate-Header.

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    // Custom platform channel for Apple Reminders import (shopping list).
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "RemindersPlugin") {
      RemindersPlugin.register(with: registrar)
    }
    // Live Activity (cooking-timer) control — iOS 16.1+, no-op on older.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "LiveActivityManager") {
      LiveActivityManager.register(with: registrar)
    }
    // Keep-screen-on (replaces wakelock_plus pod).
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "WakeLockPlugin") {
      WakeLockPlugin.register(with: registrar)
    }
    // CloudKit-Bridge für die SendTo-Persistenz-Lieferung (iOS-only). Nutzt
    // einen eigenen Plugin-Registrar damit die Channels im selben
    // BinaryMessenger landen wie alle anderen Implicit-Engine-Plugins.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "CloudKitBridge") {
      CloudKitBridge.register(with: registrar)
    }
    // WidgetBridge — Flutter→Widget-Datenfluss (App-Group UserDefaults +
    // WidgetCenter.reloadTimelines). MealplanWidget/ShoppingListWidget/
    // DailyRecipeWidget lesen die geschriebenen Keys über
    // WidgetSharedStore in der Widget-Extension.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "WidgetBridge") {
      WidgetBridge.register(with: registrar)
    }
    // WatchBridge — Flutter→Apple-Watch-Datenfluss (laufender Timer + offene
    // Einkaufslisten-Artikel) per WatchConnectivity. Pendant zur Android-
    // WearBridge. Nimmt auch die Timer-Steueraktionen der Uhr entgegen.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "WatchBridge") {
      WatchBridge.register(with: registrar)
    }
    // ShoppingReminderBridge — Flutter→ShoppingReminderManager-Datenfluss
    // (Issue #29 "Erinnere mich zum Einkaufen"): registriert/entfernt die
    // echten CLCircularRegion-Geofences für die gespeicherten Standorte.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "ShoppingReminderBridge") {
      ShoppingReminderBridge.register(with: registrar)
    }
    // Alternate-App-Icon-Bridge (iOS-only). Inline statt eigener Plugin-Datei,
    // damit keine pbxproj-Anpassung nötig ist. Spiegelt die Swift-Vorgänger-
    // App (UIApplication.setAlternateIconName). Kanal `mealie/appicon`:
    //   • supportsAlternateIcons -> Bool
    //   • getAlternateIconName   -> String?  (nil = primäres Icon "Classic")
    //   • setAlternateIcon({name}) -> nil    (name nil/"" = primäres Icon)
    // Cold-Start-Deep-Link an Dart liefern (siehe pendingLaunchURL). Dart
    // fragt das beim Start ab — fängt den Launch-Link ab, den app_links unter
    // dem Implicit-Engine-Pattern verpasst.
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "DeepLinkBridge") {
      let channel = FlutterMethodChannel(
        name: "mealie/deeplink", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { [weak self] call, result in
        if call.method == "getInitialLink" {
          result(self?.pendingLaunchURL?.absoluteString)
        } else {
          result(FlutterMethodNotImplemented)
        }
      }
      // Für native→Dart-Push warmer Widget-Taps (siehe deliverDeepLink).
      deepLinkChannel = channel
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "AppIconBridge") {
      let channel = FlutterMethodChannel(
        name: "mealie/appicon", binaryMessenger: registrar.messenger())
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "supportsAlternateIcons":
          result(UIApplication.shared.supportsAlternateIcons)
        case "getAlternateIconName":
          result(UIApplication.shared.alternateIconName)
        case "setAlternateIcon":
          guard UIApplication.shared.supportsAlternateIcons else {
            result(FlutterError(code: "UNSUPPORTED",
                                message: "Alternate icons not supported",
                                details: nil))
            return
          }
          let args = call.arguments as? [String: Any]
          let raw = args?["name"] as? String
          let name = (raw == nil || raw!.isEmpty) ? nil : raw
          // setAlternateIconName MUSS auf dem Main-Thread laufen.
          DispatchQueue.main.async {
            UIApplication.shared.setAlternateIconName(name) { error in
              if let error = error {
                result(FlutterError(code: "SET_FAILED",
                                    message: error.localizedDescription,
                                    details: nil))
              } else {
                result(nil)
              }
            }
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
  }

  // MARK: - Shopping-Reminder-Notification-Tap (Issue #29)
  //
  // ShoppingReminderManager feuert seine Benachrichtigung KOMPLETT NATIV
  // (UNUserNotificationCenter.add, nicht über flutter_local_notifications) —
  // funktioniert dadurch auch ohne laufende Flutter-Engine. Für den TAP
  // reicht deshalb kein Dart-Payload-Mechanismus; wir erkennen die eigene
  // Notification hier am Identifier-Präfix und leiten sie über denselben
  // `deliverDeepLink`-Mechanismus wie einen Widget-Tap weiter (deckt sowohl
  // Kaltstart — pendingLaunchURL, von Dart per getInitialLink abgeholt — als
  // auch einen warmen Tap ab). Für alles andere (Timer-Notifications etc.)
  // bleibt der ererbte FlutterAppDelegate-Pfad (Plugin-Forwarding) über
  // `super` erhalten — NICHT weglassen, sonst bricht das.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    if response.notification.request.identifier.hasPrefix(ShoppingReminderManager.notificationIdentifierPrefix) {
      deliverDeepLink(URL(string: "mealierecipes://shopping")!)
      completionHandler()
      return
    }
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  // Banner + Ton auch zeigen, wenn die App gerade im Vordergrund ist (z. B.
  // beim Betreten eines Geschäfts während man die App offen hat) — sonst
  // würde iOS die Notification standardmäßig lautlos verschlucken.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if notification.request.identifier.hasPrefix(ShoppingReminderManager.notificationIdentifierPrefix) {
      completionHandler([.banner, .sound])
      return
    }
    super.userNotificationCenter(center, willPresent: notification, withCompletionHandler: completionHandler)
  }

  // MARK: - Remote Notifications (CloudKit Silent-Push)

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    // CloudKit-Push erkennen am `ck`-Key. Andere Pushes (heute keine —
    // Plattz für künftige Notification-Use-Cases) durchreichen.
    if userInfo["ck"] != nil {
      CloudKitBridge.shared.handlePush(userInfo: userInfo)
      completionHandler(.newData)
      return
    }
    completionHandler(.noData)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("[AppDelegate] remote notification registration failed: \(error.localizedDescription)")
  }

  // MARK: - Legacy Swift → Flutter Migration
  //
  // Liest einmalig die UserDefaults-Keys + den ShoppingListCache der Swift-
  // Vorgängerversion und schreibt sie unter Flutters `flutter.*`-Schema neu.
  // Damit bleiben Login (Server-URL + Token), Settings, Pending-Changes und
  // die Shopping-Liste nach dem Update von Swift → Flutter erhalten —
  // bestehende User landen NICHT in der Setup-View.
  //
  // Lauft genau einmal: gesetzt wird `flutter.legacy_swift_migration_done`.
  // Bei Fehlern (z. B. fehlende Cache-Datei) bleibt der Flag offen damit ein
  // Retry beim nächsten Start möglich ist.
  private static let migrationFlagKey = "flutter.legacy_swift_migration_done"

  private static func runLegacySwiftToFlutterMigrationIfNeeded() {
    let d = UserDefaults.standard
    guard !d.bool(forKey: migrationFlagKey) else { return }

    // 1) Umbenennungen: Swift-Key → Flutter-Key (alle Strings).
    let renames: [(String, String)] = [
      ("serverURL", "flutter.serverUrl"),
      ("token", "flutter.apiToken"),
      ("mealieAPIVersion", "flutter.apiVersion"),
      // SendTo: ohne diese Übernahme registriert sich dasselbe iPhone
      // einmal als Swift-UUID (Legacy) und einmal als Flutter-UUID in
      // der iCloud-KV-Device-Registry — Doppel-Eintrag in der Sheet.
      ("recipeSendDeviceId", "flutter.recipe_send_device_id"),
    ]
    for (src, dst) in renames {
      if let v = d.string(forKey: src), d.string(forKey: dst) == nil {
        d.set(v, forKey: dst)
      }
    }

    // 2) Keys mit identischem Namen, nur Prefix `flutter.` davor.
    //    String-Werte:
    let sameStringKeys = ["householdId", "shoppingListId", "selectedLanguage"]
    for key in sameStringKeys {
      if let v = d.string(forKey: key), d.string(forKey: "flutter.\(key)") == nil {
        d.set(v, forKey: "flutter.\(key)")
      }
    }

    //    Bool-Werte (nur migrieren wenn der Key existiert — sonst würde
    //    `false` als „explizit deaktiviert" interpretiert):
    let boolKeys = [
      "isBiometricLockEnabled", "enableCriticalAlerts",
      "showRecipeImages", "enableLogging", "isGuestMode",
    ]
    for key in boolKeys {
      if d.object(forKey: key) != nil && d.object(forKey: "flutter.\(key)") == nil {
        d.set(d.bool(forKey: key), forKey: "flutter.\(key)")
      }
    }

    //    String-Array (collapsed shopping categories):
    if let arr = d.stringArray(forKey: "collapsedShoppingCategories"),
       d.object(forKey: "flutter.collapsedShoppingCategories") == nil {
      d.set(arr, forKey: "flutter.collapsedShoppingCategories")
    }

    // 3) Pending Changes: Swift schreibt JSON als NSData via JSONEncoder,
    //    Flutter erwartet einen JSON-String. Konvertieren.
    let pendingKeys = [
      "pendingCheckChanges", "pendingQuantityChanges",
      "pendingDeleteChanges", "pendingAddChanges",
      "pendingCategoryChanges",
    ]
    for key in pendingKeys {
      if let data = d.data(forKey: key),
         let json = String(data: data, encoding: .utf8),
         d.string(forKey: "flutter.\(key)") == nil {
        d.set(json, forKey: "flutter.\(key)")
      }
    }

    // 4) ShoppingListCache.json (documentDirectory) → flutter.cache_shopping_items
    //    Swift speichert das als File (atomicWrite), Flutter erwartet einen
    //    JSON-String unter dem SharedPreferences-Key `cache_shopping_items`.
    if d.string(forKey: "flutter.cache_shopping_items") == nil,
       let docDir = FileManager.default.urls(
        for: .documentDirectory, in: .userDomainMask).first {
      let url = docDir.appendingPathComponent("shoppingListCache.json")
      if let raw = try? Data(contentsOf: url),
         let json = String(data: raw, encoding: .utf8) {
        d.set(json, forKey: "flutter.cache_shopping_items")
      }
    }

    // 5) Recipe-Detail-Cache (`Library/Caches/<bundle_id>/MealieCache/
    //    recipeCache.json`): Flutters `RecipeDetailCacheManager` verschiebt
    //    die Datei beim ersten Zugriff selbst nach Application Support
    //    (identisches JSON-Format {"recipes":[...]}) — hier nichts zu tun.

    d.set(true, forKey: migrationFlagKey)
  }

  /// Rezept-Cache (`Library/Application Support/MealieCache/`, siehe
  /// RecipeDetailCacheManager) und Offline-Rezeptbilder (`MealieImages/`,
  /// siehe RecipeImageStore) liegen bewusst NICHT in `Library/Caches`, weil
  /// iOS den Ordner bei Speicherknappheit leert. Application Support landet
  /// aber im iCloud-Backup, für jederzeit neu ladbare Daten (bei vielen
  /// Rezepten mehrere hundert MB) falsch (Apple Data Storage Guidelines).
  /// Das Flag auf dem ORDNER gilt für seinen gesamten Inhalt, also auch für
  /// per atomarem rename neu geschriebene Dateien. Die Ordner deshalb hier
  /// schon anlegen, bevor Dart die erste Datei hineinschreibt.
  private static func excludeLocalStoresFromBackup() {
    guard let support = FileManager.default.urls(
      for: .applicationSupportDirectory, in: .userDomainMask).first
    else { return }
    for name in ["MealieCache", "MealieImages"] {
      var dir = support.appendingPathComponent(name, isDirectory: true)
      do {
        try FileManager.default.createDirectory(
          at: dir, withIntermediateDirectories: true)
        var values = URLResourceValues()
        values.isExcludedFromBackup = true
        try dir.setResourceValues(values)
      } catch {
        NSLog("\(name): Backup-Ausschluss fehlgeschlagen: \(error)")
      }
    }
  }
}
