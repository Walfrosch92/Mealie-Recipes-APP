import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/shopping_reminder_location.dart';

// ---------------------------------------------------------------------------
// ShoppingReminderBridge — Dart-Seite der `mealie/shopping_reminder`
// MethodChannel-Brücke (Issue #29: "Erinnere mich zum Einkaufen").
//
// Pusht die bis zu 3 gespeicherten Standorte an die native Seite, die daraus
// echte OS-Geofences registriert:
//   • iOS     → `ios/Runner/ShoppingReminderManager.swift`
//               (CLLocationManager.startMonitoring(for:), 100 m Radius).
//   • Android → `.../shopping_reminder/ShoppingReminderManager.kt`
//               (GeofencingClient, 100 m Radius).
//
// Das Feuern der Benachrichtigung selbst passiert komplett NATIV (ohne Dart/
// Flutter-Engine) — der geofence-Trigger liest den zuletzt von
// `widget_sync_provider.dart` gepushten Einkaufslisten-Stand direkt aus dem
// bestehenden Widget-Store (App-Group-UserDefaults bzw. die
// `mealie_widgets`-DataStore) und zeigt die Notification nur, wenn dort
// offene Artikel stehen. Es gibt deshalb bewusst KEINEN eigenen
// "hasOpenItems"-Push hier — das wäre nur ein zweiter, potenziell
// veralteter Signalweg neben dem ohnehin schon aktuell gehaltenen Widget-Store.
// ---------------------------------------------------------------------------

class ShoppingReminderBridge {
  static const _channel = MethodChannel('mealie/shopping_reminder');

  ShoppingReminderBridge._();

  /// Registriert genau diese Standorte als Geofences (ersetzt alle
  /// vorherigen). Leere Liste = alle Geofences entfernen (Toggle AUS).
  static Future<void> setLocations(
      List<ShoppingReminderLocation> locations) async {
    if (!_supported) return;
    try {
      await _channel.invokeMethod('setLocations', {
        'json': jsonEncode(locations.map((l) => l.toJson()).toList()),
      });
    } catch (_) {/* best-effort, wie WidgetBridge */}
  }

  static bool get _supported => Platform.isIOS || Platform.isAndroid;
}
