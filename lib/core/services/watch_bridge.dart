import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// WatchBridge — plattformübergreifende Brücke zur Smartwatch-Companion-App.
//
// Spiegelt DREI Datenquellen auf die Uhr (Apple Watch / Wear OS):
//   • ALLE laufenden/pausierten Timer (Liste — die Uhr blättert per Wisch-
//     geste durch, Pendant zur Live Activity)
//   • den Kochmodus-Navigationszustand (aktiv? vor/zurück möglich?)
//   • die offenen Einkaufslisten-Artikel
//
// Anzeige-Priorität auf der Uhr (dort entschieden, hier nur Rohdaten):
//   Kochmodus aktiv → Timer (falls vorhanden) + Vor/Zurück-Buttons,
//   KEINE Einkaufsliste. Kein Kochmodus → Einkaufsliste (kein Timer ohne
//   Kochmodus möglich, siehe TimerNotifier).
//
// Transport je Plattform:
//   • Android → MethodChannel `mealie/wear`  → native WearBridge.kt schreibt
//     DataItems in den Wearable Data Layer (`/mealie_timers`, `/mealie_cooking`,
//     `/mealie_shopping`).
//   • iOS     → MethodChannel `mealie/watch` → native WatchBridge.swift schickt
//     sie per WatchConnectivity (WCSession applicationContext) an die watchOS-App.
//
// Beide nativen Seiten implementieren dieselbe Methoden-API:
//   updateTimers / clearTimers / updateCookingMode / clearCookingMode /
//   updateShopping / clearShopping
// und melden Steueraktionen der Uhr zurück:
//   • Timer pause/resume/stop      → [timerActionHandler]
//   • Kochschritt vor/zurück       → [cookingActionHandler]
//   • Einkaufslisten-Artikel abhaken → [shoppingActionHandler]
//
// Alle Aufrufe sind stille No-ops außerhalb von Android/iOS.
// ---------------------------------------------------------------------------

class WatchBridge {
  static const _wear = MethodChannel('mealie/wear'); // Android
  static const _watch = MethodChannel('mealie/watch'); // iOS
  static bool _handlerInstalled = false;

  /// Callback, den der TimerNotifier registriert, um eine von der Uhr
  /// empfangene Steuer-Aktion (`pause`/`resume`/`stop`) auf den lokalen Timer
  /// mit der gegebenen id anzuwenden.
  static void Function(String action, int id)? timerActionHandler;

  /// Callback, den der CookingSessionsNotifier registriert, um eine von der
  /// Uhr empfangene Navigations-Aktion (`next`/`previous`) auf die aktive
  /// Kochsession anzuwenden.
  static void Function(String action)? cookingActionHandler;

  /// Callback für das Abhaken eines Einkaufslisten-Artikels von der Uhr aus
  /// (toggelt `checked` für die gegebene Item-id; synchronisiert zum Server).
  static void Function(String itemId)? shoppingActionHandler;

  static MethodChannel? get _channel => Platform.isAndroid
      ? _wear
      : Platform.isIOS
          ? _watch
          : null;

  /// Einmalig den Handler für eingehende Watch-Aktionen installieren.
  static void ensureActionListener() {
    if (_handlerInstalled) return;
    final ch = _channel;
    if (ch == null) return;
    _handlerInstalled = true;
    ch.setMethodCallHandler((call) async {
      if (call.method == 'action') {
        final args = (call.arguments as Map?) ?? const {};
        final action = args['action'] as String? ?? '';
        final id = (args['id'] as num?)?.toInt() ?? -1;
        if (action.isNotEmpty && id >= 0) {
          timerActionHandler?.call(action, id);
        }
      } else if (call.method == 'cookingAction') {
        final args = (call.arguments as Map?) ?? const {};
        final action = args['action'] as String? ?? '';
        if (action.isNotEmpty) {
          cookingActionHandler?.call(action);
        }
      } else if (call.method == 'shoppingAction') {
        final args = (call.arguments as Map?) ?? const {};
        final itemId = args['itemId'] as String? ?? '';
        if (itemId.isNotEmpty) {
          shoppingActionHandler?.call(itemId);
        }
      }
      return null;
    });
  }

  // ── Timer ────────────────────────────────────────────────────────────────

  /// ALLE aktuell relevanten (laufenden ODER pausierten, nicht fertigen) Timer
  /// auf die Uhr pushen — sie zeigt sie wischbar (ein Timer pro Seite). Jeder
  /// Eintrag: `{id,timerName,recipeName,remainingSeconds,totalSeconds,isPaused}`.
  /// `endDateMillis` (absoluter Endzeitpunkt) wird HIER pro Timer ergänzt,
  /// damit die Uhr jeden Countdown selbst herunterzählen kann, ohne dass jede
  /// Sekunde gepusht werden muss.
  static Future<void> updateTimers(List<Map<String, dynamic>> timers) async {
    final ch = _channel;
    if (ch == null) return;
    final now = DateTime.now();
    final withEnd = timers.map((t) {
      final remaining = t['remainingSeconds'] as int? ?? 0;
      return {
        ...t,
        'endDateMillis':
            now.add(Duration(seconds: remaining)).millisecondsSinceEpoch,
      };
    }).toList();
    try {
      await ch.invokeMethod('updateTimers', {'json': jsonEncode(withEnd)});
    } catch (_) {/* best-effort */}
  }

  /// Alle Timer von der Uhr entfernen (kein aktiver/pausierter Timer mehr).
  static Future<void> clearTimers() async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('clearTimers');
    } catch (_) {/* best-effort */}
  }

  /// Der Uhr melden, dass Timer [id] abgelaufen ist → sie soll läuten/vibrieren.
  /// Die id lässt Android den für GENAU diesen Timer selbst geplanten
  /// Exact-Alarm canceln (sonst würde er kurz danach nochmal läuten) — andere,
  /// weiter laufende Timer bleiben unberührt.
  static Future<void> timerFinished(int id) async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('timerFinished', {'id': id});
    } catch (_) {/* best-effort */}
  }

  /// Der Uhr melden, dass fertige Timer am Handy QUITTIERT wurden (grüner
  /// Chip / „Kochmodus beenden"). Die Uhr räumt dann NUR die bereits
  /// zugestellten „Timer fertig"-Banner der gegebenen `ids` weg — ein evtl.
  /// weiterer noch laufender Timer bleibt unangetastet und läutet bei seinem
  /// Ablauf normal. Pendant zum lokalen In-App-Stop.
  static Future<void> dismissFinishedAlarm(List<int> ids) async {
    if (ids.isEmpty) return;
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('dismissFinishedAlarm', {'ids': ids});
    } catch (_) {/* best-effort */}
  }

  // ── Einkaufsliste ──────────────────────────────────────────────────────────

  /// Die offenen Einkaufslisten-Artikel auf die Uhr pushen. `items` ist eine
  /// Liste von Maps mit dem Key `name` (Anzeigetext, z.B. "2 Eier").
  static Future<void> updateShopping(List<Map<String, dynamic>> items) async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('updateShopping', {'json': jsonEncode(items)});
    } catch (_) {/* best-effort */}
  }

  /// Die Einkaufsliste von der Uhr entfernen.
  static Future<void> clearShopping() async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('clearShopping');
    } catch (_) {/* best-effort */}
  }

  // ── Kochmodus-Navigation ─────────────────────────────────────────────────

  /// Meldet der Uhr: Kochmodus ist aktiv, mit Vor/Zurück-Buttons für den
  /// aktuellen Kochschritt. Blendet auf der Uhr die Einkaufsliste aus (kein
  /// Timer ohne Kochmodus, siehe TimerNotifier — die Buttons sind daher
  /// zusammen mit einem evtl. laufenden Timer sichtbar, sonst allein/größer).
  static Future<void> updateCookingMode({
    required bool canBack,
    required bool canNext,
  }) async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('updateCookingMode', {
        'active': true,
        'canBack': canBack,
        'canNext': canNext,
      });
    } catch (_) {/* best-effort */}
  }

  /// Kochmodus auf der Uhr beenden — sie fällt zurück auf die Einkaufsliste.
  static Future<void> clearCookingMode() async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('clearCookingMode');
    } catch (_) {/* best-effort */}
  }

  // ── Sprache ────────────────────────────────────────────────────────────────

  /// Die in der App gewählte Sprache (Code aus `AppLocalizations.supportedLocales`,
  /// aktuell de/en/es/fr/hu/nl/pl/pt/sl) auf die Uhr spiegeln, damit deren
  /// statische Labels in derselben Sprache erscheinen — unabhängig von der
  /// Systemsprache der Uhr selbst (die App hat eine eigene, davon losgelöste
  /// Sprachauswahl, siehe AppSettings.selectedLanguage).
  static Future<void> updateLanguage(String lang) async {
    final ch = _channel;
    if (ch == null) return;
    try {
      await ch.invokeMethod('updateLanguage', {'lang': lang});
    } catch (_) {/* best-effort */}
  }
}
