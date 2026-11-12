import '../models/app_settings.dart';
import 'auth_headers.dart';

// ---------------------------------------------------------------------------
// Mealie-Medien-URLs + Header für Bilder/Dateien, die nicht über ApiService
// (Dio) geladen werden (CachedNetworkImage, Vollbild-Viewer).
// ---------------------------------------------------------------------------

/// Auth- und optionale Zusatz-Header (Reverse-Proxy o. ä.) für Medien.
Map<String, String> mediaHeaders(AppSettings? s) => {
      if ((s?.apiToken ?? '').isNotEmpty)
        'Authorization': 'Bearer ${s!.apiToken}',
      ...?s?.optionalHeaders,
    };

/// Header für eine beliebige Bild-URL: Token + optionale Zusatz-Header, aber
/// NUR wenn [url] auf den eigenen Server zeigt (fremde Bild-Hosts bekommen
/// weder Token noch z. B. Cloudflare-Access-Secrets).
Map<String, String>? ownServerHeaders(String url, AppSettings? s) => s == null
    ? null
    : authHeadersFor(url, s.serverUrl, s.apiToken, extra: s.optionalHeaders);

/// Cache-Schlüssel für Medien des eigenen Servers OHNE Host — nur bei
/// eingerichteter WLAN-Umschaltung: dieselben Bilder kommen dann je nach Netz
/// über zwei Adressen, ohne eigenen Schlüssel würde nach jedem Wechsel alles
/// neu geladen. Sonst `null` (= URL, wie bisher; bestehender Cache bleibt).
String? mediaCacheKey(String url, AppSettings? s) {
  if (s == null || !s.hasWifiServer) return null;
  final i = url.indexOf('/api/media/');
  return i < 0 ? null : url.substring(i);
}

/// [base] (vom Aufrufer) + [ownServerHeaders]; `null` wenn leer.
Map<String, String>? mergeMediaHeaders(
    Map<String, String>? base, String url, AppSettings? s) {
  final merged = {...?base, ...?ownServerHeaders(url, s)};
  return merged.isEmpty ? null : merged;
}

/// Foto eines Zeitleisten-Eintrags. [size]: `original`, `min-original`
/// (mittel) oder `tiny-original`.
String timelineImageUrl(String serverUrl, String recipeId, String eventId,
        {String size = 'min-original'}) =>
    '$serverUrl/api/media/recipes/$recipeId/images/timeline/$eventId/$size.webp';

/// Datei eines Rezept-Anhangs.
String recipeAssetUrl(String serverUrl, String recipeId, String fileName) =>
    '$serverUrl/api/media/recipes/$recipeId/assets/${Uri.encodeComponent(fileName)}';

/// Relativer Pfad (für ApiService.downloadToFile).
String recipeAssetPath(String recipeId, String fileName) =>
    '/api/media/recipes/$recipeId/assets/${Uri.encodeComponent(fileName)}';
