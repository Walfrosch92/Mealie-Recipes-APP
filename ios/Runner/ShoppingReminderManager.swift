import CoreLocation
import Foundation
import Security
import UIKit
import UserNotifications

// ----------------------------------------------------------------------------
// ShoppingReminderManager — "Erinnere mich zum Einkaufen" (Issue #29).
// Registriert echte CLCircularRegion-Geofences (100 m) für bis zu 3
// gespeicherte Standorte und feuert bei Betreten NATIV eine lokale
// Benachrichtigung — komplett unabhängig von einer laufenden Flutter-Engine,
// funktioniert daher auch bei komplett beendeter App (iOS startet die App im
// Hintergrund neu, sobald eine überwachte Region betreten wird — solange der
// Nutzer sie nicht per App-Switcher manuell beendet hat, das ist eine
// System-Grenze ohne Workaround).
//
// Liest den "hat die Liste offene Artikel"-Zustand direkt aus der
// App-Group-UserDefaults, die WidgetBridge.swift ohnehin bei jeder
// Listenänderung aktuell hält (`widgetShoppingList`) — kein zusätzlicher
// Push-Pfad von Dart nötig. Sprache kommt aus derselben Quelle
// (`widgetLanguage`, von WidgetBridge.saveLanguage gepflegt).
// ----------------------------------------------------------------------------

final class ShoppingReminderManager: NSObject, CLLocationManagerDelegate {
    static let shared = ShoppingReminderManager()

    private static let appGroupID = "group.Walfrosch92.MealieRecipes"
    private static let kShopping = "widgetShoppingList"
    private static let kLanguage = "widgetLanguage"
    private static let kLocations = "shoppingReminderLocations"
    private static let kLastNotifiedAt = "shoppingReminderLastNotifiedAt"
    // 500 m (User-Wunsch 2026-10-02, vorher 100 m): iOS erkennt Regionen per
    // WLAN/Mobilfunk — kleine Radien lösen spät oder gar nicht aus (~10 min
    // Verzögerung beobachtet). 500 m löst schon bei der Annäherung aus.
    private static let radiusMeters: CLLocationDistance = 500
    // Sperrzeit PRO STANDORT (User-Wunsch 2026-10-02): derselbe Standort
    // erinnert höchstens einmal pro Stunde, verschiedene Standorte
    // unabhängig voneinander. Schlüssel: kLastNotifiedAt + "_" + Region-ID.
    private static let cooldownSeconds: TimeInterval = 60 * 60

    /// Präfix der Notification-Identifier — AppDelegate erkennt daran seine
    /// eigenen Geofence-Benachrichtigungen beim Tap (siehe
    /// `userNotificationCenter(_:didReceive:)`).
    static let notificationIdentifierPrefix = "shopping_reminder_"

    private let locationManager = CLLocationManager()

    private struct StoredLocation: Codable {
        let id: String
        let name: String
        let lat: Double
        let lng: Double
    }

    private struct ShoppingItemChecked: Decodable {
        let checked: Bool
    }

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    private override init() {
        super.init()
        locationManager.delegate = self
    }

    /// Früh bei JEDEM App-Start aufrufen (App-Delegate, vor `super.application`)
    /// — der Delegate muss bereitstehen, BEVOR iOS einen möglichen
    /// `didEnterRegion`-Callback direkt nach einem Geofence-ausgelösten
    /// Kaltstart zustellt. Registriert zusätzlich die zuletzt bekannten
    /// Standorte neu (idempotent) — reine Vorsichtsmaßnahme, iOS persistiert
    /// überwachte Regionen normalerweise selbst über Neustarts hinweg.
    func start() {
        let stored = loadStoredLocations()
        if !stored.isEmpty {
            configureRegions(stored)
        }
    }

    /// Ersetzt ALLE überwachten Regionen durch [locations] (leere Liste =
    /// Funktion aus). Aufgerufen von ShoppingReminderBridge (Flutter-Push)
    /// UND von `start()` (Neu-Registrierung bei App-Start).
    func configureRegions(_ locations: [[String: Any]]) {
        let parsed = locations.compactMap { dict -> StoredLocation? in
            guard let id = dict["id"] as? String,
                  let name = dict["name"] as? String,
                  let lat = (dict["lat"] as? NSNumber)?.doubleValue,
                  let lng = (dict["lng"] as? NSNumber)?.doubleValue else { return nil }
            return StoredLocation(id: id, name: name, lat: lat, lng: lng)
        }
        configureRegions(parsed)
    }

    /// Regionen, für die ein „schon drin?"-Check läuft (nur NEUE Standorte).
    private var initialStateChecks = Set<String>()

    private func configureRegions(_ locations: [StoredLocation]) {
        // Nur NEU hinzugefügte Standorte sofort prüfen (Standort direkt im
        // Laden gespeichert). Beim bloßen Neu-Registrieren (jeder App-Start)
        // nicht — bei 500 m liegt oft die eigene Wohnung in der Zone eines
        // nahen Ladens, sonst käme bei jedem App-Start eine Erinnerung.
        let knownIds = Set(loadStoredLocations().map { $0.id })
        saveStoredLocations(locations)
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else { return }
        for loc in locations {
            let region = CLCircularRegion(
                center: CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng),
                radius: Self.radiusMeters,
                identifier: loc.id
            )
            region.notifyOnEntry = true
            region.notifyOnExit = false
            locationManager.startMonitoring(for: region)
            // Feuert sofort, wenn der Nutzer BEREITS innerhalb des Radius ist
            // (z. B. "aktuellen Standort verwenden" direkt im Laden gespeichert)
            // — mirrors Androids GeofencingRequest.INITIAL_TRIGGER_ENTER, das
            // CLLocationManager nicht automatisch nachbildet.
            if !knownIds.contains(loc.id) {
                initialStateChecks.insert(loc.id)
                locationManager.requestState(for: region)
            }
        }
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        handleRegionEntered(region)
    }

    func locationManager(
        _ manager: CLLocationManager,
        didDetermineState state: CLRegionState,
        for region: CLRegion
    ) {
        // iOS meldet „drinnen" auch bei jedem normalen Betreten — zusätzlich zu
        // didEnterRegion. Ohne diese Einschränkung kamen doppelte
        // Erinnerungen. Daher nur unseren eigenen Erst-Check auswerten.
        guard initialStateChecks.remove(region.identifier) != nil else { return }
        if state == .inside { handleRegionEntered(region) }
    }

    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        NSLog("[ShoppingReminder] monitoring failed for \(region?.identifier ?? "?"): \(error.localizedDescription)")
    }

    private func handleRegionEntered(_ region: CLRegion) {
        // Bei geschlossener App weckt iOS uns nur kurz — Hintergrundzeit
        // sichern, um die Einkaufsliste FRISCH vom Server zu holen. Vorher
        // zählte nur der zuletzt von App/Widget gespeicherte Stand: wurde
        // seitdem in der Webapp etwas auf die Liste gesetzt, blieb die
        // Erinnerung aus. Offline/Fehler → gespeicherter Stand.
        let task = UIApplication.shared.beginBackgroundTask(withName: "ShoppingReminder")
        Task { @MainActor in
            let fresh = await self.fetchHasOpenItemsFromServer()
            self.notifyIfNeeded(region, hasOpenItems: fresh ?? self.hasOpenShoppingItems())
            if task != .invalid { UIApplication.shared.endBackgroundTask(task) }
        }
    }

    /// Offene Artikel direkt vom Server (aktive Liste). nil = nicht ermittelbar.
    /// Zugangsdaten aus dem Keychain (von der App für die Widgets abgelegt,
    /// Zugriffsgruppe = App Group).
    private func fetchHasOpenItemsFromServer() async -> Bool? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "mealie.widget.serverAccess",
            kSecAttrAccount as String: "access",
            kSecAttrAccessGroup as String: Self.appGroupID,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var out: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &out) == errSecSuccess,
              let data = out as? Data,
              let access = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let base = access["url"] as? String,
              let token = access["token"] as? String,
              let listId = access["listId"] as? String, !listId.isEmpty else { return nil }
        let trimmed = base.hasSuffix("/") ? String(base.dropLast()) : base
        guard let url = URL(string: "\(trimmed)/api/households/shopping/lists/\(listId)") else { return nil }
        var req = URLRequest(url: url, timeoutInterval: 8)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        for (k, v) in (access["headers"] as? [String: String]) ?? [:] {
            req.setValue(v, forHTTPHeaderField: k)
        }
        guard let (body, resp) = try? await URLSession.shared.data(for: req),
              (resp as? HTTPURLResponse)?.statusCode == 200,
              let list = try? JSONSerialization.jsonObject(with: body) as? [String: Any],
              let items = list["listItems"] as? [[String: Any]] else { return nil }
        return items.contains { !(($0["checked"] as? Bool) ?? false) }
    }

    private func notifyIfNeeded(_ region: CLRegion, hasOpenItems: Bool) {
        guard hasOpenItems else { return }
        // Sperrzeit pro Standort: max. 1 Benachrichtigung pro Stunde und
        // Standort, verschiedene Standorte unabhängig voneinander.
        guard canNotifyNow(region.identifier) else { return }
        guard let name = loadStoredLocations().first(where: { $0.id == region.identifier })?.name else { return }
        let lang = Self.defaults?.string(forKey: Self.kLanguage) ?? "en"

        let content = UNMutableNotificationContent()
        content.title = ShoppingReminderL10n.title(lang: lang)
        content.body = ShoppingReminderL10n.body(lang: lang, locationName: name)
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "\(Self.notificationIdentifierPrefix)\(region.identifier)_\(Int(Date().timeIntervalSince1970))",
            content: content,
            trigger: nil // sofort auslösen
        )
        UNUserNotificationCenter.current().add(request) { [weak self] error in
            if let error = error {
                NSLog("[ShoppingReminder] notification add failed: \(error.localizedDescription)")
                return
            }
            // Cooldown erst bei tatsächlichem Erfolg starten — schlägt das
            // Zustellen fehl, soll der nächste Eintritt sofort wieder
            // versuchen dürfen, statt eine Stunde stumm zu bleiben.
            self?.markNotified(region.identifier)
        }
    }

    /// true, wenn seit der letzten gezeigten Benachrichtigung >= 1h vergangen ist.
    private func canNotifyNow(_ locationId: String) -> Bool {
        let last = Self.defaults?.double(forKey: "\(Self.kLastNotifiedAt)_\(locationId)") ?? 0
        return Date().timeIntervalSince1970 - last >= Self.cooldownSeconds
    }

    private func markNotified(_ locationId: String) {
        Self.defaults?.set(Date().timeIntervalSince1970,
                           forKey: "\(Self.kLastNotifiedAt)_\(locationId)")
    }

    // MARK: - Persistenz (App-Group-UserDefaults)

    private func saveStoredLocations(_ locations: [StoredLocation]) {
        guard let data = try? JSONEncoder().encode(locations) else { return }
        Self.defaults?.set(data, forKey: Self.kLocations)
    }

    private func loadStoredLocations() -> [StoredLocation] {
        guard let data = Self.defaults?.data(forKey: Self.kLocations),
              let decoded = try? JSONDecoder().decode([StoredLocation].self, from: data) else {
            return []
        }
        return decoded
    }

    private func hasOpenShoppingItems() -> Bool {
        guard let data = Self.defaults?.data(forKey: Self.kShopping),
              let items = try? JSONDecoder().decode([ShoppingItemChecked].self, from: data) else {
            return false
        }
        return items.contains { !$0.checked }
    }
}

// ----------------------------------------------------------------------------
// ShoppingReminderL10n — mirrors android/.../shopping_reminder/ShoppingReminderL10n.kt.
// Feuert nativ ohne laufende Flutter-Engine, daher eine eigene statische
// Tabelle statt der Dart-l10n (wie schon WidgetL10n für die Home-Widgets).
// ----------------------------------------------------------------------------

enum ShoppingReminderL10n {
    // Bewusst NICHT "title"/"body" genannt (wie zunächst geschrieben) — das
    // kollidiert mit den gleichnamigen statischen Funktionen darunter. Ohne
    // eigenen Compile-Check hier lieber eindeutig benennen als riskieren.
    private static let titles: [String: String] = [
        "de": "Zeit zum Einkaufen!",
        "en": "Time to shop!",
        "es": "¡Hora de comprar!",
        "fr": "C'est l'heure des courses !",
        "hu": "Ideje bevásárolni!",
        "nl": "Tijd om te winkelen!",
        "nb": "På tide å handle!",
        "pl": "Czas na zakupy!",
        "pt": "Hora das compras!",
        "sl": "Čas za nakupovanje!",
    ]

    private static let bodies: [String: String] = [
        "de": "Du bist in der Nähe von %@ — auf deiner Einkaufsliste stehen noch offene Artikel.",
        "en": "You're near %@ — your shopping list still has open items.",
        "es": "Estás cerca de %@ — tu lista de la compra todavía tiene artículos pendientes.",
        "fr": "Vous êtes près de %@ — votre liste de courses contient encore des articles à acheter.",
        "hu": "A közelben vagy: %@ — a bevásárlólistádon még nyitott tételek vannak.",
        "nl": "Je bent in de buurt van %@ — je boodschappenlijst heeft nog openstaande items.",
        "nb": "Du er i nærheten av %@ — handlelisten din har fortsatt åpne varer.",
        "pl": "Jesteś w pobliżu %@ — Twoja lista zakupów wciąż ma niezaznaczone produkty.",
        "pt": "Você está perto de %@ — sua lista de compras ainda tem itens pendentes.",
        "sl": "V bližini si: %@ — na nakupovalnem seznamu imaš še odprte artikle.",
    ]

    static func title(lang: String) -> String {
        titles[lang] ?? titles["en"]!
    }

    static func body(lang: String, locationName: String) -> String {
        String(format: bodies[lang] ?? bodies["en"]!, locationName)
    }
}
