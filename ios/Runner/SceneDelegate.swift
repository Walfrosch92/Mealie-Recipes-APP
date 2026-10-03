import Flutter
import UIKit

// Bei aktiviertem UIScene-Lifecycle (siehe UIApplicationSceneManifest in der
// Info.plist) liefert iOS Custom-Scheme-URLs (Widget-Taps `mealierecipes://…`)
// NICHT mehr an AppDelegate.application(_:open:) und auch nicht über
// launchOptions[.url], sondern an den Scene-Lifecycle:
//   • Cold-Start (App war geschlossen): URL in connectionOptions.urlContexts
//     von scene(_:willConnectTo:options:).
//   • Warm (App lief im Hintergrund): scene(_:openURLContexts:).
//
// COLD-START-CRASH (Widget-Tap aus geschlossener App stürzt beim Öffnen ab,
// warmer Tap funktioniert):
// Diese App nutzt die Implicit-Engine + das `Main`-Storyboard (Info.plist:
// UISceneStoryboardFile=Main / UIMainStoryboardFile=Main). UIKit instanziiert
// Fenster + FlutterViewController also AUTOMATISCH aus dem Storyboard, und die
// Engine hängt sich beim ersten View-Attach selbst an (Flutter-Doku Implicit-
// Engine). `FlutterSceneDelegate.scene(_:willConnectTo:)` macht hier daher KEIN
// Engine-/Fenster-Setup — es reicht die `connectionOptions.urlContexts`-URL nur
// an die Scene-Lifecycle-Plugins (app_links) weiter. GENAU das crasht beim
// Kaltstart: app_links bekommt die Launch-URL und ruft die Dart-Engine, deren
// Task-Runner noch nicht stehen → EXC_BAD_ACCESS in
// TaskRunners::GetUITaskRunner (flutter/flutter#183586). Das passiert auch mit
// app_links 7.x, weil app_links beim Scene-Connect die URL sofort verarbeitet.
//
// Lösung: Liegt beim Connect eine URL an (= Cold-Start per Widget), merken wir
// sie uns nur und rufen `super` BEWUSST NICHT auf → die URL wird NIE während
// der Engine-Init weitergereicht. Fenster/VC kommen trotzdem aus dem Storyboard;
// Dart holt die URL nach dem Start sicher über `mealie/deeplink` getInitialLink.
// Ohne URL (normaler App-Icon-Launch) läuft `super` ganz normal.
class SceneDelegate: FlutterSceneDelegate {

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    if let url = connectionOptions.urlContexts.first?.url {
      (UIApplication.shared.delegate as? AppDelegate)?.stashColdStartURL(url)
      // KEIN super hier — sonst leitet FlutterSceneDelegate die URL an app_links
      // weiter und crasht die noch nicht bereite Engine (siehe Kommentar oben).
      return
    }
    super.scene(scene, willConnectTo: session, options: connectionOptions)
  }

  // Warmer Tap: App lief bereits, Engine/Window stehen → URL aktiv an Dart
  // pushen. super-Aufruf bleibt, damit Flutters Plugin-Weiterleitung intakt ist.
  override func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    if let url = URLContexts.first?.url {
      (UIApplication.shared.delegate as? AppDelegate)?.deliverDeepLink(url)
    }
    super.scene(scene, openURLContexts: URLContexts)
  }
}
