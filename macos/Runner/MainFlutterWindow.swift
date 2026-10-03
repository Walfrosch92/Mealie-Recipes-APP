import Cocoa
import FlutterMacOS
import IOKit.pwr_mgt

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    // Aufruf durch den Deinstaller (macos/packaging/uninstall.applescript):
    // Daten löschen und sofort beenden, ohne Flutter zu starten.
    if CommandLine.arguments.contains(AppDataWiper.argument) {
      AppDataWiper.wipe()
      exit(0)
    }

    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController

    // Querformat-Fenster für große Anzeigen: ab 840 pt Breite nutzt die App
    // ein eigenes Layout (mehrspaltig, höheres Vorschlagsbild). Frei
    // skalierbar/maximierbar; kleiner als 420×640 wird das Handy-Layout
    // unbrauchbar.
    self.title = "Mealie Recipes"
    self.minSize = NSSize(width: 420, height: 640)
    self.setContentSize(NSSize(width: 1200, height: 800))
    self.center()
    // Größe/Position merken und beim nächsten Start wiederherstellen.
    self.setFrameUsingName("MealieRecipesMainWindow")
    self.setFrameAutosaveName("MealieRecipesMainWindow")

    RegisterGeneratedPlugins(registry: flutterViewController)
    WakeLockPlugin.register(
      with: flutterViewController.registrar(forPlugin: "WakeLockPlugin"))

    super.awakeFromNib()
  }
}

/// macOS-Gegenstück zu ios/Runner/WakeLockPlugin.swift (Kochmodus hält den
/// Bildschirm wach) — per IOPMAssertion statt isIdleTimerDisabled.
///
/// Channel: "mealie_recipes/wakelock"
///   enable()  → Display-Ruhezustand verhindern
///   disable() → Assertion wieder freigeben
class WakeLockPlugin: NSObject, FlutterPlugin {
  private var assertionID: IOPMAssertionID = 0
  private var active = false

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "mealie_recipes/wakelock", binaryMessenger: registrar.messenger)
    registrar.addMethodCallDelegate(WakeLockPlugin(), channel: channel)
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "enable":
      if !active {
        active = IOPMAssertionCreateWithName(
          kIOPMAssertionTypePreventUserIdleDisplaySleep as CFString,
          IOPMAssertionLevel(kIOPMAssertionLevelOn),
          "Mealie Recipes – Kochmodus" as CFString,
          &assertionID) == kIOReturnSuccess
      }
      result(nil)
    case "disable":
      if active {
        IOPMAssertionRelease(assertionID)
        active = false
      }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

/// Löscht alle Daten der App für den Deinstaller (Aufruf mit
/// `--wipe-app-data`, siehe macos/packaging/uninstall.applescript).
///
/// Die App läuft OHNE Sandbox → ihre Daten liegen in den gemeinsamen
/// Benutzer-Ordnern. Deshalb werden AUSSCHLIESSLICH die eigenen, nach der
/// Bundle-ID benannten Unterordner gelöscht (path_provider legt App Support
/// und Caches unter `<Bundle-ID>` an) — niemals ganze Ordner wie
/// ~/Library/Caches. Dazu der Bild-Cache von cached_network_image
/// (`~/Library/Caches/libCachedImageData`, reiner Cache).
/// Alte Sandbox-Installationen (bis 2026-10-03) hatten alles im Container
/// ~/Library/Containers/<ID>; den räumt der Deinstaller selbst auf.
enum AppDataWiper {
  static let argument = "--wipe-app-data"
  private static let keychainService = "Walfrosch92.MealieRecipes"

  static func wipe() {
    guard let id = Bundle.main.bundleIdentifier, !id.isEmpty else { return }
    let fm = FileManager.default
    let library = fm.homeDirectoryForCurrentUser.appendingPathComponent("Library")
    let targets = [
      "Application Support/\(id)",
      "Caches/\(id)",
      "Caches/libCachedImageData",
      "HTTPStorages/\(id)",
      "HTTPStorages/\(id).binarycookies",
      "WebKit/\(id)",
      "Saved Application State/\(id).savedState",
    ]
    for rel in targets {
      let url = library.appendingPathComponent(rel)
      // Sicherheitsnetz: nur echte Unterordner/Dateien UNTER ~/Library,
      // nie Symlinks.
      guard url.path.hasPrefix(library.path + "/"), !isSymlink(url) else {
        continue
      }
      try? fm.removeItem(at: url)
    }

    // Einstellungen (shared_preferences = UserDefaults).
    UserDefaults.standard.removePersistentDomain(forName: id)
    UserDefaults.standard.synchronize()
    try? fm.removeItem(
      at: library.appendingPathComponent("Preferences/\(id).plist"))

    // API-Token im Schlüsselbund (flutter_secure_storage, eigener Dienst).
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrService: keychainService,
    ]
    for _ in 0..<20 {
      if SecItemDelete(query as CFDictionary) != errSecSuccess { break }
    }
  }

  private static func isSymlink(_ url: URL) -> Bool {
    (try? url.resourceValues(forKeys: [.isSymbolicLinkKey]))?.isSymbolicLink ?? false
  }
}
