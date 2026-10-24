// ---------------------------------------------------------------------------
// Anmelde-Header NUR für den eigenen Mealie-Server. Bilder in Rezepttexten
// können auf fremde Seiten zeigen (verlinkte Schrittbilder) — dorthin darf
// der API-Token nie gehen. Pfadgrenze beachten: „https://srv.de.evil.com"
// ist kein Präfix-Treffer für „https://srv.de".
// ---------------------------------------------------------------------------

Map<String, String>? authHeadersFor(
    String url, String serverUrl, String apiToken) {
  var base = serverUrl.trim();
  while (base.endsWith('/')) {
    base = base.substring(0, base.length - 1);
  }
  final own = base.isNotEmpty &&
      apiToken.isNotEmpty &&
      (url == base || url.startsWith('$base/'));
  return own ? {'Authorization': 'Bearer $apiToken'} : null;
}
