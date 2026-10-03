import '../models/app_settings.dart';

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
