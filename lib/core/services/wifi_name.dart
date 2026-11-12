import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:network_info_plus/network_info_plus.dart';

// ---------------------------------------------------------------------------
// Name (SSID) des verbundenen WLANs — für die WLAN-Umschaltung der
// Server-Adresse (Einstellungen → Verbindung).
//
// Android und iOS geben den Namen nur mit Standortberechtigung heraus
// (Android zusätzlich nur bei eingeschalteten Standortdiensten, iOS nur mit
// der „Access Wi-Fi Information"-Capability). Ohne → `null`, die App bleibt
// dann bei der Standardadresse.
// ---------------------------------------------------------------------------

/// Bereinigter WLAN-Name oder `null` (kein WLAN, keine Berechtigung,
/// Plattform ohne Unterstützung).
Future<String?> readWifiName() async {
  if (!(Platform.isAndroid || Platform.isIOS || Platform.isMacOS)) {
    return null;
  }
  try {
    return cleanWifiName(await NetworkInfo().getWifiName());
  } catch (_) {
    return null;
  }
}

/// Android liefert den Namen in Anführungszeichen (`"Heimnetz"`) bzw.
/// `<unknown ssid>`, wenn er nicht lesbar ist.
String? cleanWifiName(String? raw) {
  if (raw == null) return null;
  var s = raw.trim();
  if (s.length >= 2 && s.startsWith('"') && s.endsWith('"')) {
    s = s.substring(1, s.length - 1);
  }
  if (s.isEmpty || s == '<unknown ssid>' || s == '0x') return null;
  return s;
}

/// Standortberechtigung „Bei Nutzung" anfragen, falls noch nicht erteilt —
/// Voraussetzung, damit [readWifiName] auf Android/iOS etwas liefert.
/// „Immer" ist nicht nötig: gelesen wird nur, während die App offen ist.
Future<void> ensureWifiNamePermission() async {
  if (!(Platform.isAndroid || Platform.isIOS)) return;
  try {
    if (await Geolocator.checkPermission() == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }
  } catch (_) {}
}
