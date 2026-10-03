import CloudKit
import Flutter
import Foundation
import UIKit
import UserNotifications

// ----------------------------------------------------------------------------
// CloudKitBridge — 1:1 Port der CloudKit-Logik aus
//   `RecipeSendService.swift` der Swift-Vorgängerversion (Mealie Recipes).
//
// Anders als die Swift-Original-App nutzt die Flutter-Version den iCloud
// Key-Value-Store NICHT. Der „Fast-Path" wird stattdessen vom plattform-
// übergreifenden mDNS+TCP-Pfad (Bonsoir → recipe_send_service.dart)
// abgedeckt; CloudKit ist hier ausschließlich der „Reliable/Background"-
// Pfad für Lieferungen die ankommen während die App geschlossen oder das
// Ziel offline ist.
//
// MethodChannel-API (mealie/cloudkit):
//   • init({deviceId, deviceName})         — Subscription registrieren
//   • send({sendId, recipeId, recipeName,
//           targetDeviceId, senderName,
//           senderDeviceId})                — CKRecord schreiben
//   • checkOnLaunch()                       — Pending-Records für dieses
//                                             Gerät pullen + nach Erfolg löschen
//   • handlePush(userInfo)                  — Silent-Push-Payload aus
//                                             didReceiveRemoteNotification
//                                             durchreichen
//
// EventChannel (mealie/cloudkit/events):
//   sendet Maps nach Dart wenn ein Pending-Recipe materialisiert wurde:
//     { sendId, recipeId, recipeName, senderName, senderDeviceId }
// ----------------------------------------------------------------------------

final class CloudKitBridge: NSObject, FlutterStreamHandler {
    static let shared = CloudKitBridge()

    private let cloudDB = CKContainer.default().privateCloudDatabase
    private let ckRecordType = "RecipeSend"

    // iCloud Key-Value-Store: hält ein Device-Registry, das ALLE Geräte
    // des selben Apple-ID-Accounts mit installierter App augenblicklich
    // sehen können (1:1 zu Swifts RecipeSendService.swift). Damit erscheinen
    // iPhone/iPad-Geräte sofort in der Send-Sheet, ohne auf mDNS-Resolve
    // warten zu müssen.
    private let kvStore = NSUbiquitousKeyValueStore.default
    private let kvRegistryKey = "deviceRegistry"
    /// Devices die länger als 30 Tage nicht in der Registry aktualisiert
    /// wurden werden bei jeder Registrierung herausgefiltert.
    private static let registryTTL: TimeInterval = 30 * 24 * 3600

    private var deviceId: String = ""
    private var deviceName: String = ""

    private var eventSink: FlutterEventSink?
    /// Buffer für Events die feuern bevor Dart den EventChannel attached
    /// (z. B. Cold-Launch via Silent-Push: handlePush kommt vor dem
    /// `_ckEventChannel.receiveBroadcastStream()`-Listen). Wird beim ersten
    /// Listen-Attach geflusht.
    private var pendingEvents: [[String: Any]] = []

    // MARK: - Registrierung

    static func register(with registrar: FlutterPluginRegistrar) {
        let messenger = registrar.messenger()
        let methodChannel = FlutterMethodChannel(
            name: "mealie/cloudkit", binaryMessenger: messenger)
        let eventChannel = FlutterEventChannel(
            name: "mealie/cloudkit/events", binaryMessenger: messenger)

        methodChannel.setMethodCallHandler { call, result in
            shared.handle(call: call, result: result)
        }
        eventChannel.setStreamHandler(shared)
    }

    // MARK: - FlutterStreamHandler

    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        // Geflushte Events nachliefern (Cold-Launch).
        for ev in pendingEvents { events(ev) }
        pendingEvents.removeAll()
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSink = nil
        return nil
    }

    // MARK: - MethodChannel-Dispatch

    private func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            guard let args = call.arguments as? [String: Any],
                  let id = args["deviceId"] as? String,
                  let name = args["deviceName"] as? String else {
                result(FlutterError(code: "BAD_ARGS", message: "init args", details: nil))
                return
            }
            deviceId = id
            deviceName = name
            setupSubscription()
            registerCurrentDevice()
            // Externe KV-Store-Änderungen (anderes Gerät meldet sich an
            // oder ab) führen zu einer frischen Peer-Liste in Dart.
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(kvStoreChanged),
                name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                object: kvStore
            )
            kvStore.synchronize()
            emitApplePeers()
            result(nil)
        case "fetchApplePeers":
            result(applePeersPayload())
        case "send":
            guard let args = call.arguments as? [String: Any],
                  let sendId = args["sendId"] as? String,
                  let recipeId = args["recipeId"] as? String,
                  let recipeName = args["recipeName"] as? String,
                  let targetDeviceId = args["targetDeviceId"] as? String,
                  let senderName = args["senderName"] as? String,
                  let senderDeviceId = args["senderDeviceId"] as? String else {
                result(FlutterError(code: "BAD_ARGS", message: "send args", details: nil))
                return
            }
            send(sendId: sendId, recipeId: recipeId, recipeName: recipeName,
                 targetDeviceId: targetDeviceId, senderName: senderName,
                 senderDeviceId: senderDeviceId) { error in
                if let error {
                    result(FlutterError(code: "CK_SAVE",
                                        message: error.localizedDescription,
                                        details: nil))
                } else {
                    result(nil)
                }
            }
        case "checkOnLaunch":
            checkOnLaunch()
            result(nil)
        case "handlePush":
            if let args = call.arguments as? [AnyHashable: Any] {
                handlePush(userInfo: args)
            }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Subscription

    private func setupSubscription() {
        let subscriptionId = "recipe-send-v3-\(deviceId)"
        // v3-Schema: Predicate ohne Index-Pflicht; Target-Filter clientseitig
        // in handlePush. Spiegelt 1:1 das Swift-Original (gleiche Subscription-
        // ID damit ein iCloud-Account beide Apps unterstützen kann).
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(
            recordType: ckRecordType,
            predicate: predicate,
            subscriptionID: subscriptionId,
            options: [.firesOnRecordCreation]
        )
        let info = CKSubscription.NotificationInfo()
        // SICHTBARER High-Priority-Push statt reinem Silent-Push: APNs stellt
        // einen sichtbaren Alert SOFORT zu (auch bei gesperrtem/Hintergrund-
        // Gerät), während ein reiner content-available-Push systematisch
        // gedrosselt wird (~30 s Latenz — genau das gemeldete „Versand dauert
        // 30 s"-Symptom).
        //
        // Das Push-Payload-Budget („notification additional fields limit
        // exceeded") sprengten früher die 5 desiredKeys ZUSAMMEN mit den
        // Alert-Feldern. Lösung: nur EINEN desiredKey mitschicken —
        // `targetDeviceId`. Mehr braucht der Empfangspfad nicht: handlePush()
        // filtert nur nach targetDeviceId, und checkOnLaunch() holt den
        // vollständigen Record (recipeName, senderName, …) ohnehin per Query
        // nach. Damit bleibt Platz für alertBody/soundName.
        //
        // `shouldSendContentAvailable` zusätzlich gesetzt, damit iOS die App bei
        // gesperrtem/Hintergrund-Gerät auch ohne Antippen wecken kann, um den
        // Record vorab zu ziehen (best effort). Im Vordergrund zeigt iOS keinen
        // Banner (AppDelegate ist UNUserNotificationCenter-Delegate ohne
        // willPresent) → dort übernimmt der Dart-Vordergrund-Poll.
        info.alertBody = Self.localizedReceivedBody()
        info.soundName = "default"
        info.shouldSendContentAvailable = true
        info.desiredKeys = ["targetDeviceId"]
        subscription.notificationInfo = info
        cloudDB.save(subscription) { _, error in
            if let error {
                NSLog("[CloudKitBridge] subscription save failed: \(error.localizedDescription)")
            } else {
                NSLog("[CloudKitBridge] subscription aktiv: \(subscriptionId)")
            }
        }
    }

    /// Lokalisierter Banner-Text für den SendTo-Push (Gerätesprache, dieselben
    /// 5 App-Sprachen, Fallback Englisch). Bewusst STATISCH ohne Sender-/
    /// Rezeptname: die Subscription wird einmalig (vor jedem konkreten Send)
    /// erstellt, der konkrete Name steht hier noch nicht zur Verfügung — der
    /// Nutzer sieht ihn nach dem Antippen im aufpoppenden Sheet.
    private static func localizedReceivedBody() -> String {
        let code = (Locale.preferredLanguages.first ?? "en").prefix(2).lowercased()
        switch code {
        case "de": return "Du hast ein Rezept erhalten"
        case "es": return "Has recibido una receta"
        case "fr": return "Vous avez reçu une recette"
        case "nl": return "Je hebt een recept ontvangen"
        default: return "You received a recipe"
        }
    }

    // MARK: - Launch-Registrierung

    /// Registriert dieses Gerät bei JEDEM App-Start in der iCloud-KV-Registry
    /// — 1:1 zu Swifts `RecipeSendService.init()`, das bei jedem Launch
    /// `registerCurrentDevice()` aufrief.
    ///
    /// Ohne das erscheint ein Gerät erst dann in der Registry, wenn der User
    /// die Send-Sheet öffnet (der Dart-Provider baut sich lazy auf und ruft
    /// erst dann `init`). Ein iPad/iPhone, das die App installiert aber die
    /// Send-Sheet nie geöffnet hat, war damit für andere Apple-ID-Geräte
    /// unsichtbar — exakt das gemeldete „SendTo iOS↔iOS same Apple ID geht
    /// nicht"-Symptom.
    ///
    /// `deviceId` stammt aus dem Flutter-SharedPreferences-Store (Key-Prefix
    /// `flutter.`), existiert also für jedes Gerät, das die App schon einmal
    /// eingerichtet hat. `deviceName` nutzt dieselbe Quelle wie der Dart-Pfad
    /// (`device_info_plus` → `UIDevice.current.name`), damit der Registry-
    /// Eintrag beim späteren `init`-Aufruf nicht zwischen zwei Namen springt.
    func registerAtLaunch() {
        let defaults = UserDefaults.standard
        guard let id = defaults.string(forKey: "flutter.recipe_send_device_id"),
              !id.isEmpty else { return }
        if deviceId.isEmpty { deviceId = id }
        if deviceName.isEmpty { deviceName = UIDevice.current.name }
        kvStore.synchronize()
        registerCurrentDevice()
        // CK-Subscription schon beim Launch registrieren — NICHT erst wenn der
        // Empfänger die SendTo-Sheet öffnet (das war die einzige Stelle, die
        // setupSubscription() via `init` auslöste). Ohne Subscription schickt
        // CloudKit gar keinen Push → ein Gerät, das die Sheet nie geöffnet hat,
        // empfing im Hintergrund/geschlossen NICHTS. Idempotent (gleiche
        // Subscription-ID = Upsert), also bei jedem Launch unbedenklich.
        setupSubscription()
    }

    // MARK: - KV-Store Device Registry

    private func registerCurrentDevice() {
        guard !deviceId.isEmpty else { return }
        var registry = loadRegistry()
        let now = Date().timeIntervalSince1970
        let entry: [String: Any] = [
            "id": deviceId,
            "name": deviceName,
            "lastSeen": now,
        ]
        if let idx = registry.firstIndex(where: { ($0["id"] as? String) == deviceId }) {
            registry[idx] = entry
        } else {
            registry.append(entry)
        }
        registry = registry.filter {
            now - (($0["lastSeen"] as? Double) ?? 0) < Self.registryTTL
        }
        saveRegistry(registry)
    }

    private func loadRegistry() -> [[String: Any]] {
        guard let data = kvStore.data(forKey: kvRegistryKey),
              let arr = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else { return [] }
        return arr
    }

    private func saveRegistry(_ registry: [[String: Any]]) {
        guard let data = try? JSONSerialization.data(withJSONObject: registry) else { return }
        kvStore.set(data, forKey: kvRegistryKey)
        kvStore.synchronize()
    }

    /// Liefert die Peer-Liste exklusive dieses Geräts als plain-Dict-Liste
    /// (passend für die FlutterMethodChannel-Result-Konvertierung).
    private func applePeersPayload() -> [[String: Any]] {
        let registry = loadRegistry()
        return registry
            .filter { ($0["id"] as? String) != deviceId }
            .compactMap { dict -> [String: Any]? in
                guard let id = dict["id"] as? String, !id.isEmpty,
                      let name = dict["name"] as? String else { return nil }
                return ["deviceId": id, "name": name]
            }
    }

    private func emitApplePeers() {
        emit(["type": "applePeers", "peers": applePeersPayload()])
    }

    @objc private func kvStoreChanged(_ notification: Notification) {
        // Andere Apple-Geräte haben die Registry geändert (neu hinzu oder
        // entfernt). Frische Peer-Liste an Dart pushen.
        DispatchQueue.main.async { [weak self] in
            self?.emitApplePeers()
        }
    }

    // MARK: - Send

    private func send(sendId: String, recipeId: String, recipeName: String,
                      targetDeviceId: String, senderName: String,
                      senderDeviceId: String,
                      completion: @escaping (Error?) -> Void) {
        let record = CKRecord(recordType: ckRecordType)
        record["sendId"] = sendId as CKRecordValue
        record["recipeId"] = recipeId as CKRecordValue
        record["recipeName"] = recipeName as CKRecordValue
        record["senderName"] = senderName as CKRecordValue
        record["senderDeviceId"] = senderDeviceId as CKRecordValue
        record["targetDeviceId"] = targetDeviceId as CKRecordValue
        record["timestamp"] = Date() as CKRecordValue
        cloudDB.save(record) { _, error in
            if let error {
                NSLog("[CloudKitBridge] send failed: \(error.localizedDescription)")
            }
            DispatchQueue.main.async { completion(error) }
        }
    }

    // MARK: - Empfangen (Silent-Push)

    func handlePush(userInfo: [AnyHashable: Any]) {
        // Silent-CK-Pushes liefern das einzige desiredKey (`targetDeviceId`)
        // unter `ck.qry.af`. Der Push dient nur noch als Trigger: enthält er das
        // targetDeviceId dieses Geräts, holt checkOnLaunch() den vollständigen
        // Record (recipeName, senderName, …) per Query nach und löscht ihn.
        guard let ck = userInfo["ck"] as? [String: Any],
              let qry = ck["qry"] as? [String: Any],
              let af = qry["af"] as? [String: Any],
              let targetId = af["targetDeviceId"] as? String,
              targetId == deviceId else { return }
        checkOnLaunch()
    }

    // MARK: - Launch-Fetch (auch nachgeholte Lieferungen, App war zu)

    func checkOnLaunch() {
        guard !deviceId.isEmpty else { return }
        // Server-seitiger Filter auf das QUERYABLE Feld `targetDeviceId`.
        // `NSPredicate(value: true)` wird intern als Query auf `recordName`
        // ausgeführt → schlägt fehl mit "Field 'recordName' is not marked
        // queryable". Stattdessen direkt nach dem Zielgerät filtern.
        // VORAUSSETZUNG (CloudKit Dashboard → RecipeSend): das Feld
        // `targetDeviceId` muss als QUERYABLE indexiert sein.
        let query = CKQuery(recordType: ckRecordType,
                            predicate: NSPredicate(format: "targetDeviceId == %@", deviceId))
        cloudDB.fetch(withQuery: query, inZoneWith: nil,
                      desiredKeys: nil,
                      resultsLimit: CKQueryOperation.maximumResults) { [weak self] result in
            guard let self else { return }
            if case .failure(let error) = result {
                NSLog("[CloudKitBridge] checkOnLaunch query failed: \(error.localizedDescription)")
                return
            }
            guard case .success(let (matchResults, _)) = result else { return }
            // Query liefert bereits nur Records FÜR DIESES Gerät.
            let records = matchResults.compactMap { try? $1.get() }
            guard !records.isEmpty else { return }

            // Nur Records < 1h Alter ausliefern. Server-Cleanup geschieht
            // unabhängig davon (alle Records dieses Targets löschen).
            let valid = records
                .filter { ($0["timestamp"] as? Date).map { Date().timeIntervalSince($0) < 3600 } ?? false }
                .sorted { ($0["timestamp"] as? Date ?? .distantPast) > ($1["timestamp"] as? Date ?? .distantPast) }

            // CKModifyRecordsOperation läuft parallel zum Emit.
            let op = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: records.map { $0.recordID })
            self.cloudDB.add(op)

            for record in valid {
                guard let recipeId = record["recipeId"] as? String,
                      let recipeName = record["recipeName"] as? String else { continue }
                let sendId = (record["sendId"] as? String) ?? ""
                let senderName = (record["senderName"] as? String) ?? ""
                let senderDeviceId = (record["senderDeviceId"] as? String) ?? ""
                self.emit([
                    "type": "recipe",
                    "sendId": sendId,
                    "recipeId": recipeId,
                    "recipeName": recipeName,
                    "senderName": senderName,
                    "senderDeviceId": senderDeviceId,
                ])
            }
        }
    }

    // MARK: - Event-Emit (gepuffert)

    private func emit(_ payload: [String: Any]) {
        if let sink = eventSink {
            DispatchQueue.main.async { sink(payload) }
        } else {
            pendingEvents.append(payload)
        }
    }
}
