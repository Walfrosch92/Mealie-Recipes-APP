import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/screens/home_screen.dart' show searchableHomeTiles;
import 'sidebar_pins.dart';

import '../utils/platform_features.dart';
import 'desktop_file_drop.dart';

// ---------------------------------------------------------------------------
// Tastenkürzel der Desktop-Apps (Windows: Strg, macOS: ⌘). Liegt um die
// ganze App (MaterialApp.builder):
//   Strg/⌘ + F (auch K) → Befehlspalette (globale Suche)
//   Strg/⌘ + N         → Rezept importieren
//   Strg/⌘ + 1 … 6     → Home, Rezepte, Einkaufsliste, Essensplan,
//                        Weiteres, Einstellungen (wie in der Seitenleiste)
//   Strg/⌘ + ,         → Einstellungen
//   Esc                → zurück (Dialoge/Sheets schließen sich weiterhin
//                        selbst — dort gewinnt deren eigene Esc-Aktion)
// Der Kochmodus hat zusätzlich eigene Kürzel (← / → / Leertaste).
// ---------------------------------------------------------------------------

class DesktopShortcuts extends ConsumerWidget {
  final GoRouter router;
  final Widget child;
  const DesktopShortcuts(
      {super.key, required this.router, required this.child});

  static SingleActivator _mod(LogicalKeyboardKey key) => Platform.isMacOS
      ? SingleActivator(key, meta: true)
      : SingleActivator(key, control: true);

  void _go(String path) => router.go(path);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!PlatformFeatures.webAppTools) return child;
    void palette() => router.push('/search');
    // Eigene Kürzel der an die Seitenleiste gehefteten Kacheln.
    void openTile(String key) {
      final nav = router.routerDelegate.navigatorKey.currentContext;
      if (nav == null) return;
      searchableHomeTiles(nav, ref)
          .where((t) => t.key == key)
          .firstOrNull
          ?.onTap();
    }

    final pins = ref.watch(sidebarPinsProvider);
    return CallbackShortcuts(
      bindings: {
        _mod(LogicalKeyboardKey.keyK): palette,
        _mod(LogicalKeyboardKey.keyF): palette,
        _mod(LogicalKeyboardKey.keyN): () => router.push('/import'),
        _mod(LogicalKeyboardKey.digit1): () => _go('/home'),
        _mod(LogicalKeyboardKey.digit2): () => _go('/recipes'),
        _mod(LogicalKeyboardKey.digit3): () => _go('/shopping'),
        _mod(LogicalKeyboardKey.digit4): () => _go('/mealplan'),
        _mod(LogicalKeyboardKey.digit5): () {
          // „Weiteres" liegt über den Tabs — nicht doppelt öffnen.
          final path = router.routerDelegate.currentConfiguration.uri.path;
          if (path != '/manage') router.push('/manage');
        },
        _mod(LogicalKeyboardKey.digit6): () => _go('/settings'),
        _mod(LogicalKeyboardKey.comma): () => _go('/settings'),
        for (final p in pins)
          if (p.shortcut != null) p.shortcut!.activator: () => openTile(p.key),
      },
      // Esc als Aktion statt Kürzel: Dialoge, Sheets und Menüs liefern ihre
      // eigene DismissAction (näher am Fokus) und schließen sich wie gewohnt;
      // nur wenn keine da ist, geht es hier eine Seite zurück.
      child: Actions(
        actions: {
          DismissIntent: CallbackAction<DismissIntent>(onInvoke: (_) {
            if (router.canPop()) router.pop();
            return null;
          }),
        },
        // Link-Dateien ins Fenster ziehen → Rezept-Import.
        child: Focus(
            autofocus: true,
            child: DesktopLinkDrop(router: router, child: child)),
      ),
    );
  }
}
