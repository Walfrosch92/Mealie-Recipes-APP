import 'dart:ui' show Color;

final RegExp _kHex = RegExp(r'^[0-9A-F]+$');

/// Normalisiert eine Label-Farbe von Mealie auf `RRGGBB` (Großbuchstaben,
/// ohne `#`). Mealie (Vuetify-Farbwähler, CSS-Notation) speichert teils
/// `#RRGGBBAA` — der Alpha-Anteil steht dort HINTEN, nicht vorne wie bei
/// Flutters ARGB. Ungültige Werte → `null`.
String? normalizeHexRgb(String? raw) {
  if (raw == null) return null;
  var h = raw.trim().toUpperCase();
  if (h.startsWith('#')) h = h.substring(1);
  if (h.length == 8) h = h.substring(0, 6);
  return h.length == 6 && _kHex.hasMatch(h) ? h : null;
}

/// Label-Farbe → deckende [Color]; ungültige Werte → `null`.
Color? colorFromHex(String? raw) {
  final h = normalizeHexRgb(raw);
  return h == null ? null : Color(0xFF000000 | int.parse(h, radix: 16));
}
