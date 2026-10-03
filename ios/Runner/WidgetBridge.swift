import Flutter
import Foundation
import Security
import WidgetKit

// ----------------------------------------------------------------------------
// WidgetBridge — MethodChannel-Brücke zwischen Flutter und der iOS-Widget-
// Extension. Schreibt die JSON-Payloads in die App-Group-UserDefaults
// (`group.Walfrosch92.MealieRecipes`) — exakt dasselbe Schema das die
// WidgetKit-Provider in MealieTimerWidget/{Mealplan,ShoppingList,
// DailyRecipe}Widget.swift lesen. Triggert anschließend einen Reload der
// betroffenen Timelines, damit das Widget die neuen Daten zeigt ohne auf
// den nächsten geplanten Refresh-Tick zu warten.
//
// MethodChannel: `mealie/widget`
//   • saveLanguage({"lang": "de"})                — Sprache für Widget-l10n
//   • saveMealplan({"json": "<serialized array>"}) — schreibt widgetMealplan
//   • saveShopping({"json": "<serialized array>"}) — schreibt widgetShoppingList
//   • saveDaily({"json": "<serialized array>"})    — schreibt widgetDailyRecipes
//   • reload({"kind": "MealplanWidget" | "ShoppingListWidget" |
//             "DailyRecipeWidget" | nil}) — manueller WidgetCenter-Reload
// ----------------------------------------------------------------------------

final class WidgetBridge: NSObject {
    private static let appGroupID = "group.Walfrosch92.MealieRecipes"
    private static let kLang     = "widgetLanguage"
    private static let kMealplan = "widgetMealplan"
    private static let kShopping = "widgetShoppingList"
    private static let kDaily    = "widgetDailyRecipes"

    private static var defaults: UserDefaults? {
        UserDefaults(suiteName: appGroupID)
    }

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "mealie/widget",
            binaryMessenger: registrar.messenger()
        )
        channel.setMethodCallHandler { call, result in
            handle(call: call, result: result)
        }
    }

    private static func handle(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "saveLanguage":
            guard let args = call.arguments as? [String: Any],
                  let lang = args["lang"] as? String else {
                result(FlutterError(code: "BAD_ARGS", message: "lang", details: nil))
                return
            }
            defaults?.set(lang, forKey: kLang)
            // Sprachwechsel betrifft Strings aller Widgets — alle reloaden.
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            result(nil)

        case "saveMealplan":
            saveJsonPayload(call: call, key: kMealplan, kind: "MealplanWidget", result: result)

        case "saveShopping":
            saveJsonPayload(call: call, key: kShopping, kind: "ShoppingListWidget", result: result)

        case "saveDaily":
            saveJsonPayload(call: call, key: kDaily, kind: "DailyRecipeWidget", result: result)

        case "saveServerAccess":
            // Zugangsdaten für die Selbst-Aktualisierung der Widgets — in den
            // Keychain (Zugriffsgruppe = App Group, nur App + eigene
            // Extensions), nicht in die UserDefaults. Leeres JSON = löschen.
            let json = (call.arguments as? [String: Any])?["json"] as? String ?? ""
            saveServerAccess(json)
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
            result(nil)

        case "reload":
            let kind = (call.arguments as? [String: Any])?["kind"] as? String
            if #available(iOS 14.0, *) {
                if let kind {
                    WidgetCenter.shared.reloadTimelines(ofKind: kind)
                } else {
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private static func saveServerAccess(_ json: String) {
        let base: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "mealie.widget.serverAccess",
            kSecAttrAccount as String: "access",
            kSecAttrAccessGroup as String: appGroupID,
        ]
        SecItemDelete(base as CFDictionary)
        guard !json.isEmpty, let data = json.data(using: .utf8) else { return }
        var add = base
        add[kSecValueData as String] = data
        // Widgets laufen auch bei gesperrtem Gerät — nach dem ersten
        // Entsperren lesbar, nie in Backups/auf andere Geräte übertragen.
        add[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        SecItemAdd(add as CFDictionary, nil)
    }

    /// Erwartet die Payload als bereits in Dart serialisiertes JSON-Array
    /// (String, kein verschachteltes Map). Wir leiten die UTF-8-Bytes 1:1
    /// als Data in die UserDefaults weiter — exakt das was die WidgetKit-
    /// JSONDecoder-Calls im SharedStore erwarten.
    private static func saveJsonPayload(
        call: FlutterMethodCall,
        key: String,
        kind: String,
        result: @escaping FlutterResult
    ) {
        guard let args = call.arguments as? [String: Any],
              let jsonString = args["json"] as? String,
              let data = jsonString.data(using: .utf8) else {
            result(FlutterError(code: "BAD_ARGS", message: "json", details: nil))
            return
        }
        defaults?.set(data, forKey: key)
        if #available(iOS 14.0, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: kind)
        }
        result(nil)
    }
}
