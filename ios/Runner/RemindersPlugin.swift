import Flutter
import EventKit

/// MethodChannel bridge exposing the user's Apple Reminders to Flutter.
/// Channel name: "mealie_recipes/reminders"
/// Methoden:
///   fetchLists                 → returns [[id, title, items: [{id, title, completed}]]]
///   complete(ids: [String])    → markiert die Reminder als erledigt (isCompleted = true)
///   delete(ids: [String])      → löscht die Reminder aus dem EventStore
///
/// `complete`/`delete` benötigen volle Reminders-Permission. Wenn der User
/// die schon für `fetchLists` erteilt hat, läuft der Folge-Call ohne neuen
/// Prompt durch — Permission ist app-weit für `.reminder` gesetzt.
class RemindersPlugin: NSObject, FlutterPlugin {
    static let channelName = "mealie_recipes/reminders"
    private let store = EKEventStore()

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: registrar.messenger())
        let instance = RemindersPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "fetchLists":
            withAccess(result: result) { [weak self] in self?.fetchLists(result: result) }
        case "complete":
            let ids = (call.arguments as? [String: Any])?["ids"] as? [String] ?? []
            withAccess(result: result) { [weak self] in
                self?.completeReminders(ids: ids, result: result)
            }
        case "delete":
            let ids = (call.arguments as? [String: Any])?["ids"] as? [String] ?? []
            withAccess(result: result) { [weak self] in
                self?.deleteReminders(ids: ids, result: result)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // Shared Access-Request-Wrapper damit complete/delete dieselbe
    // Permission-Handling-Pipeline wie fetchLists nutzen.
    private func withAccess(result: @escaping FlutterResult,
                             _ then: @escaping () -> Void) {
        requestAccess { granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    result(FlutterError(code: "ACCESS_ERROR",
                                        message: error.localizedDescription,
                                        details: nil))
                    return
                }
                if !granted {
                    result(FlutterError(code: "PERMISSION_DENIED",
                                        message: "Reminders access not granted",
                                        details: nil))
                    return
                }
                then()
            }
        }
    }

    // iOS 17 split Reminders permission into "full" vs "write-only".
    // We need full access to read existing items.
    private func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        if #available(iOS 17.0, *) {
            store.requestFullAccessToReminders(completion: completion)
        } else {
            store.requestAccess(to: .reminder, completion: completion)
        }
    }

    private func fetchLists(result: @escaping FlutterResult) {
        let calendars = store.calendars(for: .reminder)
        if calendars.isEmpty {
            result([])
            return
        }

        var out: [[String: Any]] = []
        let group = DispatchGroup()
        let lock = NSLock()

        for cal in calendars {
            group.enter()
            let predicate = store.predicateForReminders(in: [cal])
            store.fetchReminders(matching: predicate) { reminders in
                let items: [[String: Any]] = (reminders ?? []).map { r in
                    return [
                        "id": r.calendarItemIdentifier,
                        "title": r.title ?? "",
                        "completed": r.isCompleted
                    ]
                }
                lock.lock()
                out.append([
                    "id": cal.calendarIdentifier,
                    "title": cal.title,
                    "items": items
                ])
                lock.unlock()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            result(out)
        }
    }

    // Spiegelt Swifts RemindersImporter.complete(reminderIds:): pro ID den
    // Reminder per calendarItemIdentifier suchen, isCompleted=true setzen
    // und speichern. Fehler beim einzelnen Reminder werden geloggt aber
    // nicht abgebrochen — der User soll möglichst viele Items abhaken
    // können, auch wenn einer auf zwischenzeitlich-gelöscht läuft.
    private func completeReminders(ids: [String], result: @escaping FlutterResult) {
        guard !ids.isEmpty else { result(nil); return }
        let predicate = store.predicateForReminders(in: nil)
        store.fetchReminders(matching: predicate) { [weak self] reminders in
            guard let self = self else { result(nil); return }
            let toComplete = (reminders ?? []).filter {
                ids.contains($0.calendarItemIdentifier)
            }
            for r in toComplete {
                r.isCompleted = true
                try? self.store.save(r, commit: false)
            }
            do {
                try self.store.commit()
                DispatchQueue.main.async { result(nil) }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "COMMIT_ERROR",
                                        message: error.localizedDescription,
                                        details: nil))
                }
            }
        }
    }

    // Spiegelt RemindersImporter.remove(reminderIds:).
    private func deleteReminders(ids: [String], result: @escaping FlutterResult) {
        guard !ids.isEmpty else { result(nil); return }
        let predicate = store.predicateForReminders(in: nil)
        store.fetchReminders(matching: predicate) { [weak self] reminders in
            guard let self = self else { result(nil); return }
            let toDelete = (reminders ?? []).filter {
                ids.contains($0.calendarItemIdentifier)
            }
            for r in toDelete {
                try? self.store.remove(r, commit: false)
            }
            do {
                try self.store.commit()
                DispatchQueue.main.async { result(nil) }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "COMMIT_ERROR",
                                        message: error.localizedDescription,
                                        details: nil))
                }
            }
        }
    }
}
