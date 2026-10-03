import 'dart:io';
import 'dart:ui' show Rect;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'log_manager.dart';

// ---------------------------------------------------------------------------
// SupportMailService — Support-Kontakt aus den Einstellungen heraus.
//
// Zwei Wege, weil kein einzelner beides kann:
//   • `mailto:` (url_launcher) füllt Empfänger, Betreff und Text vor, kann
//     aber KEINE Dateien anhängen.
//   • Das System-Share-Sheet (share_plus) hängt die Logdatei an, kennt aber
//     kein Empfängerfeld — die Adresse wandert deshalb zusätzlich in die
//     Zwischenablage und in den Mailtext.
// ---------------------------------------------------------------------------

class SupportMailService {
  SupportMailService._();

  static const String supportAddress = 'walfrosch92@gmail.com';

  /// Diagnose-Kopf: identifiziert Version und Gerät, ohne Server-URL oder
  /// Token preiszugeben — die stehen im Log nur, wenn der Nutzer sie bewusst
  /// mitschickt.
  static Future<String> diagnostics(String languageCode) async {
    final info = await PackageInfo.fromPlatform();
    final os = Platform.operatingSystem;
    final osVersion = Platform.operatingSystemVersion;
    return [
      'App: ${info.appName} ${info.version} (${info.buildNumber})',
      'System: $os $osVersion',
      'Sprache: $languageCode',
    ].join('\n');
  }

  /// Mailtext mit Diagnose-Kopf und Platz für die Beschreibung des Problems.
  static Future<String> _body(String languageCode, String hintLine) async {
    final head = await diagnostics(languageCode);
    return '$hintLine\n\n\n---\n$head\n';
  }

  /// Öffnet die Mail-App mit vorausgefülltem Empfänger, Betreff und Text.
  /// Gibt `false` zurück, wenn keine Mail-App reagiert — der Aufrufer zeigt
  /// dann die Adresse zum manuellen Kopieren an.
  static Future<bool> openMailApp({
    required String subject,
    required String languageCode,
    required String hintLine,
  }) async {
    final body = await _body(languageCode, hintLine);
    // Query von Hand kodieren: Uri(queryParameters:) macht aus Leerzeichen ein
    // "+", das viele Mail-Clients wörtlich in den Betreff übernehmen.
    final query = {'subject': subject, 'body': body}
        .entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    final uri = Uri.parse('mailto:$supportAddress?$query');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Schreibt die Logs als .txt in den Temp-Ordner und öffnet das Share-Sheet,
  /// damit der Nutzer sie an eine Mail (oder einen anderen Kanal) anhängen
  /// kann. [sharePositionOrigin] verhindert den iPad-Absturz des Popovers.
  static Future<void> shareLogs({
    required String subject,
    required String languageCode,
    required String hintLine,
    Rect? sharePositionOrigin,
  }) async {
    final head = await diagnostics(languageCode);
    final logs = LogManager.shared.getLogs();
    final dir = await getTemporaryDirectory();
    // Fester Dateiname: der Anhang heißt im Postfach immer gleich und alte
    // Exporte sammeln sich nicht im Temp-Ordner an.
    final file = File('${dir.path}/mealie-recipes-logs.txt');
    await file.writeAsString('$head\n\n${'-' * 40}\n\n$logs\n');
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/plain')],
      subject: subject,
      text: '$hintLine\n\n$supportAddress\n\n---\n$head\n',
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
