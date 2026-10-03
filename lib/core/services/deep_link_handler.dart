import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ---------------------------------------------------------------------------
// DeepLinkHandler — empfängt `mealierecipes://`-URIs vom Custom-Scheme
// (Widget-Taps, externe App-Links) und routet sie via GoRouter.
//
// Unterstützte URIs (1:1 zum Swift-Original):
//   • mealierecipes://recipe?id=<recipeId>   → /recipes/<recipeId>
//   • mealierecipes://mealplan               → /mealplan
//   • mealierecipes://shopping               → /shopping
//   • mealierecipes://cook?code=<code>       → /cook-friends?code=<code>
//   • mealierecipes://import?url=<url>       → /import?url=<url>
//     (iOS Share Extension / Android Share-Sheet — Rezept-URL aus dem
//     System-"Teilen"-Dialog direkt an den bestehenden URL-Import geben)
//
// iOS bekommt die URIs via SceneDelegate/AppDelegate URL-Handler durch das
// `app_links`-Plugin. Android nutzt das Intent-Filter im Manifest.
// Provider hält den Subscription-Lifecycle; `ref.onDispose` cancelled.
// ---------------------------------------------------------------------------

final deepLinkHandlerProvider = Provider<DeepLinkHandler>((ref) {
  final handler = DeepLinkHandler();
  ref.onDispose(handler.dispose);
  return handler;
});

class DeepLinkHandler {
  // Nativer Cold-Start-Kanal (iOS): liefert die launchOptions-URL, die
  // app_links unter dem Implicit-Engine-Pattern verpasst (Plugins registrieren
  // sich erst NACH didFinishLaunchingWithOptions).
  static const _nativeChannel = MethodChannel('mealie/deeplink');

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  GoRouter? _router;
  bool _ready = false;
  Uri? _pendingUri;
  // Der Initial-Link kann aus ZWEI Quellen kommen (app_links + nativer Kanal).
  // Nur einmal verarbeiten, sonst doppelte Navigation.
  bool _initialConsumed = false;
  // Entdoppelung warmer Taps: derselbe Tap kann (je nach iOS-/Plugin-Version)
  // sowohl über den SceneDelegate-Push als auch über app_links ankommen.
  String? _lastHandled;
  DateTime _lastHandledAt = DateTime.fromMillisecondsSinceEpoch(0);

  /// Wird vom MaterialApp-Builder mit dem aktuellen GoRouter aufgerufen.
  /// Hängt sich (einmalig) an app_links und merkt sich den aktuellen Router.
  /// WICHTIG früh aufrufen — ein Cold-Start-Initial-Link (Widget-Tap) muss
  /// erfasst werden, auch bevor die Settings geladen sind. Die eigentliche
  /// Navigation wird bis `markReady(true)` gepuffert.
  void attach(GoRouter router) {
    _router = router;
    if (_sub != null) return;
    // Initial-Link Quelle 1: app_links (deckt warme Launches + manche Cold).
    unawaited(_appLinks.getInitialLink().then((uri) {
      if (uri != null) _handleInitial(uri);
    }).catchError((_) {}));
    // Initial-Link Quelle 2: nativer Cold-Start-Kanal (iOS) — das ist der
    // zuverlässige Pfad für den Widget-Tap aus komplett geschlossener App.
    // Zusätzlich pusht der SceneDelegate warme Taps aktiv über `onDeepLink`
    // (bei aktivem UIScene erreichen Custom-Scheme-URLs app_links nicht).
    if (Platform.isIOS) {
      _nativeChannel.setMethodCallHandler((call) async {
        if (call.method == 'onDeepLink') {
          final s = call.arguments as String?;
          if (s != null && s.isNotEmpty) _onUri(Uri.parse(s));
        }
        return null;
      });
      unawaited(_nativeChannel.invokeMethod<String>('getInitialLink').then((s) {
        if (s != null && s.isNotEmpty) _handleInitial(Uri.parse(s));
      }).catchError((_) {}));
    }
    // Live-Stream für warme Launches (App war im Hintergrund).
    _sub = _appLinks.uriLinkStream.listen(_onUri, onError: (_) {});
  }

  /// Verarbeitet den Initial-Link genau EINMAL (egal welche Quelle zuerst da
  /// ist). Warm-Taps laufen über den Stream direkt in `_onUri`.
  void _handleInitial(Uri uri) {
    if (_initialConsumed) return;
    _initialConsumed = true;
    _onUri(uri);
  }

  /// Signalisiert App-Bereitschaft (Settings geladen + Server eingerichtet).
  /// Flusht einen ggf. gepufferten Initial-Link. Ohne diese Verzögerung würde
  /// ein Cold-Start-Widget-Tap navigieren bevor Server-URL/Token bereitstehen
  /// → Ziel-Views (Rezept, Einkaufsliste) zeigen einen API-Fehler.
  void markReady(bool ready) {
    if (_ready == ready) return;
    _ready = ready;
    final pending = _pendingUri;
    if (ready && pending != null) {
      _pendingUri = null;
      _onUri(pending);
    }
  }

  void _onUri(Uri uri) {
    final path = _resolvePath(uri);
    if (path == null) return;
    final router = _router;
    // Noch nicht bereit (Settings laden) oder kein Router → puffern und beim
    // nächsten markReady(true) / attach nachholen. (Dedupe NICHT hier, sonst
    // würde der gepufferte Cold-Start-Flush als „Duplikat" verworfen.)
    if (!_ready || router == null) {
      _pendingUri = uri;
      return;
    }
    // Doppelte Zustellung desselben Taps (Scene-Push + app_links) innerhalb
    // eines kurzen Fensters verwerfen.
    final now = DateTime.now();
    if (path == _lastHandled &&
        now.difference(_lastHandledAt) < const Duration(milliseconds: 1200)) {
      return;
    }
    _lastHandled = path;
    _lastHandledAt = now;
    _navigate(router, path, attempt: 0);
  }

  /// Pusht den Pfad, SOBALD der GoRouter-Navigator wirklich steht. Beim
  /// Cold-Start (App per Widget-Tap frisch gelauncht) ist der Navigator beim
  /// allerersten PostFrame oft noch nicht aufgebaut — ein direkter `push`
  /// ginge dann verloren. Genau das war das „erst beim zweiten Tippen"-
  /// Symptom: erst öffnete nur die Main-View, beim zweiten (warmen) Tap
  /// stand der Navigator und es klappte. Daher bis ~5 s in 100-ms-Schritten
  /// retrien, bis `navigatorKey.currentState` verfügbar ist.
  void _navigate(GoRouter router, String path, {required int attempt}) {
    void attemptPush() {
      final ready = router.routerDelegate.navigatorKey.currentState != null;
      if (ready) {
        try {
          // Liegt das Ziel bereits oben → nicht erneut pushen. Sonst stapeln
          // sich (bei Mehrfach-Zustellung desselben Widget-Taps) Duplikate und
          // man muss mehrmals „zurück" drücken, um wieder zur Hauptansicht zu
          // gelangen (Android-Symptom).
          final current =
              router.routerDelegate.currentConfiguration.uri.toString();
          if (current == path) return;
          router.push(path);
        } catch (_) {
          if (attempt < 50) {
            Future.delayed(const Duration(milliseconds: 100),
                () => _navigate(router, path, attempt: attempt + 1));
          }
        }
        return;
      }
      if (attempt >= 50) return; // ~5 s — aufgeben statt ewig pollen
      Future.delayed(const Duration(milliseconds: 100),
          () => _navigate(router, path, attempt: attempt + 1));
    }

    if (attempt == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) => attemptPush());
    } else {
      attemptPush();
    }
  }

  /// Mappt eine `mealierecipes://…`-URI auf einen GoRouter-Pfad. Returnt
  /// null wenn das Schema/Host unbekannt ist.
  String? _resolvePath(Uri uri) {
    if (uri.scheme != 'mealierecipes') return null;
    switch (uri.host) {
      case 'recipe':
        final id = uri.queryParameters['id'];
        if (id == null || id.isEmpty) return null;
        // Als EIN Pfadsegment kodieren — ein Link wie „…?id=x/edit" darf
        // nicht auf andere App-Seiten (Editor o. ä.) umleiten.
        return '/recipes/${Uri.encodeComponent(id)}';
      case 'mealplan':
        return '/mealplan';
      case 'shopping':
        return '/shopping';
      case 'timer':
        // Tap auf die Timer-Live-Activity (iPhone). Bringt die App nach vorn;
        // der laufende Timer ist über die Kochsessions-Leiste/FAB erreichbar.
        return '/home';
      case 'cook':
        final code = uri.queryParameters['code'];
        if (code == null || code.isEmpty) return '/cook-friends';
        return Uri(path: '/cook-friends', queryParameters: {'code': code})
            .toString();
      case 'import':
        // Kommt von der iOS Share Extension bzw. dem Android
        // ShareReceiverActivity — beide reichen die geteilte Rezept-URL
        // 1:1 über dieses Schema weiter.
        final url = uri.queryParameters['url'];
        if (url == null || url.isEmpty) return null;
        return Uri(path: '/import', queryParameters: {'url': url}).toString();
      default:
        return null;
    }
  }

  void dispose() {
    _sub?.cancel();
    _sub = null;
  }
}
