import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';

import '../../../core/models/shopping_reminder_location.dart';

// ---------------------------------------------------------------------------
// ShoppingReminderLocationService — Positionsabfrage + kostenlose
// Adresssuche (nativer iOS/Android-Geocoder, kein API-Key) für "Erinnere
// mich zum Einkaufen" (Settings > Einkaufsliste, Issue #29).
//
// Das eigentliche Geofencing (Benachrichtigung bei geschlossener App) läuft
// komplett nativ — siehe ShoppingReminderBridge. Diese Klasse übernimmt nur
// den Permission-Flow + das Auflösen EINES neuen Standorts für die
// "Standort hinzufügen"-Sheet in den Settings.
// ---------------------------------------------------------------------------

enum ShoppingReminderPermissionStatus {
  /// "Immer erlauben" — Geofences feuern auch bei komplett geschlossener App.
  grantedAlways,

  /// Nur "Bei Nutzung" — Geofences funktionieren nicht zuverlässig, wenn die
  /// App nicht läuft. Muss der Nutzer über die System-Einstellungen upgraden.
  grantedWhileInUseOnly,
  denied,
  deniedForever,
  serviceDisabled,
}

class ShoppingReminderLocationService {
  const ShoppingReminderLocationService();

  /// Fordert (wenn nötig) die Standort-Berechtigung an und versucht, sie bis
  /// auf "Immer erlauben" hochzustufen — nötig, damit Geofences auch bei
  /// geschlossener App feuern. Auf Android ab API 30 zeigt das System dafür
  /// i. d. R. keinen direkten Dialog mehr; der Aufrufer muss dann über die
  /// Einstellungen leiten (siehe [openAppSettings]).
  Future<ShoppingReminderPermissionStatus> ensureAlwaysPermission() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return ShoppingReminderPermissionStatus.serviceDisabled;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return ShoppingReminderPermissionStatus.deniedForever;
    }
    if (permission == LocationPermission.denied) {
      return ShoppingReminderPermissionStatus.denied;
    }
    if (permission == LocationPermission.always) {
      return ShoppingReminderPermissionStatus.grantedAlways;
    }
    // whileInUse: zweiten Anlauf versuchen — iOS zeigt hier den "Immer
    // erlauben"-Systemdialog; Android liefert ab API 30 weiterhin nur
    // whileInUse zurück (kein Inline-Upgrade möglich).
    final upgraded = await Geolocator.requestPermission();
    return upgraded == LocationPermission.always
        ? ShoppingReminderPermissionStatus.grantedAlways
        : ShoppingReminderPermissionStatus.grantedWhileInUseOnly;
  }

  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  /// Steht die Berechtigung (noch) auf „Immer"? Nur prüfen, nicht fragen —
  /// für den Start-Check, ob die Erinnerung bei geschlossener App überhaupt
  /// feuern kann (Nutzer oder iOS können „Immer" später zurücknehmen).
  Future<bool> hasAlwaysPermission() async {
    try {
      return await Geolocator.isLocationServiceEnabled() &&
          await Geolocator.checkPermission() == LocationPermission.always;
    } catch (_) {
      return true; // im Zweifel nicht warnen
    }
  }

  Future<ShoppingReminderLocation> currentLocation({
    required String id,
    required String name,
  }) async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    return ShoppingReminderLocation(
      id: id,
      name: name,
      latitude: pos.latitude,
      longitude: pos.longitude,
    );
  }

  /// null = Adresse konnte nicht aufgelöst werden.
  Future<ShoppingReminderLocation?> geocodeAddress({
    required String id,
    required String name,
    required String address,
  }) async {
    final results = await geocoding.Geocoding().locationFromAddress(address);
    if (results.isEmpty) return null;
    final first = results.first;
    return ShoppingReminderLocation(
      id: id,
      name: name,
      latitude: first.latitude,
      longitude: first.longitude,
    );
  }
}
