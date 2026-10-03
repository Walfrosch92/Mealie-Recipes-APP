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
      return whole > 0 ? '$whole$glyph' : glyph;
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
        return '< ${whole > 0 ? '$whole$glyph' : glyph}';
      }
      break;
    }
  }
  return clean.toStringAsFixed(1);
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
      if (hasQty) formatQuantity(scaledQty),
      if (hasUnit) ing.unit!.name!,
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
  if (hasQty) a.add(formatQuantity(scaledQty));
  if (hasUnit) {
    final unit = ing.unit!;
    a.add(pluralize(unit.name!, unit.pluralName, usePlural));
  }
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
