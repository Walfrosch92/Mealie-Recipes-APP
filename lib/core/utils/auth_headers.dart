// ---------------------------------------------------------------------------
// Anmelde-Header NUR für den eigenen Mealie-Server. Bilder in Rezepttexten
// können auf fremde Seiten zeigen (verlinkte Schrittbilder) — dorthin darf
// der API-Token nie gehen. Pfadgrenze beachten: „https://srv.de.evil.com"
// ist kein Präfix-Treffer für „https://srv.de".
// ---------------------------------------------------------------------------

Map<String, String>? authHeadersFor(
    String url, String serverUrl, String apiToken,
    {Map<String, String> extra = const {}}) {
  var base = serverUrl.trim();
  while (base.endsWith('/')) {
    base = base.substring(0, base.length - 1);
  }
  final own = base.isNotEmpty && (url == base || url.startsWith('$base/'));
  if (!own) return null;
  // [extra] = optionale Zusatz-Header aus den Einstellungen (z. B.
  // Cloudflare-Access): ohne sie lädt ein Reverse-Proxy keine Bilder
  // (Issue #38). Wie der Token NUR an den eigenen Server.
  final headers = <String, String>{
    if (apiToken.isNotEmpty) 'Authorization': 'Bearer $apiToken',
    ...extra,
  };
  return headers.isEmpty ? null : headers;
}
