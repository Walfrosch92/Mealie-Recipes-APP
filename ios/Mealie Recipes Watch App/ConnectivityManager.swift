import Combine
import Foundation
import UserNotifications
import WatchConnectivity
import WatchKit

// ----------------------------------------------------------------------------
// ConnectivityManager — watchOS-Seite der WatchConnectivity-Brücke.
//
// Empfängt den vom iPhone gespiegelten Zustand (laufende/pausierte Timer,
// Kochmodus-Navigationszustand, offene Einkaufslisten-Artikel, App-Sprache)
// über `WCSession.applicationContext` und schickt Steueraktionen (Timer
// pause/resume/stop, Kochschritt vor/zurück, Einkaufsliste abhaken) zurück.
// Gegenstück zur iOS-Seite `ios/Runner/WatchBridge.swift`. Übersetzungen der
// statischen UI-Texte: siehe WatchL10n.
// ----------------------------------------------------------------------------

struct WatchShoppingItem: Identifiable, Equatable {
    let id: String
    let text: String
    let category: String
    /// 6-stelliger Hex (RRGGBB) der Kategorie-Farbe, vom iPhone aufgelöst
    /// (1:1 zu `shoppingCategoryColor` der Phone-App).
    let categoryColor: String
    let checked: Bool
}

struct WatchTimer: Equatable, Identifiable {
    let id: Int
    let name: String
    let recipeName: String
    let endMillis: Double
    let remainingSeconds: Int
    let totalSeconds: Int
    let isPaused: Bool

    /// Aktuell verbleibende Sekunden — läuft (nicht pausiert) aus endMillis.
    func liveRemaining(_ now: Date = Date()) -> Int {
        if isPaused { return remainingSeconds }
        let secs = Int(endMillis / 1000.0 - now.timeIntervalSince1970)
        return max(0, secs)
    }

    func displayTime(_ now: Date = Date()) -> String {
        let r = liveRemaining(now)
        return String(format: "%02d:%02d", r / 60, r % 60)
    }
}

/// Kochmodus-Navigationszustand — Pendant zum Dart `CookingSessionsNotifier`.
/// `active == false` (Default) → die Uhr zeigt die Einkaufsliste.
struct WatchCookingState: Equatable {
    var active: Bool = false
    var canBack: Bool = false
    var canNext: Bool = false
}

final class ConnectivityManager: NSObject, ObservableObject {
    static let shared = ConnectivityManager()

    @Published var timers: [WatchTimer] = []
    @Published var cooking = WatchCookingState()
    @Published var shopping: [WatchShoppingItem] = []
    /// Von der Phone-App gewählte Sprache (siehe WatchL10n) — unabhängig von
    /// der Systemsprache der Uhr. „de" als Default, solange noch kein Sync
    /// stattgefunden hat (deckt sich mit dem bisherigen, fest deutschen Text).
    @Published var language: String = "de"

    // Lokale Timer-Notifications der Uhr — der ZUVERLÄSSIGE Alarmpfad. Die Uhr
    // plant sie selbst zum Endzeitpunkt (EINE pro laufendem Timer, per id
    // identifiziert), damit sie auch dann läuten, wenn das iPhone gesperrt/
    // suspended ist (dann sendet das Phone kein `timerFinished`-Live-Event
    // mehr) oder die Watch-App nicht im Vordergrund ist.
    private static func timerNotifId(_ id: Int) -> String { "mealie_watch_timer_\(id)" }

    /// Max. tolerierte Abweichung zwischen gesendetem `endDateMillis` und der
    /// lokal berechneten Endzeit. Innerhalb davon gilt die Differenz als
    /// Zustellverzögerung (applicationContext/transferUserInfo sind
    /// Store-and-Forward!) → absolute Endzeit verwenden. Darüber sind die
    /// Uhren grob verstellt (Simulator) → lokale Berechnung als Fallback.
    private static let clockSkewToleranceMs: Double = 30 * 60 * 1000

    private var notificationsAuthorized = false
    /// Stabiler Schlüssel (id + absoluter Endzeitpunkt) je aktuell geplanter
    /// Notification-id — verhindert das Neu-Planen bei jedem Sekunden-Push.
    private var scheduledKeys: [String: String] = [:]

    func activate() {
        // Notification-Berechtigung anfragen + Delegate setzen (für Vordergrund-
        // Darstellung). Bei Erfolg einen evtl. schon bekannten Timer planen.
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { [weak self] granted, _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.notificationsAuthorized = granted
                self.syncNotifications(for: self.timers)
            }
        }

        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    // MARK: - Lokale Notification (Watch-eigener Alarm)

    /// Plant/cancelt je laufendem Timer eine eigene lokale Notification
    /// (identifiziert per `timerNotifId(id)`), passend zum aktuellen Zustand.
    /// Läuft idempotent: bei unverändertem Endzeitpunkt No-op (die
    /// Sekunden-Pushes des iPhones triggern apply() im Sekundentakt). Timer,
    /// die nicht mehr in `list` vorkommen oder pausiert sind, verlieren ihren
    /// geplanten (noch nicht gefeuerten) Alarm.
    private func syncNotifications(for list: [WatchTimer]) {
        guard notificationsAuthorized else { return }
        let center = UNUserNotificationCenter.current()

        let runningIds = Set(list.filter { !$0.isPaused }.map(\.id))
        // Für jeden nicht mehr laufenden (pausiert/entfernt) Timer den evtl.
        // geplanten Alarm entfernen. NUR pending — eine bereits ZUGESTELLTE
        // Banner-Notification bleibt absichtlich liegen und erinnert weiter,
        // bis sie entweder auf der Uhr angetippt ODER am Handy quittiert wird
        // (grüner Chip / Kochmodus beenden → `timerAck`-Event, siehe handleEvent).
        for (key, _) in scheduledKeys where !runningIds.contains(Self.idFromKey(key)) {
            center.removePendingNotificationRequests(withIdentifiers: [key])
            scheduledKeys.removeValue(forKey: key)
        }

        for t in list where !t.isPaused {
            let remaining = t.liveRemaining()
            guard remaining > 0 else { continue }
            let notifId = Self.timerNotifId(t.id)

            // Absoluter Endzeitpunkt als stabiler Key: now + remaining bleibt bei
            // den Sekunden-Pushes konstant (now +1, remaining -1) → wird nur
            // einmal geplant. Bei Resume mit neuem Endzeitpunkt ändert sich der
            // Key → reschedule.
            let endSecond = Int(Date().timeIntervalSince1970) + remaining
            let key = "\(t.id)-\(endSecond)"
            if scheduledKeys[notifId] == key { continue }
            scheduledKeys[notifId] = key

            let content = UNMutableNotificationContent()
            content.title = t.name
            content.body = t.recipeName
            // watchOS unterstützt keine Custom-Notification-Sounds
            // (UNNotificationSound(named:) ist dort unavailable). Der
            // Standard-Ton plus die system-eigene Notification-Haptik genügen
            // als Alarm auf der Uhr.
            content.sound = .default
            if #available(watchOS 9.0, *) {
                content.interruptionLevel = .timeSensitive
            }
            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: TimeInterval(remaining), repeats: false)
            let req = UNNotificationRequest(
                identifier: notifId, content: content, trigger: trigger)
            center.removePendingNotificationRequests(withIdentifiers: [notifId])
            center.add(req)
        }
    }

    /// Extrahiert die Timer-id aus einem `scheduledKeys`-Schlüssel (Format
    /// `mealie_watch_timer_<id>`) — Hilfsfunktion für den Aufräumschritt oben.
    private static func idFromKey(_ notifId: String) -> Int {
        Int(notifId.replacingOccurrences(of: "mealie_watch_timer_", with: "")) ?? -1
    }

    // MARK: - Senden (Uhr → iPhone)

    func sendAction(_ action: String, id: Int) {
        send(["action": action, "id": id])
    }

    /// Kochschritt vor/zurück (`"next"`/`"previous"`).
    func sendStepAction(_ action: String) {
        send(["cookingAction": action])
    }

    /// Einkaufslisten-Artikel ab-/anhaken (synct über das iPhone zum Server).
    func sendShoppingToggle(_ itemId: String) {
        send(["shoppingAction": "toggle", "itemId": itemId])
    }

    private func send(_ payload: [String: Any]) {
        let session = WCSession.default
        if session.isReachable {
            session.sendMessage(payload, replyHandler: nil) { _ in
                // Fallback, falls sendMessage scheitert → garantierte Zustellung.
                session.transferUserInfo(payload)
            }
        } else {
            session.transferUserInfo(payload)
        }
    }

    // MARK: - Parsen

    private func apply(context: [String: Any]) {
        // Timer — JSON-Array, ein Eintrag pro laufendem/pausiertem Timer.
        if let json = context["timers"] as? String,
           let data = json.data(using: .utf8),
           let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            self.timers = arr.map { t in
                let remaining = (t["remainingSeconds"] as? NSNumber)?.intValue ?? 0
                // Endzeit: bevorzugt das vom iPhone gesendete absolute endDateMillis.
                // applicationContext/transferUserInfo sind Store-and-Forward — war
                // die Uhr beim Timer-Start nicht erreichbar, ist remainingSeconds
                // beim Eintreffen bereits veraltet und `now + remaining` läge um die
                // Zustellverzögerung daneben (Countdown zu lang, lokale Alarm-
                // Notification zu spät). Nur bei grob differierenden Uhren
                // (> Toleranz, z.B. Simulator) fällt die Berechnung auf die
                // Watch-eigene Zeitbasis zurück.
                let localEnd = Date().timeIntervalSince1970 * 1000 + Double(remaining) * 1000
                let sentEnd = (t["endDateMillis"] as? NSNumber)?.doubleValue ?? 0
                let endMillis = (sentEnd > 0 && abs(sentEnd - localEnd) <= Self.clockSkewToleranceMs)
                    ? sentEnd : localEnd
                return WatchTimer(
                    id: (t["id"] as? NSNumber)?.intValue ?? -1,
                    name: t["timerName"] as? String ?? "Timer",
                    recipeName: t["recipeName"] as? String ?? "",
                    endMillis: endMillis,
                    remainingSeconds: remaining,
                    totalSeconds: (t["totalSeconds"] as? NSNumber)?.intValue ?? 0,
                    isPaused: (t["isPaused"] as? NSNumber)?.boolValue ?? false
                )
            }
        } else if context["timers"] != nil {
            self.timers = []
        }
        // Lokale Notifications an den neuen Timer-Zustand anpassen (planen beim
        // Start, canceln bei Pause/Stop). Macht die Uhr unabhängig davon, ob das
        // iPhone gerade ein Live-Event schicken kann.
        syncNotifications(for: self.timers)

        // Kochmodus-Navigationszustand (fehlt der Key → kein Kochmodus aktiv,
        // die Uhr zeigt dann die Einkaufsliste).
        if let c = context["cooking"] as? [String: Any] {
            self.cooking = WatchCookingState(
                active: (c["active"] as? NSNumber)?.boolValue ?? true,
                canBack: (c["canBack"] as? NSNumber)?.boolValue ?? false,
                canNext: (c["canNext"] as? NSNumber)?.boolValue ?? false
            )
        } else {
            self.cooking = WatchCookingState()
        }

        // App-Sprache (siehe WatchL10n) — fehlt der Key (z.B. sehr alte Phone-
        // App-Version), bleibt die zuletzt bekannte Sprache unverändert.
        if let lang = context["lang"] as? String {
            self.language = lang
        }

        // Einkaufsliste (JSON-String von [{"id","text","category","checked"}]).
        if let json = context["shopping"] as? String,
           let data = json.data(using: .utf8),
           let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
            self.shopping = arr.compactMap { o in
                let text = ((o["text"] as? String) ?? (o["name"] as? String) ?? "")
                    .trimmingCharacters(in: .whitespaces)
                guard !text.isEmpty else { return nil }
                return WatchShoppingItem(
                    id: o["id"] as? String ?? "",
                    text: text,
                    category: o["category"] as? String ?? "",
                    categoryColor: o["categoryColor"] as? String ?? "",
                    checked: o["checked"] as? Bool ?? false
                )
            }
        } else if context["shopping"] != nil {
            self.shopping = []
        }
    }
}

extension ConnectivityManager: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        // Beim Start den zuletzt gespiegelten Zustand übernehmen.
        let ctx = session.receivedApplicationContext
        if !ctx.isEmpty {
            DispatchQueue.main.async { self.apply(context: ctx) }
        }
    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        DispatchQueue.main.async { self.apply(context: applicationContext) }
    }

    // Vom iPhone kommen per sendMessage ZWEI Arten:
    //   • Sofort-State (timers/cooking/shopping/updatedAt) — wenn die App
    //     offen ist, damit Änderungen (z.B. Menge 1→2) ohne
    //     applicationContext-Verzögerung sofort ankommen.
    //   • Einmal-Events (z.B. {timerFinished:true}) → läuten/vibrieren.
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if message["updatedAt"] != nil || message["shopping"] != nil
            || message["timers"] != nil || message["cooking"] != nil {
            DispatchQueue.main.async { self.apply(context: message) }
        } else {
            handleEvent(message)
        }
    }

    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        // Wie didReceiveMessage: State (timers/cooking/shopping/updatedAt)
        // anwenden, sonst als Event behandeln. transferUserInfo liefert State
        // zuverlässig, wenn die Uhr beim Senden nicht erreichbar war (Display aus).
        if userInfo["updatedAt"] != nil || userInfo["shopping"] != nil
            || userInfo["timers"] != nil || userInfo["cooking"] != nil {
            DispatchQueue.main.async { self.apply(context: userInfo) }
        } else {
            handleEvent(userInfo)
        }
    }

    private func handleEvent(_ msg: [String: Any]) {
        // Quittierung vom Handy (grüner Chip / „Kochmodus beenden"): die bereits
        // ZUGESTELLTEN „Timer fertig"-Banner GENAU dieser ids aus dem
        // Notification Center der Uhr entfernen. Bewusst NUR delivered UND NUR
        // diese ids — ein evtl. weiterer, noch laufender Timer bleibt erhalten
        // und läutet bei seinem Ablauf ganz normal.
        if let idsRaw = msg["timerAck"] as? [Any] {
            let ids = idsRaw.compactMap { ($0 as? NSNumber)?.intValue }
            let notifIds = ids.map { Self.timerNotifId($0) }
            UNUserNotificationCenter.current()
                .removeDeliveredNotifications(withIdentifiers: notifIds)
            return
        }
        if msg["timerFinished"] != nil {
            // Der zuverlässige Alarm ist die selbst geplante lokale Notification
            // (feuert auch bei gesperrtem iPhone / Watch-App im Hintergrund).
            // Das Live-Event ist nur Fallback, wenn keine Notification-Berechtigung
            // vorliegt — sonst würde es den Alarm doppeln.
            guard !notificationsAuthorized else { return }
            DispatchQueue.main.async { self.fireTimerAlarm() }
        }
    }

    /// Deutlicher Alarm auf der Uhr: mehrfache Notification-Haptik.
    private func fireTimerAlarm() {
        let device = WKInterfaceDevice.current()
        device.play(.notification)
        for i in 1...4 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.6) {
                device.play(.notification)
            }
        }
    }
}

extension ConnectivityManager: UNUserNotificationCenterDelegate {
    // Den Timer-Alarm auch bei geöffneter Watch-App als Banner + Ton zeigen.
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
            @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Gefeuert → erlaubt erneutes Planen, falls DERSELBE Timer-Slot später
        // erneut befüllt wird (nur diese eine id betroffen, andere laufende
        // Timer bleiben unangetastet).
        scheduledKeys.removeValue(forKey: notification.request.identifier)
        completionHandler([.banner, .sound])
    }
}
