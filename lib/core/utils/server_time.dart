/// Mealie-Zeitstempel → lokale Zeit. Mealie speichert UTC, liefert sie aber
/// je nach Feld/Version OHNE Zeitzonen-Angabe („2026-10-07T21:30:00") —
/// `DateTime.parse` hielte das für Ortszeit (um 1–2 h verschoben, nach
/// Mitternacht sogar falscher Tag). Ohne Angabe also als UTC lesen.
/// Reine Datumswerte („2026-10-07") bleiben ein lokales Datum.
DateTime? parseMealieTime(String? raw) {
  final s = raw?.trim() ?? '';
  if (s.isEmpty) return null;
  if (!s.contains('T') && !s.contains(' ')) return DateTime.tryParse(s);
  final hasZone = s.endsWith('Z') || RegExp(r'[+-]\d\d:?\d\d$').hasMatch(s);
  return DateTime.tryParse(hasZone ? s : '${s}Z')?.toLocal();
}
