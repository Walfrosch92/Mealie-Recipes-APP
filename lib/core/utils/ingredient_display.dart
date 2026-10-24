import 'dart:io' show Platform;

import 'package:flutter/services.dart' show TextInputType;

import '../models/recipe_detail.dart';

// ---------------------------------------------------------------------------
// Skalierte Zutaten-Anzeige — extrahiert aus RecipeDetailScreen
// (_IngredientsContent), damit PDF-Export und Detail-Screen dieselbe Logik
// nutzen statt sie zu duplizieren. Mirrors iOS RecipeDetailView.scaledNote(for:).
// ---------------------------------------------------------------------------

// Gängige Koch-Brüche — Mealie speichert z. B. ¼ tsp als 0.25, ⅛ tsp als
// 0.125. Ohne Snapping zeigt toStringAsFixed(1) daraus "0.3"/"0.1" (falsch
// gerundet) statt der Brüche, mit denen tatsächlich gekocht wird.
//
// AUFSTEIGEND sortiert (wichtig für die "< Bruch"-Fallback-Suche unten, die
// den ERSTEN — also kleinsten passenden — Kandidaten über dem Wert sucht).
// Enthält bewusst auch Fünftel/Sechstel/Zehntel (nicht nur Halbe/Viertel/
// Achtel/Drittel) — Rezepte mit krummen Portionsteilern (z. B. Mealie-Web
// zeigt hier "⅙") landen sonst wieder als falsch gerundete Dezimalzahl.
final _fractionCandidates = <(double, String)>[
  // Kein Unicode-Glyph für Sechzehntel → als Text (ganze Zahl: „1 1/16").
  (0.0625, '1/16'),
  (0.1, '⅒'),
  (0.125, '⅛'),
  (0.1667, '⅙'),
  (0.2, '⅕'),
  (0.25, '¼'),
  (0.3333, '⅓'),
  (0.375, '⅜'),
  (0.4, '⅖'),
  (0.5, '½'),
  (0.6, '⅗'),
  (0.625, '⅝'),
  (0.6667, '⅔'),
  (0.75, '¾'),
  (0.8, '⅘'),
  (0.8333, '⅚'),
  (0.875, '⅞'),
];

String formatQuantity(double q) {
  // Auf 3 Nachkommastellen runden, BEVOR auf Ganzzahligkeit geprüft wird:
  // Multiplikatoren aus einer eingegebenen/gesteppten Zielportionenzahl
  // (siehe _PortionStepper) sind i. Allg. keine exakten Binärbrüche — 6 × (4/6)
  // ergibt in double-Arithmetik 3.9999999999999996 statt 4.0, ohne Rundung
  // würde das fälschlich "4.0" statt "4" anzeigen. 3 statt 2 Nachkommastellen,
  // damit Sechstel/Zehntel (0.1667/0.8333) nicht vorzeitig verfälscht werden.
  final clean = double.parse(q.toStringAsFixed(3));
  if (clean == clean.truncateToDouble()) return clean.truncate().toString();
  final whole = clean.truncate();
  final frac = clean - whole;

  // 1) Exakter Treffer (enge Toleranz) → reiner Bruch-Glyph.
  for (final (value, glyph) in _fractionCandidates) {
    if ((frac - value).abs() < 0.015) {
      return whole > 0 ? '$whole${_joiner(glyph)}$glyph' : glyph;
    }
  }
  // 2) Kein exakter Treffer, aber knapp UNTER einem bekannten Bruch (z. B.
  //    eine sehr kleine, krumme Ölmenge zum Einfetten) → "< Bruch" statt
  //    einer irreführend präzise wirkenden Dezimalzahl, mirrors Mealie-Web
  //    ("< 1/10" statt "0.1"). Kandidaten sind aufsteigend sortiert, der
  //    ERSTE mit value > frac ist der kleinste (= aussagekräftigste)
  //    Kandidat — liegt schon der zu weit weg, bringt ein größerer auch
  //    nichts mehr, also sofort abbrechen statt weitersuchen.
  for (final (value, glyph) in _fractionCandidates) {
    if (frac < value) {
      if (value - frac < 0.03) {
        return '< ${whole > 0 ? '$whole${_joiner(glyph)}$glyph' : glyph}';
      }
      break;
    }
  }
  // Bis zu 2 Nachkommastellen (0,65 statt gerundet „0.7"); Nullen am Ende
  // weg. Vorher immer 1 Stelle — Nutzer-Feedback: „.75 wird zu .8".
  return clean
      .toStringAsFixed(2)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

/// Koch-Brüche, die als Bruch (nicht als Dezimalzahl) behandelt werden.
const _cookingDenominators = [2, 3, 4, 8, 16];

/// Passt [frac] zu n/den? Exakt (Float-Toleranz) ODER als auf 2 Stellen
/// gerundeter Bruch — so speicherten ältere App-Versionen Rezept-Mengen in
/// der Einkaufsliste (⅛ → 0.13, 1/16 → 0.06, ⅓ → 0.33). Eine bewusst
/// getippte 0.32 trifft dagegen keinen Bruch (5/16 wäre 0.31).
bool _fracMatches(double frac, int n, int den) =>
    (frac - n / den).abs() < 0.002 ||
    (frac * 100).round() == (n / den * 100).round();

/// Bruchteil von [frac] als (Zähler, Nenner), oder null.
(int, int)? _matchFraction(double frac) {
  for (final den in _cookingDenominators) {
    final n = (frac * den).round();
    if (n > 0 && n < den && _fracMatches(frac, n, den)) return (n, den);
  }
  return null;
}

/// Nenner eines Koch-Bruchs in [q] (2, 3, 4, 8, 16), 1 bei ganzen Zahlen,
/// `null` bei sonstigen Dezimalwerten (z. B. 0,55).
int? quantityDenominator(double q) {
  final frac = q - q.truncate();
  if (frac.abs() < 1e-6 || (1 - frac).abs() < 1e-6) return 1;
  return _matchFraction(frac)?.$2;
}

/// Menge zum SPEICHERN (z. B. skalierte Rezeptmenge → Einkaufsliste):
/// Koch-Brüche exakt (⅛ = 0.125, nicht 0.13), Float-Reste aus
/// Portions-Multiplikatoren weg (3.9999999 → 4), sonst 2 Nachkommastellen.
double snapQuantity(double q) {
  final whole = q.truncate();
  final frac = q - whole;
  final m = _matchFraction(frac);
  if (m != null) return whole + m.$1 / m.$2;
  return double.parse(q.toStringAsFixed(2));
}

/// Feinste Schrittweite für +/- : der feinere der beiden Nenner (bisher
/// gemerkter [current] und der von [q]) — so bleibt eine Zeile, die mit ⅛
/// begann, bei Achteln, auch wenn sie zwischendurch ganz (1) wird.
int stepDenominatorFor(double q, int current) {
  final d = quantityDenominator(q);
  if (d == null) return current;
  // ¼ in einer Achtel-Zeile bleibt Achtel; ein fremder Bruch (⅓ nach ⅛,
  // vom Nutzer getippt) gibt das neue Raster vor.
  return current % d == 0 ? current : d;
}

/// Ein Schritt +/- in Einheiten von 1/[den] (gerastert, keine Float-Reste).
/// Ohne Bruch-Raster (den == 1) wie bisher ganze Schritte; unter 1 geht
/// Minus auf 0. Ergebnis nie negativ.
double stepQuantity(double q, int direction, int den) {
  if (den <= 1) {
    if (direction > 0) return q + 1;
    return q > 1 ? q - 1 : 0;
  }
  final units = (q * den).round() + direction;
  return units <= 0 ? 0 : units / den;
}

/// Text-Brüche („1/16") brauchen ein Leerzeichen nach der ganzen Zahl
/// („1 1/16"), Glyphen nicht („1½").
String _joiner(String glyph) => glyph.contains('/') ? ' ' : '';

// ---------------------------------------------------------------------------
// Mengen-EINGABE (Einkaufsliste, Rezept-Editor): Brüche tippen und als Bruch
// wieder angezeigt bekommen. Mealie speichert nur Dezimalzahlen (⅛ = 0.125).
// ---------------------------------------------------------------------------

/// Tastatur für Mengenfelder — muss „/" (Brüche), Punkt und Komma bieten.
/// Die reine Zahlentastatur (`numberWithOptions`) hat kein „/".
/// iOS: „Zahlen & Satzzeichen" (datetime); sonst normale Tastatur (Android:
/// Ziffern + „/" auf der „?123"-Ebene; Desktop: Hardware-Tastatur).
TextInputType get quantityKeyboardType =>
    Platform.isIOS ? TextInputType.datetime : TextInputType.text;

const _inputGlyphs = <String, double>{
  '½': 1 / 2, '⅓': 1 / 3, '⅔': 2 / 3, '¼': 1 / 4, '¾': 3 / 4, //
  '⅕': 1 / 5, '⅖': 2 / 5, '⅗': 3 / 5, '⅘': 4 / 5, '⅙': 1 / 6, //
  '⅚': 5 / 6, '⅛': 1 / 8, '⅜': 3 / 8, '⅝': 5 / 8, '⅞': 7 / 8, //
  '⅒': 1 / 10,
};

/// „1/8" · „1 1/2" · „1½" · „⅛" · „0,5" · „1.5" → Zahl; leer/unlesbar → null.
double? parseQuantityInput(String text) {
  var t = text.trim().replaceAll(',', '.').replaceAll('⁄', '/');
  if (t.isEmpty) return null;
  var sum = 0.0;
  for (final g in _inputGlyphs.entries) {
    if (t.contains(g.key)) {
      sum += g.value;
      t = t.replaceAll(g.key, ' ').trim();
    }
  }
  final mixed =
      RegExp(r'^(?:(\d+(?:\.\d+)?)\s+)?(\d+(?:\.\d+)?)\s*/\s*(\d+(?:\.\d+)?)$')
          .firstMatch(t);
  if (mixed != null) {
    final whole = double.tryParse(mixed.group(1) ?? '0') ?? 0;
    final den = double.parse(mixed.group(3)!);
    if (den == 0) return null;
    return whole + double.parse(mixed.group(2)!) / den + sum;
  }
  if (t.isEmpty) return sum == 0 ? null : sum;
  final v = double.tryParse(t);
  return v == null ? null : v + sum;
}

/// Menge fürs EINGABEFELD: ganze Zahl ohne „.0", gängige Koch-Brüche
/// (Halbe, Drittel, Viertel, Achtel, Sechzehntel) als tippbarer Bruch
/// („1/8", „1 1/2"), sonst Dezimalzahl mit bis zu 3 Stellen. Andere Teiler
/// (Fünftel, Zehntel) bewusst nicht — „0,2" soll nicht zu „1/5" werden.
String formatQuantityInput(num? q) {
  if (q == null || q == 0) return '';
  final v = q.toDouble();
  final whole = v.truncate();
  final frac = v - whole;
  if (frac.abs() < 1e-9) return whole.toString();
  final m = _matchFraction(frac);
  if (m != null) {
    var (n, d) = m;
    while (n.isEven && d.isEven) {
      n ~/= 2;
      d ~/= 2;
    }
    return whole > 0 ? '$whole $n/$d' : '$n/$d';
  }
  return v
      .toStringAsFixed(3)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

/// Ab welcher (gerundeten) Menge Einheit/Zutat pluralisiert werden — auf 2
/// Nachkommastellen gerundet wie die Anzeige selbst (formatQuantity), sonst
/// könnte z. B. ein knapp über 1 liegender Float-Rest ("1.0000000004" aus
/// einem Portionen-Multiplikator) Plural anzeigen, obwohl die gerundete
/// Menge als "1" dargestellt wird. Gemeinsame Regel für Rezept- und
/// Einkaufslisten-Anzeige (Issue #32).
bool shouldPluralize(double q) => double.parse(q.toStringAsFixed(2)) > 1;

/// Wählt Plural- vs. Singularform: [pluralName], wenn [usePlural] und
/// vorhanden, sonst [singular] — z. B. wenn der Server für invariante
/// Einheiten wie "g"/"ml" keine Pluralform liefert.
String pluralize(String singular, String? pluralName, bool usePlural) =>
    usePlural && (pluralName?.isNotEmpty ?? false) ? pluralName! : singular;

/// Skaliert die führende Zahl in einem unstrukturierten Zutaten-Notentext,
/// der Rest bleibt unangetastet. Erkennt Ganzzahlen, "0,5"/"0.5"-Dezimalen
/// und einfache Brüche ("1/2") — sprach- und einheitenunabhängig.
String scaledNote(String? note, double multiplier) {
  if (note == null || note.trim().isEmpty) return '-';
  final trimmed = note.trim();
  final match =
      RegExp(r'^(\d+(?:[.,]\d+)?(?:/\d+(?:[.,]\d+)?)?)(.*)$', dotAll: true)
          .firstMatch(trimmed);
  if (match == null) return note; // keine führende Zahl → nichts zu skalieren
  final numberStr = match.group(1)!;
  final rest = match.group(2) ?? '';

  double? parsed;
  if (numberStr.contains('/')) {
    final parts = numberStr.split('/');
    final a = double.tryParse(parts[0].replaceAll(',', '.'));
    final b = parts.length == 2
        ? double.tryParse(parts[1].replaceAll(',', '.'))
        : null;
    if (a != null && b != null && b != 0) parsed = a / b;
  } else {
    parsed = double.tryParse(numberStr.replaceAll(',', '.'));
  }
  if (parsed == null) return note;
  return '${formatQuantity(parsed * multiplier)}$rest';
}

/// Menge einer Zutat wie Mealie-Web: Einheiten mit „Als Bruch anzeigen" AUS
/// zeigen eine Dezimalzahl („0.25"), alle anderen (und Zutaten ohne Einheit)
/// Koch-Brüche („¼").
String formatIngredientQuantity(double q, IngredientUnit? unit) {
  if (unit == null || unit.showsFraction) return formatQuantity(q);
  return double.parse(q.toStringAsFixed(3))
      .toStringAsFixed(3)
      .replaceAll(RegExp(r'0+$'), '')
      .replaceAll(RegExp(r'\.$'), '');
}

typedef IngredientDisplay = ({String amount, String name});

/// Baut die zweigeteilte Anzeige einer Zutat (hervorgehobene Menge + Name),
/// skaliert mit [multiplier]. 1:1 zur Logik in RecipeDetailScreen.
IngredientDisplay ingredientDisplayParts(Ingredient ing, double multiplier) {
  final hasQty = (ing.quantity ?? 0) > 0;
  final hasUnit = ing.unit?.name?.isNotEmpty == true;
  final hasFood = ing.food?.name?.isNotEmpty == true;
  final scaledQty = (ing.quantity ?? 0) * multiplier;
  final linked = ing.referencedRecipe?.name ?? '';

  if (!hasFood && linked.isNotEmpty) {
    // Verlinktes Rezept: „1 Béchamelsauce" (Menge = Anzahl Portionen/
    // Chargen des Unterrezepts, skaliert wie jede andere Menge).
    final a = <String>[
      if (hasQty) formatIngredientQuantity(scaledQty, ing.unit),
      if (hasUnit)
        ing.unit!.displayName(plural: shouldPluralize(scaledQty)),
    ];
    final n = <String>[linked];
    if (ing.note?.isNotEmpty == true) n.add('(${ing.note})');
    return (amount: a.join(' '), name: n.join(' '));
  }

  if (ing.disableAmount == true || (!hasQty && !hasFood && !hasUnit)) {
    return (amount: '', name: scaledNote(ing.note, multiplier));
  }

  // Mealie pluralisiert Einheit/Zutat ab einer Menge > 1 (z. B. "4 cups",
  // "24 eggs") — siehe shouldPluralize/pluralize.
  final usePlural = shouldPluralize(scaledQty);

  final a = <String>[];
  if (hasQty) a.add(formatIngredientQuantity(scaledQty, ing.unit));
  if (hasUnit) a.add(ing.unit!.displayName(plural: usePlural));
  final amount = a.join(' ');

  final n = <String>[];
  if (hasFood) {
    final food = ing.food!;
    n.add(pluralize(food.name!, food.pluralName, usePlural));
    if (ing.note?.isNotEmpty == true) n.add('(${ing.note})');
  } else if (ing.note?.isNotEmpty == true) {
    n.add(ing.note!);
  }
  return (amount: amount, name: n.join(' '));
}
