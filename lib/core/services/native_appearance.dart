import 'dart:io' show Platform;

import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// Gibt das in der App gewählte Farbschema an iOS weiter (Kanal
// `mealie/appearance`, AppDelegate). Sonst richten sich native Fenster —
// Teilen-Blatt, Foto-/Dateiauswahl, In-App-Browser, Mail — nach dem
// System-Schema: z. B. helles Teilen-Blatt über der dunkel gestellten App.
// ---------------------------------------------------------------------------

class NativeAppearance {
  static const _channel = MethodChannel('mealie/appearance');
  static String? _last;

  /// [mode]: 'system' | 'light' | 'dark'. Mehrfachaufrufe mit demselben Wert
  /// sind billig (nur beim Wechsel geht etwas über den Kanal).
  static void apply(String? mode) {
    if (!Platform.isIOS || mode == _last) return;
    _last = mode;
    _channel.invokeMethod('setStyle', mode ?? 'system').catchError((_) => null);
  }
}
