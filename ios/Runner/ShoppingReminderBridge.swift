import Flutter
import Foundation

// ----------------------------------------------------------------------------
// ShoppingReminderBridge — MethodChannel-Brücke `mealie/shopping_reminder`
// zwischen Flutter und ShoppingReminderManager (Issue #29 "Erinnere mich
// zum Einkaufen"). Pendant zu android/.../MainActivity.kt's
// shoppingReminderChannel-Handler.
//
//   • setLocations({"json": "<[{id,name,lat,lng}]>"}) — ersetzt alle
//     überwachten Geofences.
// ----------------------------------------------------------------------------

final class ShoppingReminderBridge: NSObject {
    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mealie/shopping_reminder",
            binaryMessenger: registrar.messenger()
        )
        channel.setMethodCallHandler { call, result in
            switch call.method {
            case "setLocations":
                guard let args = call.arguments as? [String: Any],
                      let jsonString = args["json"] as? String,
                      let data = jsonString.data(using: .utf8),
                      let list = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
                else {
                    result(FlutterError(code: "BAD_ARGS", message: "json", details: nil))
                    return
                }
                ShoppingReminderManager.shared.configureRegions(list)
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}
