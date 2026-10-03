import 'dart:io';

import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// AppIconService — Wrapper um den nativen `mealie/appicon`-MethodChannel
// (iOS-only). Erlaubt den Wechsel zwischen dem primären „Classic"-Icon
// (AppIcon) und dem alternativen „Modern"-Icon (AppIcon2). 1:1 zur Swift-
// Vorgängerversion (UIApplication.setAlternateIconName).
//
// Android/Desktop haben kein Alternate-Icon-Konzept → alle Aufrufe sind no-ops
// bzw. liefern false/null.
// ---------------------------------------------------------------------------

class AppIconService {
  static const _channel = MethodChannel('mealie/appicon');

  /// Identifier des alternativen Icons im Asset-Catalog (AppIcon2.appiconset).
  static const modernIconName = 'AppIcon2';

  AppIconService._();

  static bool get _supported => Platform.isIOS;

  /// Unterstützt das Gerät alternative Icons? (iOS 10.3+: ja; iPad ggf. nein.)
  static Future<bool> supportsAlternateIcons() async {
    if (!_supported) return false;
    try {
      return await _channel.invokeMethod<bool>('supportsAlternateIcons') ??
          false;
    } catch (_) {
      return false;
    }
  }

  /// Aktueller Icon-Name: null = primäres „Classic"-Icon, "AppIcon2" = Modern.
  static Future<String?> currentIconName() async {
    if (!_supported) return null;
    try {
      return await _channel.invokeMethod<String?>('getAlternateIconName');
    } catch (_) {
      return null;
    }
  }

  /// true wenn aktuell das Modern-Icon (AppIcon2) aktiv ist.
  static Future<bool> isModernActive() async =>
      (await currentIconName()) == modernIconName;

  /// Setzt das Icon. `modern == true` → AppIcon2, sonst primäres Icon.
  /// Wirft bei Fehler (z. B. nicht unterstützt) — Aufrufer fängt das ab.
  static Future<void> setModern(bool modern) async {
    if (!_supported) return;
    await _channel.invokeMethod('setAlternateIcon', {
      'name': modern ? modernIconName : null,
    });
  }
}
