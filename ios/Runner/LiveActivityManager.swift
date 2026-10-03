import Foundation
import Flutter
#if canImport(ActivityKit)
import ActivityKit

/// MethodChannel that drives the cooking-timer Live Activity from Dart.
///
/// Channel: "mealie_recipes/live_activity"
/// Methods:
///   start(timerName, recipeName, endDateMillis, totalSeconds, isPaused, extraCount)
///   update(timerName, recipeName, endDateMillis, totalSeconds, isPaused, extraCount)
///   stop()
///
/// All methods are no-ops on iOS < 16.1 (or when the user has disabled
/// Live Activities for the app); they always succeed so the Dart code can
/// stay platform-agnostic.
class LiveActivityManager: NSObject, FlutterPlugin {
    static let channelName = "mealie_recipes/live_activity"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: registrar.messenger())
        let instance = LiveActivityManager()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private var activityID: String?

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard #available(iOS 16.2, *) else {
            result(nil) // silently no-op on older iOS
            return
        }

        switch call.method {
        case "start":
            startActivity(args: call.arguments, result: result)
        case "update":
            updateActivity(args: call.arguments, result: result)
        case "stop":
            stopActivity(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    @available(iOS 16.2, *)
    private func parseState(_ args: Any?) -> TimerActivityAttributes.TimerState? {
        guard let map = args as? [String: Any] else { return nil }
        let timerName = (map["timerName"] as? String) ?? "Timer"
        let recipeName = (map["recipeName"] as? String) ?? ""
        let endMillis = (map["endDateMillis"] as? NSNumber)?.doubleValue ?? 0
        let total = (map["totalSeconds"] as? NSNumber)?.intValue ?? 0
        let paused = (map["isPaused"] as? Bool) ?? false
        let extra = (map["extraCount"] as? NSNumber)?.intValue ?? 0
        return TimerActivityAttributes.TimerState(
            timerName: timerName,
            recipeName: recipeName,
            endDate: Date(timeIntervalSince1970: endMillis / 1000.0),
            totalSeconds: total,
            isPaused: paused,
            extraCount: extra
        )
    }

    @available(iOS 16.2, *)
    private func startActivity(args: Any?, result: @escaping FlutterResult) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            result(nil) // user disabled Live Activities → silent no-op
            return
        }
        // Already running → fold into update.
        if activityID != nil {
            updateActivity(args: args, result: result)
            return
        }
        guard let state = parseState(args) else {
            result(FlutterError(code: "BAD_ARGS",
                                message: "missing activity state",
                                details: nil))
            return
        }
        do {
            let attrs = TimerActivityAttributes()
            let content = ActivityContent(state: state, staleDate: nil)
            let activity = try Activity<TimerActivityAttributes>.request(
                attributes: attrs,
                content: content,
                pushType: nil
            )
            activityID = activity.id
            result(nil)
        } catch {
            result(FlutterError(code: "ACTIVITY_ERROR",
                                message: error.localizedDescription,
                                details: nil))
        }
    }

    @available(iOS 16.2, *)
    private func updateActivity(args: Any?, result: @escaping FlutterResult) {
        guard let state = parseState(args) else {
            result(FlutterError(code: "BAD_ARGS",
                                message: "missing activity state",
                                details: nil))
            return
        }
        let current = Activity<TimerActivityAttributes>.activities.first { $0.id == activityID }
            ?? Activity<TimerActivityAttributes>.activities.first
        guard let activity = current else {
            // No live activity to update — start one instead.
            activityID = nil
            startActivity(args: args, result: result)
            return
        }
        activityID = activity.id
        Task {
            await activity.update(ActivityContent(state: state, staleDate: nil))
            result(nil)
        }
    }

    @available(iOS 16.2, *)
    private func stopActivity(result: @escaping FlutterResult) {
        let activities = Activity<TimerActivityAttributes>.activities
        if activities.isEmpty {
            activityID = nil
            result(nil)
            return
        }
        Task {
            for a in activities {
                await a.end(nil, dismissalPolicy: .immediate)
            }
            self.activityID = nil
            result(nil)
        }
    }
}
#else
// ActivityKit not available — provide a stub so AppDelegate compiles.
class LiveActivityManager: NSObject, FlutterPlugin {
    static let channelName = "mealie_recipes/live_activity"
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: registrar.messenger())
        channel.setMethodCallHandler { _, result in result(nil) }
    }
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(nil)
    }
}
#endif
