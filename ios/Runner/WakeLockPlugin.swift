import Flutter
import UIKit

/// Tiny replacement for the wakelock_plus pod — kept in-house to avoid that
/// plugin's Xcode-16 module-verifier build failures (its umbrella header
/// imports Flutter.h with quoted #imports the verifier rejects).
///
/// Channel: "mealie_recipes/wakelock"
///   enable()  → UIApplication.shared.isIdleTimerDisabled = true
///   disable() → UIApplication.shared.isIdleTimerDisabled = false
class WakeLockPlugin: NSObject, FlutterPlugin {
    static let channelName = "mealie_recipes/wakelock"

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: channelName,
                                           binaryMessenger: registrar.messenger())
        let instance = WakeLockPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "enable":
            DispatchQueue.main.async {
                UIApplication.shared.isIdleTimerDisabled = true
                result(nil)
            }
        case "disable":
            DispatchQueue.main.async {
                UIApplication.shared.isIdleTimerDisabled = false
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
