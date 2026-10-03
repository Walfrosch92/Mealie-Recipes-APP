// ---------------------------------------------------------------------------
// Kochbuch-Filter-Baukasten ↔ Mealie-Query-Filter-String.
//
// Ein Kochbuch speichert serverseitig einen `queryFilterString`, der opak an
// GET /api/recipes?queryFilter=… durchgereicht wird (siehe cookbook_summary
// .dart). Diese Datei baut aus mehreren Baukasten-Zeilen (Feld/Operator/
// Werte) genau diesen String — AND-verknüpft, IDs doppelt-quotiert, wie in
// Mealies Query-Filter-Grammatik üblich — und parst ihn beim Bearbeiten
// eines bestehenden Kochbuchs zurück in Zeilen (nur unser eigenes, flaches
// AND-Format; alles andere liefert `null` statt etwas Unbekanntes zu
// verwerfen — der Aufrufer fällt dann auf einen Roh-Text-Modus zurück).
//
// Konfidenz der Attribut-Pfade (siehe kFieldAttribute): Kategorien/
// Schlagworte sind vielfach dokumentierte Mealie-Syntax; Zutaten/Utensilien/
// Haushalte/Benutzer sind nach bestem Wissen des Datenmodells gewählt, aber
// NICHT gegen einen echten Server verifiziert (kein Testserver verfügbar) —
// bei einem HTTP 400 einer Dimension ist die Konstante hier der erste Blick.
// ---------------------------------------------------------------------------

enum CookbookFilterField {
  category,
  tag,
  food,
  tool,
  household,
  user,
  // Zahlen-/Datumsfelder (Mealie Rezept-Suche „Andere Filter").
  foodLabel,
  lastMade,
  rating,
  totalTime,
}

enum CookbookFilterOp {
  isOneOf,
  isNotOneOf,
  containsAll,
  // Vergleiche für Zahlen-/Datumsfelder.
  eq,
  ne,
  gt,
  gte,
  lt,
  lte,
}

/// Die bisherigen Felder von Kochbuch und Mahlzeitenplan-Regeln.
const List<CookbookFilterField> kOrganizerFilterFields = [
  CookbookFilterField.category,
  CookbookFilterField.tag,
  CookbookFilterField.food,
  CookbookFilterField.tool,
  CookbookFilterField.household,
  CookbookFilterField.user,
];

/// Felder der Mealie-Rezept-Suche („Andere Filter", finder/index.vue).
const List<CookbookFilterField> kFinderFilterFields = [
  CookbookFilterField.category,
  CookbookFilterField.tag,
  CookbookFilterField.food,
  CookbookFilterField.foodLabel,
  CookbookFilterField.household,
  CookbookFilterField.user,
  CookbookFilterField.lastMade,
  CookbookFilterField.rating,
  CookbookFilterField.totalTime,
];

/// Felder mit einem Zahlenwert statt einer Auswahl.
const Set<CookbookFilterField> kScalarFields = {
  CookbookFilterField.lastMade,
  CookbookFilterField.rating,
  CookbookFilterField.totalTime,
};

/// Operatoren je Feld — wie Mealies use-query-filter-builder.ts.
List<CookbookFilterOp> opsForField(CookbookFilterField f) => switch (f) {
      CookbookFilterField.lastMade => const [
          CookbookFilterOp.lte, // „ist älter als" (häufigster zuerst)
          CookbookFilterOp.gte, // „ist neuer als"
        ],
      CookbookFilterField.rating => const [
          CookbookFilterOp.eq,
          CookbookFilterOp.ne,
          CookbookFilterOp.gt,
          CookbookFilterOp.gte,
          CookbookFilterOp.lt,
          CookbookFilterOp.lte,
        ],
      CookbookFilterField.totalTime => const [
          CookbookFilterOp.lte,
          CookbookFilterOp.gte,
          CookbookFilterOp.lt,
          CookbookFilterOp.gt,
        ],
      _ => kMultiValueFields.contains(f)
          ? const [
              CookbookFilterOp.isOneOf,
              CookbookFilterOp.isNotOneOf,
              CookbookFilterOp.containsAll,
            ]
          : const [CookbookFilterOp.isOneOf, CookbookFilterOp.isNotOneOf],
    };

const Map<CookbookFilterField, String> kFieldAttribute = {
  CookbookFilterField.category: 'recipe_category.id',
  CookbookFilterField.tag: 'tags.id',
  CookbookFilterField.food: 'recipe_ingredient.food.id',
  CookbookFilterField.tool: 'tools.id',
  CookbookFilterField.household: 'household_id',
  CookbookFilterField.user: 'user_id',
  CookbookFilterField.foodLabel: 'recipe_ingredient.food.label_id',
  CookbookFilterField.lastMade: 'last_made',
  CookbookFilterField.rating: 'rating',
  CookbookFilterField.totalTime: 'total_time_seconds',
};

const Map<CookbookFilterOp, String> kOpKeyword = {
  CookbookFilterOp.isOneOf: 'IN',
  CookbookFilterOp.isNotOneOf: 'NOT IN',
  CookbookFilterOp.containsAll: 'CONTAINS ALL',
  CookbookFilterOp.eq: '=',
  CookbookFilterOp.ne: '<>',
  CookbookFilterOp.gt: '>',
  CookbookFilterOp.gte: '>=',
  CookbookFilterOp.lt: '<',
  CookbookFilterOp.lte: '<=',
};

/// „Enthält alle" ergibt nur bei Mehrfach-Dimensionen Sinn (ein Rezept kann
/// mehrere Kategorien/Tags/Zutaten/Utensilien haben) — ein Rezept hat genau
/// EINEN Haushalt/Ersteller.
const Set<CookbookFilterField> kMultiValueFields = {
  CookbookFilterField.category,
  CookbookFilterField.tag,
  CookbookFilterField.food,
  CookbookFilterField.tool,
  CookbookFilterField.foodLabel,
};

class CookbookFilterRow {
  CookbookFilterField field;
  CookbookFilterOp op;
  List<String> valueIds;

  /// Zahlenwert der Zahlen-/Datumsfelder: Bewertung, „vor N Tagen"
  /// (zuletzt gemacht) bzw. Minuten (Gesamtzeit; Mealie rechnet in Sekunden).
  int? number;

  CookbookFilterRow({
    this.field = CookbookFilterField.category,
    this.op = CookbookFilterOp.isOneOf,
    List<String>? valueIds,
    this.number,
  }) : valueIds = valueIds ?? [];

  bool get isScalar => kScalarFields.contains(field);

  /// Feld wechseln: Wert leeren, Operator + Standardwert wie Mealie
  /// (zuletzt gemacht: 30 Tage).
  void setField(CookbookFilterField f) {
    field = f;
    valueIds = [];
    op = opsForField(f).first;
    number = switch (f) {
      CookbookFilterField.lastMade => 30,
      CookbookFilterField.rating => 4,
      CookbookFilterField.totalTime => 30,
      _ => null,
    };
  }
}

String _scalarValue(CookbookFilterRow r) => switch (r.field) {
      CookbookFilterField.lastMade => '\$NOW-${r.number}d',
      CookbookFilterField.totalTime => '${r.number! * 60}',
      _ => '${r.number}',
    };

/// Baut den `queryFilterString` (AND-verknüpft, leere Zeilen übersprungen).
String composeCookbookQueryFilter(List<CookbookFilterRow> rows) {
  final parts = <String>[];
  for (final r in rows) {
    if (r.isScalar) {
      if (r.number == null) continue;
      parts.add(
          '${kFieldAttribute[r.field]} ${kOpKeyword[r.op]} ${_scalarValue(r)}');
      continue;
    }
    if (r.valueIds.isEmpty) continue;
    final list = r.valueIds.map((id) => '"$id"').join(', ');
    parts.add('${kFieldAttribute[r.field]} ${kOpKeyword[r.op]} [$list]');
  }
  return parts.join(' AND ');
}

final RegExp _kRowPattern =
    RegExp(r'^([\w.]+)\s+(IN|NOT IN|CONTAINS ALL)\s+\[([^\]]*)\]$');

final RegExp _kScalarPattern = RegExp(r'^([\w.]+)\s*(<=|>=|<>|=|<|>)\s*(\S+)$');

CookbookFilterRow? _parseScalar(String seg) {
  final m = _kScalarPattern.firstMatch(seg);
  if (m == null) return null;
  final field = kFieldAttribute.entries
      .where((e) => e.value == m.group(1) && kScalarFields.contains(e.key))
      .map((e) => e.key)
      .firstOrNull;
  if (field == null) return null;
  final op = kOpKeyword.entries
      .where((e) => e.value == m.group(2))
      .map((e) => e.key)
      .first;
  if (!opsForField(field).contains(op)) return null;
  final raw = m.group(3)!;
  int? number;
  switch (field) {
    case CookbookFilterField.lastMade:
      final d = RegExp(r'^\$NOW-(\d+)d$').firstMatch(raw);
      number = d == null ? null : int.parse(d.group(1)!);
    case CookbookFilterField.totalTime:
      final secs = int.tryParse(raw);
      number = secs == null || secs % 60 != 0 ? null : secs ~/ 60;
    default:
      number = int.tryParse(raw);
  }
  if (number == null) return null;
  return CookbookFilterRow(field: field, op: op, number: number);
}

/// Zerlegt einen bestehenden `queryFilterString` in Baukasten-Zeilen — nur
/// unser eigenes einfaches AND-Format wird erkannt; alles andere (Klammern,
/// OR, unbekannte Attribute, Freitext-Vergleiche) liefert `null`.
List<CookbookFilterRow>? tryParseCookbookQueryFilter(String q) {
  final trimmed = q.trim();
  if (trimmed.isEmpty) return [];
  try {
    final segments = trimmed.split(RegExp(r'\s+AND\s+'));
    final rows = <CookbookFilterRow>[];
    for (final seg in segments) {
      final scalar = _parseScalar(seg.trim());
      if (scalar != null) {
        rows.add(scalar);
        continue;
      }
      final m = _kRowPattern.firstMatch(seg.trim());
      if (m == null) return null;
      final attr = m.group(1)!;
      final opStr = m.group(2)!;
      final field =
          kFieldAttribute.entries.firstWhere((e) => e.value == attr).key;
      final op = kOpKeyword.entries.firstWhere((e) => e.value == opStr).key;
      final ids = m
          .group(3)!
          .split(',')
          .map((s) => s.trim().replaceAll('"', ''))
          .where((s) => s.isNotEmpty)
          .toList();
      if (ids.isEmpty) return null;
      rows.add(CookbookFilterRow(field: field, op: op, valueIds: ids));
    }
    return rows;
  } catch (_) {
    return null;
  }
}
