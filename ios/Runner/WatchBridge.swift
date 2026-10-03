import Flutter
import Foundation
import WatchConnectivity

// ----------------------------------------------------------------------------
// WatchBridge — MethodChannel-Brücke zwischen Flutter und der watchOS-App.
//
// Pendant zur Android-Seite `WearBridge.kt` (Wearable Data Layer). Schickt die
// laufenden/pausierten Timer, den Kochmodus-Navigationszustand und die offenen
// Einkaufslisten-Artikel per WatchConnectivity an die Apple Watch und nimmt
// umgekehrt deren Steueraktionen (Timer pause/resume/stop, Kochschritt
// vor/zurück, Einkaufsliste abhaken) entgegen und relayed sie an Flutter.
//
// MethodChannel: `mealie/watch`
//   • updateTimers({json})   — JSON-Array von {id,timerName,recipeName,
//                              endDateMillis,remainingSeconds,totalSeconds,
//                              isPaused}, EIN Eintrag pro laufendem/pausiertem
//                              Timer — die Uhr blättert per Wischgeste durch.
//   • clearTimers()
//   • updateCookingMode({active,canBack,canNext})
//   • clearCookingMode()
//   • updateShopping({json})   — JSON-Array von {"name": "..."}
//   • clearShopping()
//   • updateLanguage({lang})   — App-Sprachcode (unabhängig von der
//                                Systemsprache der Uhr, siehe WatchL10n)
//
// Zurück an Flutter (von der Uhr):
//   • action({action: "pause"|"resume"|"stop", id: Int})
//   • cookingAction({action: "next"|"previous"})
//
// Transport: WCSession.updateApplicationContext — der zuletzt gesetzte Zustand
// wird (auch offline) beim nächsten Erreichen der Uhr zugestellt. Wir halten
// einen gemergten Kontext mit den Keys `timers`, `cooking`, `shopping` und `lang`.
// ----------------------------------------------------------------------------

final class WatchBridge: NSObject {
    static let shared = WatchBridge()

    private var channel: FlutterMethodChannel?
    private var context: [String: Any] = [:]

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mealie/watch",
            binaryMessenger: registrar.messenger()
        )
        shared.channel = channel
        channel.setMethodCallHandler { call, result in
            shared.handle(call: call, result: result)
        }
        shared.activate()
    }

    private func activate() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "updateTimers":
            let json = (call.arguments as? [String: Any])?["json"] as? String ?? "[]"
            context["timers"] = json
            pushContext()
            result(nil)
        case "clearTimers":
            context["timers"] = "[]"
            pushContext()
            result(nil)
        case "updateCookingMode":
            if let args = call.arguments as? [String: Any] {
                context["cooking"] = args
                pushContext()
            }
            result(nil)
        case "clearCookingMode":
            context.removeValue(forKey: "cooking")
            pushContext()
            result(nil)
        case "updateShopping":
            let json = (call.arguments as? [String: Any])?["json"] as? String ?? "[]"
            context["shopping"] = json
            pushContext()
            result(nil)
        case "clearShopping":
            context["shopping"] = "[]"
            pushContext()
            result(nil)
        case "updateLanguage":
            let lang = (call.arguments as? [String: Any])?["lang"] as? String ?? "en"
            context["lang"] = lang
            pushContext()
            result(nil)
        case "timerFinished":
            let id = ((call.arguments as? [String: Any])?["id"] as? NSNumber)?.intValue ?? -1
            sendEvent(["timerFinished": id])
            result(nil)
        case "dismissFinishedAlarm":
            // Vom Handy quittiert (grüner Chip / Kochmodus beenden) → die Uhr
            // soll die bereits zugestellten „Timer fertig"-Banner GENAU dieser
            // ids entfernen (andere, weiter laufende Timer bleiben unberührt).
            let ids = ((call.arguments as? [String: Any])?["ids"] as? [Any] ?? [])
                .compactMap { ($0 as? NSNumber)?.intValue }
            sendEvent(["timerAck": ids])
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    /// Einmal-Event (z.B. Timer-Ende) an die Uhr — sendMessage wenn erreichbar,
    /// sonst transferUserInfo (zuverlässig nachgeliefert).
    private func sendEvent(_ msg: [String: Any]) {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        if session.isReachable {
            session.sendMessage(msg, replyHandler: nil) { _ in
                session.transferUserInfo(msg)
            }
        } else {
            session.transferUserInfo(msg)
        }
    }

    private func pushContext() {
        guard WCSession.isSupported() else { return }
        let session = WCSession.default
        guard session.activationState == .activated else { return }
        // updateApplicationContext liefert den jüngsten Zustand auch offline
        // beim nächsten Sync — ideal für State-Spiegelung. Ein zusätzliches
        // `updatedAt` erzwingt eine Änderung, falls sonst alle Felder gleich
        // wären (z.B. nur ein Pause-Toggle).
        var payload = context
        payload["updatedAt"] = Date().timeIntervalSince1970
        // Persistenter Zustand (auch offline beim nächsten Sync zugestellt).
        try? session.updateApplicationContext(payload)
        // WICHTIG: applicationContext stellt iOS nur stark verzögert + rate-
        // limited zu (rapide Calls werden verworfen → Mengenänderung „hängt").
        if session.isReachable {
            // Watch-App offen/erreichbar → sofort per sendMessage.
            session.sendMessage(payload, replyHandler: nil, errorHandler: nil)
        } else {
            // Watch nicht erreichbar (Display aus / App im Hintergrund):
            // transferUserInfo wird ZUVERLÄSSIG zugestellt sobald die Uhr
            // aufwacht und ist NICHT rate-limited wie applicationContext.
            // Vorherige State-Transfers canceln → kein Pileup, nur der jüngste.
            for t in session.outstandingUserInfoTransfers
            where t.userInfo["updatedAt"] != nil {
                t.cancel()
            }
            session.transferUserInfo(payload)
        }
    }

    // Aktion der Uhr an Flutter weiterreichen — Einkaufslisten-Abhaken
    // (`itemId`), Kochschritt-Navigation (`cookingAction`) oder Timer-
    // Steuerung (`action`/`id`).
    fileprivate func dispatchAction(_ message: [String: Any]) {
        // Shopping: Abhaken eines Artikels.
        if let itemId = message["itemId"] as? String, !itemId.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.channel?.invokeMethod("shoppingAction", arguments: ["itemId": itemId])
            }
            return
        }
        // Kochmodus: Schritt vor/zurück.
        if let cookingAction = message["cookingAction"] as? String, !cookingAction.isEmpty {
            DispatchQueue.main.async { [weak self] in
                self?.channel?.invokeMethod("cookingAction", arguments: ["action": cookingAction])
            }
            return
        }
        // Timer: pause/resume/stop.
        guard let action = message["action"] as? String else { return }
        let id = (message["id"] as? NSNumber)?.intValue ?? -1
        guard id >= 0 else { return }
        DispatchQueue.main.async { [weak self] in
            self?.channel?.invokeMethod("action", arguments: ["action": action, "id": id])
        }
    }
}

extension WatchBridge: WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?
    ) {
        // Nach der Aktivierung den aktuellen Zustand einmal nachschieben.
        if activationState == .activated {
            pushContext()
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {}

    func sessionDidDeactivate(_ session: WCSession) {
        // Bei Wechsel der gekoppelten Uhr die Session neu aktivieren.
        WCSession.default.activate()
    }

    // Erreichbar (App im Vordergrund auf der Uhr).
    func session(
        _ session: WCSession,
        didReceiveMessage message: [String: Any]
    ) {
        dispatchAction(message)
    }

    // Hintergrund-zuverlässig (Uhr-App nicht im Vordergrund).
    func session(
        _ session: WCSession,
        didReceiveUserInfo userInfo: [String: Any] = [:]
    ) {
        dispatchAction(userInfo)
    }
}
