import '../models/recipe_detail.dart';

// ---------------------------------------------------------------------------
// Rezeptsuche — gemeinsame Logik für Rezeptliste, Mahlzeitenplan, Kochmodus
// („Rezept hinzufügen") und Kochen mit Freunden.
//
// Vorher: `name.toLowerCase().contains(query.toLowerCase())`. Das scheiterte
// an Namen, die unsichtbare Zeichen enthalten — typisch nach Copy & Paste
// aus Webseiten oder dem KI-Import: geschütztes Leerzeichen (U+00A0),
// weiches Trennzeichen (U+00AD), Zero-Width-Zeichen. „Lasagne Bolognese" sah
// normal aus, wurde aber mit „lasagne bolognese" nicht gefunden. Außerdem
// musste der Suchtext als EIN Stück vorkommen („Bolognese Lasagne" fand
// nichts).
//
// Jetzt: beide Seiten normalisieren (Groß/Klein, Akzente, ß, unsichtbare
// Zeichen, Leerraum) und JEDES Suchwort muss irgendwo vorkommen.
// ---------------------------------------------------------------------------

final _invisible = RegExp('[­​‌‍⁠﻿]');
final _whitespace = RegExp(r'[\s   ]+');

const _foldMap = {
  'à': 'a',
  'á': 'a',
  'â': 'a',
  'ã': 'a',
  'å': 'a',
  'ā': 'a',
  'ą': 'a',
  'ä': 'a',
  'ç': 'c',
  'ć': 'c',
  'č': 'c',
  'ď': 'd',
  'đ': 'd',
  'è': 'e',
  'é': 'e',
  'ê': 'e',
  'ë': 'e',
  'ē': 'e',
  'ę': 'e',
  'ě': 'e',
  'ì': 'i',
  'í': 'i',
  'î': 'i',
  'ï': 'i',
  'ł': 'l',
  'ñ': 'n',
  'ń': 'n',
  'ň': 'n',
  'ò': 'o',
  'ó': 'o',
  'ô': 'o',
  'õ': 'o',
  'ö': 'o',
  'ø': 'o',
  'ő': 'o',
  'ř': 'r',
  'ś': 's',
  'š': 's',
  'ß': 'ss',
  'ť': 't',
  'ù': 'u',
  'ú': 'u',
  'û': 'u',
  'ü': 'u',
  'ů': 'u',
  'ű': 'u',
  'ý': 'y',
  'ÿ': 'y',
  'ź': 'z',
  'ż': 'z',
  'ž': 'z',
  'æ': 'ae',
  'œ': 'oe',
};

/// Vergleichbare Form eines Textes: klein, ohne Akzente/unsichtbare Zeichen,
/// Leerraum zu einfachen Leerzeichen zusammengefasst.
String normalizeForSearch(String text) {
  final lower = text.toLowerCase().replaceAll(_invisible, '');
  final buf = StringBuffer();
  for (final rune in lower.runes) {
    final ch = String.fromCharCode(rune);
    buf.write(_foldMap[ch] ?? ch);
  }
  return buf.toString().replaceAll(_whitespace, ' ').trim();
}

/// Einzelne Suchwörter der Eingabe (normalisiert, leer = alles passt).
List<String> searchTerms(String query) {
  final n = normalizeForSearch(query);
  return n.isEmpty ? const [] : n.split(' ');
}

/// true, wenn JEDES Suchwort in Name oder Beschreibung vorkommt.
bool recipeMatchesSearch(RecipeDetail recipe, List<String> terms,
    {bool includeDescription = true}) {
  if (terms.isEmpty) return true;
  final haystack = normalizeForSearch(includeDescription
      ? '${recipe.name} ${recipe.description ?? ''}'
      : recipe.name);
  return terms.every(haystack.contains);
}
