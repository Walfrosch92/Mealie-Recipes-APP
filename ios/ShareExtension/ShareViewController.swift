import UIKit
import UniformTypeIdentifiers

// Share Extension für "Rezept teilen" (iOS Share Sheet): nimmt eine
// Web-URL/Webseite/Klartext-Link entgegen, baut daraus
// mealierecipes://import?url=<encoded> und übergibt sie per
// UIApplication.open(...) über die Responder-Chain an die Haupt-App — dieselbe Custom-Scheme-
// Pipeline wie Widget-Taps (siehe AppDelegate/SceneDelegate/DeepLinkHandler).
// Bewusst KEIN sichtbares UI (leere View): die App-Öffnung passiert
// praktisch sofort, ein eigener Screen würde nur unnötig aufblitzen.
class ShareViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    handleSharedItem()
  }

  // Durchsucht ALLE geteilten Elemente und Anhänge nach dem ersten Web-Link.
  // Vorher wurde nur der ERSTE Anhang angesehen — Browser teilen genau eine
  // URL, Koch-Apps (Chefkoch, Kptn Cook, …) aber oft mehrere Anhänge (Bild,
  // Titel-Text, dann erst der Link) oder liefern den Link als Data/String
  // statt als URL. Folge: die Erweiterung schloss sich ohne Import.
  // Reihenfolge: echte URL-Anhänge → Text-Anhänge → Begleittext des Items.
  private func handleSharedItem() {
    let items = (extensionContext?.inputItems as? [NSExtensionItem]) ?? []
    let attachments = items.flatMap { $0.attachments ?? [] }
    let urlType = UTType.url.identifier
    let textType = UTType.plainText.identifier

    var candidates: [(NSItemProvider, String)] = []
    for a in attachments where a.hasItemConformingToTypeIdentifier(urlType) {
      candidates.append((a, urlType))
    }
    for a in attachments where a.hasItemConformingToTypeIdentifier(textType) {
      candidates.append((a, textType))
    }
    let fallbackText = items
      .compactMap { $0.attributedContentText?.string }
      .joined(separator: "\n")

    tryCandidates(candidates[...], fallbackText: fallbackText)
  }

  // Nacheinander laden, bis ein http(s)-Link gefunden ist.
  private func tryCandidates(_ rest: ArraySlice<(NSItemProvider, String)>,
                             fallbackText: String) {
    guard let (provider, type) = rest.first else {
      openHostApp(with: Self.extractURL(from: fallbackText as NSString))
      return
    }
    provider.loadItem(forTypeIdentifier: type) { [weak self] data, _ in
      guard let self = self else { return }
      if let url = Self.extractURL(from: data) {
        self.openHostApp(with: url)
      } else {
        self.tryCandidates(rest.dropFirst(), fallbackText: fallbackText)
      }
    }
  }

  // URL-Objekt, Data (UTF-8 / URL-Bytes), String oder attributierter Text —
  // aus Text wird der erste http(s)-Link per NSDataDetector extrahiert (deckt
  // "Schau dir das an: Titel https://…"-Shares ab). Nur http(s): Datei-URLs
  // (geteiltes Bild) oder mailto: sind für den Import nutzlos.
  private static func extractURL(from data: NSSecureCoding?) -> URL? {
    if let url = data as? URL { return webURL(url) }
    var text: String?
    if let s = data as? String {
      text = s
    } else if let a = data as? NSAttributedString {
      text = a.string
    } else if let d = data as? Data {
      if let url = URL(dataRepresentation: d, relativeTo: nil),
         let web = webURL(url) {
        return web
      }
      text = String(data: d, encoding: .utf8)
    }
    guard let text = text, !text.isEmpty else { return nil }
    let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    let range = NSRange(text.startIndex..., in: text)
    for match in detector?.matches(in: text, range: range) ?? [] {
      if let url = match.url, let web = webURL(url) { return web }
    }
    return nil
  }

  private static func webURL(_ url: URL) -> URL? {
    let scheme = url.scheme?.lowercased()
    return (scheme == "http" || scheme == "https") ? url : nil
  }

  private func openHostApp(with url: URL?) {
    // Eigenes, enges Allowed-Set statt .urlQueryAllowed: die geteilte URL
    // landet selbst als WERT eines Query-Parameters, ihre eigenen "&"/"="/"?"
    // müssen also mit-escaped werden, sonst zerreißt sie den äußeren Query-
    // String (mealierecipes://import?url=…).
    var allowed = CharacterSet.alphanumerics
    allowed.insert(charactersIn: "-._~")
    guard
      let url = url,
      let encoded = url.absoluteString.addingPercentEncoding(withAllowedCharacters: allowed),
      let deepLink = URL(string: "mealierecipes://import?url=\(encoded)")
    else {
      close()
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      let opened = self.openViaResponderChain(deepLink)
      NSLog("[ShareExtension] open \(deepLink.absoluteString) -> \(opened)")
      self.close()
    }
  }

  // extensionContext.open(...) funktioniert NUR in Today-/Widget-Extensions —
  // in einer Share Extension liefert es immer false und öffnet nichts (das war
  // der ursprüngliche Bug). Standard-Workaround: die Responder-Chain bis zur
  // UIApplication-Instanz hochlaufen und dort open(_:options:completionHandler:)
  // aufrufen. Aufruf bewusst über den Objective-C-Selektor + IMP, weil
  // UIApplication-APIs in Extensions als "extension-unavailable" annotiert sein
  // können und direkt nicht kompilieren würden. Das alte openURL:-Selektor-
  // Pattern ist seit iOS 18 wirkungslos, daher die 3-Argument-Variante.
  private func openViaResponderChain(_ url: URL) -> Bool {
    let selector = NSSelectorFromString("openURL:options:completionHandler:")
    var responder: UIResponder? = self
    while let current = responder {
      if current is UIApplication, current.responds(to: selector) {
        typealias OpenFn = @convention(c) (
          AnyObject, Selector, NSURL, NSDictionary, ((Bool) -> Void)?
        ) -> Void
        let open = unsafeBitCast(current.method(for: selector), to: OpenFn.self)
        open(current, selector, url as NSURL, NSDictionary(), nil)
        return true
      }
      responder = current.next
    }
    return false
  }

  private func close() {
    extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
  }
}
