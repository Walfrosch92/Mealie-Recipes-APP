/// Dateiname/ID vom Server als EIN Pfadsegment: keine Verzeichnis-Trenner,
/// kein führendes „.". Sonst könnte ein (z. B. in Mealie frei setzbarer)
/// Anhang-Name wie „../../…" Dateien außerhalb des vorgesehenen Ordners
/// überschreiben.
String safePathSegment(String raw) {
  var s = raw.replaceAll(RegExp(r'[/\\\x00]'), '_').trim();
  while (s.startsWith('.')) {
    s = s.substring(1);
  }
  return s.isEmpty ? 'file' : s;
}
