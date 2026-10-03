import 'dart:io' show Platform;

import 'package:flutter/widgets.dart';

// ---------------------------------------------------------------------------
// Welche Funktion gibt es auf welcher Plattform? Die App ist für iOS/Android
// gebaut; unter Windows/macOS (Desktop) fehlen einige Pakete bzw. die
// Hardware oder die native Anbindung (Widgets, Geofence, Erinnerungen …).
// Nicht verfügbare Funktionen werden dort AUSGEBLENDET statt ins Leere zu
// laufen — alle Weichen dafür stehen hier, damit sie an EINER Stelle
// nachvollziehbar bleiben.
// ---------------------------------------------------------------------------

class PlatformFeatures {
  PlatformFeatures._();

  static bool get isMobile => Platform.isIOS || Platform.isAndroid;

  /// Lokale Benachrichtigungen (Timer-Ablauf) — flutter_local_notifications
  /// 17.x hat keine Windows-Umsetzung.
  static bool get notifications => isMobile;

  /// Alarmton der Timer (just_audio: kein Windows).
  static bool get alarmSound => isMobile;

  /// „Erinnere mich zum Einkaufen" (Geofence + Adresssuche: nur mobil).
  static bool get shoppingReminder => isMobile;

  /// Kamera als Bildquelle (image_picker: unter Windows nur Dateien).
  static bool get camera => isMobile;

  /// Import aus Apple Erinnerungen (iOS) bzw. Google Tasks (Android —
  /// google_sign_in hat keine Windows-Umsetzung).
  static bool get taskImport => isMobile;

  /// Webapp-Werkzeuge (Massenimport, ZIP-Import, Migrationen, Berichte,
  /// Rezeptdaten-Massenaktionen, Duplizieren, Freigabe-Links, Rezept-Export,
  /// Webhooks, Benachrichtigungen, Rezept-Aktionen, Administration) — auf
  /// User-Wunsch nur in den Desktop-Apps (Windows/macOS), die damit zum
  /// vollständigen Mealie-Webapp-Client werden.
  static bool get webAppTools => Platform.isWindows || Platform.isMacOS;
}

// ---------------------------------------------------------------------------
// Große Anzeige (nur Desktop: Windows + macOS): Das Fenster ist frei
// skalierbar und oft maximiert auf einem Monitor. Ab [minWidth] nutzen die Hauptscreens die
// Breite (mehrspaltige Kacheln/Rezeptkarten, höheres Vorschlagsbild,
// zentrierte Lesespalte). iOS/Android bleiben unverändert — dort liefert
// [isWide] immer false.
// ---------------------------------------------------------------------------

class LargeScreen {
  LargeScreen._();

  /// Ab dieser Fensterbreite gilt das Layout als „groß".
  static const double minWidth = 840;

  /// Gesamte App höchstens so breit (Ultrawide/4K: zentriert, sonst ziehen
  /// sich Leisten und Zeilen endlos in die Breite).
  static const double maxAppWidth = 1600;

  /// Lesespalte für textlastige Inhalte (Rezeptdetail).
  static const double readableWidth = 920;

  static bool get _desktop => Platform.isWindows || Platform.isMacOS;

  static bool isWide(BuildContext context) =>
      _desktop && MediaQuery.sizeOf(context).width >= minWidth;

  /// Seitlicher Einzug, der Inhalte auf großer Anzeige auf [maxWidth]
  /// zentriert — nie kleiner als [base] (der mobile Rand). Mobil: [base].
  static double inset(BuildContext context,
      {double base = 0, double maxWidth = readableWidth}) {
    if (!isWide(context)) return base;
    final side = (MediaQuery.sizeOf(context).width - maxWidth) / 2;
    return side > base ? side : base;
  }

  /// Spaltenzahl für die Home-/„Weiteres"-Kacheln.
  static int tileColumns(BuildContext context) {
    if (!isWide(context)) return 2;
    return MediaQuery.sizeOf(context).width >= 1200 ? 4 : 3;
  }

  /// Höhe des „Heute kochen"-Vorschlagsbilds auf dem Startbildschirm.
  static double heroHeight(BuildContext context, double mobile) {
    if (!isWide(context)) return mobile;
    return (MediaQuery.sizeOf(context).width * 0.32).clamp(320.0, 460.0);
  }
}
