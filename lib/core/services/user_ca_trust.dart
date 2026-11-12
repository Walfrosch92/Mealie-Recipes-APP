import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'log_manager.dart';

// ---------------------------------------------------------------------------
// Eigene CA auf Android (Selfhosting).
//
// dart:io prüft TLS mit BoringSSL gegen die System-CAs von Android, kennt aber
// die vom Nutzer installierten CA-Zertifikate („Verschlüsselung & Anmelde-
// daten → CA-Zertifikat") NICHT → `CERTIFICATE_VERIFY_FAILED: unable to get
// local issuer certificate`, obwohl andere Apps den Server erreichen.
//
// MainActivity liest genau diese Nutzer-CAs aus dem AndroidCAStore und wir
// fügen sie dem Standard-SecurityContext hinzu. Der gilt für jeden
// HttpClient ohne eigenen Kontext — Dio, Bilder (cached_network_image),
// Updater. Es wird nur dem vertraut, was der Nutzer selbst ins System
// installiert hat; kein „alles akzeptieren".
//
// iOS/macOS: Dart prüft dort über das System (SecTrust) — installierte und
// aktivierte Profile werden schon berücksichtigt, nichts zu tun.
// ---------------------------------------------------------------------------

class UserCaTrust {
  UserCaTrust._();

  static const _channel = MethodChannel('mealie/user_ca');
  static bool _installed = false;

  static Future<void> install() async {
    if (_installed || !Platform.isAndroid) return;
    _installed = true;
    try {
      final pems = await _channel
              .invokeListMethod<String>('userCaCertificates')
              .timeout(const Duration(seconds: 3)) ??
          const <String>[];
      var added = 0;
      for (final pem in pems) {
        try {
          SecurityContext.defaultContext
              .setTrustedCertificatesBytes(utf8.encode(pem));
          added++;
        } catch (_) {
          // Unlesbares/doppeltes Zertifikat überspringen, Rest weiter laden.
        }
      }
      if (added > 0) {
        LogManager.shared.log('🔐 $added eigene CA-Zertifikat(e) übernommen');
      }
    } catch (e) {
      LogManager.shared.log('⚠️ Eigene CA-Zertifikate nicht lesbar: $e');
    }
  }
}
