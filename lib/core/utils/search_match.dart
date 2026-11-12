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

final _wordStart = RegExp(r'[\s\-(/,&+*]');

/// Wie gut passt [name] zur Suche? Kleiner = besser:
/// 0 = genau gleich, 1 = beginnt damit, 2 = ein Wort darin beginnt damit,
/// 3 = kommt nur irgendwo vor (oder passt nur über Alias/Beschreibung).
/// „Sal“ → „Salz“ (1) vor „Erdnüsse gesalzen“ (3).
int searchRank(String name, List<String> terms) {
  if (terms.isEmpty) return 0;
  final n = normalizeForSearch(name);
  final q = terms.join(' ');
  if (n == q) return 0;
  if (n.startsWith(q)) return 1;
  for (final m in _wordStart.allMatches(n)) {
    if (n.startsWith(q, m.end)) return 2;
  }
  return 3;
}

/// Treffer nach [searchRank] ordnen; innerhalb derselben Stufe bleibt die
/// bisherige Reihenfolge (meist alphabetisch) erhalten.
List<T> rankBySearch<T>(
    Iterable<T> items, List<String> terms, String Function(T) nameOf) {
  final list = items.toList();
  if (terms.isEmpty) return list;
  final ranks = [for (final i in list) searchRank(nameOf(i), terms)];
  final idx = List<int>.generate(list.length, (i) => i)
    ..sort((a, b) {
      final c = ranks[a].compareTo(ranks[b]);
      return c != 0 ? c : a.compareTo(b);
    });
  return [for (final i in idx) list[i]];
}

/// Wo passt die Suche zu einem Rezept? 0 = im Namen, 1 = in Beschreibung,
/// Schlagworten oder Kategorien, 2 = nur in den Zutaten (Lebensmittel bzw.
/// Zutatentext), `null` = gar nicht. Jedes Suchwort muss in DERSELBEN
/// Stufe oder einer davor vorkommen — so findet „Olivenöl nativ“ das Rezept
/// mit dieser Zutat, sortiert aber Namenstreffer nach vorne.
int? recipeSearchTier(RecipeDetail r, List<String> terms) {
  if (terms.isEmpty) return 0;
  final (name, meta, all) = _recipeHay(r);
  if (terms.every(name.contains)) return 0;
  if (terms.every(meta.contains)) return 1;
  if (terms.every(all.contains)) return 2;
  return null;
}

// Normalisierte Suchtexte je Rezept-Objekt merken: die Liste wird bei jedem
// Tastendruck neu gefiltert, Zutatentexte von Tausenden Rezepten jedes Mal
// neu aufzubereiten wäre spürbar. Ein geändertes Rezept ist ein neues Objekt.
final _hayCache = Expando<(String, String, String)>();

(String, String, String) _recipeHay(RecipeDetail r) => _hayCache[r] ??= () {
      final name = normalizeForSearch(r.name);
      final meta = normalizeForSearch([
        r.name,
        r.description ?? '',
        for (final t in r.tags) t.name,
        for (final c in r.recipeCategory) c.name,
      ].join(' '));
      final all = normalizeForSearch([
        meta,
        for (final i in r.recipeIngredient) ...[
          i.food?.name ?? '',
          i.food?.pluralName ?? '',
          i.note ?? '',
          i.originalText ?? '',
        ],
      ].join(' '));
      return (name, meta, all);
    }();

/// Rezepte nach Suchstufe filtern und ordnen (Namenstreffer zuerst);
/// innerhalb einer Stufe bleibt die bisherige Sortierung.
List<RecipeDetail> searchRecipesTiered(
    Iterable<RecipeDetail> recipes, List<String> terms) {
  if (terms.isEmpty) return recipes.toList();
  final buckets = [<RecipeDetail>[], <RecipeDetail>[], <RecipeDetail>[]];
  for (final r in recipes) {
    final t = recipeSearchTier(r, terms);
    if (t != null) buckets[t].add(r);
  }
  return [...buckets[0], ...buckets[1], ...buckets[2]];
}
