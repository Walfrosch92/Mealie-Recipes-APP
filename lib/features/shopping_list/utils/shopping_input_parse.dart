import '../../../core/models/shopping_item.dart';
import '../../../core/utils/ingredient_display.dart' show parseQuantityInput;
import '../providers/foods_units_provider.dart' show resolveUnitByName;

// ---------------------------------------------------------------------------
// Eingabezeile der Einkaufsliste: „200 Gramm Butter" (oder „200, Gramm,
// Butter", „200g Butter", „1 1/2 EL Zucker", „3 Eier") direkt als
// strukturierten Artikel verstehen — die einzige Abweichung der App von
// Mealies Ein-Feld-Eingabe (dort nur über die aufgeklappten Details).
//
// Regeln (bewusst vorsichtig, damit normaler Freitext Freitext bleibt):
//   • nur wenn der Text mit einer Menge beginnt (Zahl, Bruch, „½", „1 1/2"),
//   • das nächste Wort ist nur dann eine Einheit, wenn der Server-Katalog
//     sie kennt (Name, Mehrzahl, Abkürzung) — sonst gehört es zum Artikel
//     („2 große Äpfel"),
//   • danach muss noch ein Artikel kommen („200 Gramm" allein bleibt Text),
//   • an die Zahl geklebte Einheit („200g") nur, wenn sie bekannt ist —
//     „7up" bleibt „7up".
// Komma trennt wie ein Leerzeichen, außer zwischen Ziffern („0,5" = 0.5).
// ---------------------------------------------------------------------------

typedef ShoppingInput = ({double quantity, ShoppingUnit? unit, String name});

final _separatorComma = RegExp(r',(?!\d)|(?<!\d),');
final _ws = RegExp(r'\s+');
final _attached = RegExp(r'^(\d+(?:[.,]\d+)?)([^\d\s.,/].*)$');
final _fractionToken = RegExp(r'^(\d+/\d+|[½¼¾⅓⅔⅛⅜⅝⅞⅕⅖⅗⅘⅙⅚⅒])$');

List<String> _tokens(String text) => text
    .replaceAll(_separatorComma, ' ')
    .trim()
    .split(_ws)
    .where((t) => t.isNotEmpty)
    .toList();

/// Menge am Anfang: (Menge, Anzahl verbrauchter Tokens, an die Zahl
/// geklebter Rest wie „g" aus „200g").
(double, int, String?)? _leadingQuantity(List<String> t) {
  if (t.isEmpty) return null;
  // „1 1/2" bzw. „1 ½"
  if (t.length >= 2 &&
      RegExp(r'^\d+$').hasMatch(t[0]) &&
      _fractionToken.hasMatch(t[1])) {
    final q = parseQuantityInput('${t[0]} ${t[1]}');
    if (q != null && q > 0) return (q, 2, null);
  }
  final q = parseQuantityInput(t[0]);
  if (q != null && q > 0) return (q, 1, null);
  final m = _attached.firstMatch(t[0]);
  if (m != null) {
    final q2 = parseQuantityInput(m.group(1)!);
    if (q2 != null && q2 > 0) return (q2, 1, m.group(2));
  }
  return null;
}

/// Strukturierte Eingabe oder `null` (= normaler Freitext-Artikel).
ShoppingInput? parseShoppingInput(String text, List<ShoppingUnit> units) {
  final t = _tokens(text);
  final lead = _leadingQuantity(t);
  if (lead == null) return null;
  final (qty, used, glued) = lead;
  var rest = t.sublist(used);
  ShoppingUnit? unit;
  if (glued != null) {
    // „200g Butter": geklebte Einheit muss bekannt sein.
    unit = resolveUnitByName(units, glued);
    if (unit == null) return null;
  } else if (rest.length >= 2) {
    // Zwei Wörter zuerst („fl oz"), dann eins.
    unit = resolveUnitByName(units, '${rest[0]} ${rest[1]}');
    if (unit != null && rest.length > 2) {
      rest = rest.sublist(2);
    } else {
      unit = resolveUnitByName(units, rest[0]);
      if (unit != null) rest = rest.sublist(1);
    }
  } else if (rest.length == 1 && resolveUnitByName(units, rest[0]) != null) {
    return null; // „200 Gramm" — Einheit ohne Artikel bleibt Text
  }
  final name = rest.join(' ').trim();
  if (name.isEmpty) return null;
  return (quantity: qty, unit: unit, name: name);
}

/// Für die Autovervollständigung: welcher Teil wird gerade getippt?
/// [prefix] bleibt beim Übernehmen eines Vorschlags stehen, [query] wird
/// ersetzt. [unitSlot] = an dieser Stelle passt (auch) eine Einheit.
typedef ShoppingInputSlot = ({String prefix, String query, bool unitSlot});

ShoppingInputSlot shoppingInputSlot(String text, List<ShoppingUnit> units) {
  // Position des aktuell getippten Worts im ORIGINALtext bestimmen.
  final words = RegExp(r'[^\s,]+').allMatches(text).toList();
  if (words.isEmpty) return (prefix: '', query: text, unitSlot: false);
  final endsWithSep =
      text.isNotEmpty && (text.endsWith(' ') || text.endsWith(','));
  final tokens = [for (final w in words) w.group(0)!];
  final lead = _leadingQuantity(tokens);
  if (lead == null) return (prefix: '', query: text, unitSlot: false);
  final (_, used, glued) = lead;
  if (glued != null) {
    // „200g …": ab dem nächsten Wort kommt der Artikel.
    if (words.length == 1 && !endsWithSep) {
      return (prefix: '', query: text, unitSlot: false);
    }
    final start = words.length > 1 ? words[1].start : text.length;
    return (
      prefix: text.substring(0, start),
      query: text.substring(start),
      unitSlot: false,
    );
  }
  // Noch in der Menge („1", „1 1/2" ohne Leerzeichen dahinter).
  if (words.length < used || (words.length == used && !endsWithSep)) {
    return (prefix: '', query: '', unitSlot: false);
  }
  // Wort direkt nach der Menge: Einheit ODER schon der Artikel.
  if (words.length == used || (words.length == used + 1 && !endsWithSep)) {
    final start = words.length > used ? words[used].start : text.length;
    return (
      prefix: text.substring(0, start),
      query: text.substring(start),
      unitSlot: true,
    );
  }
  // Ist das Wort nach der Menge eine bekannte Einheit, folgt der Artikel.
  final afterQty = words[used];
  final isUnit = resolveUnitByName(units, afterQty.group(0)!) != null;
  final start = isUnit
      ? (words.length > used + 1 ? words[used + 1].start : text.length)
      : afterQty.start;
  return (
    prefix: text.substring(0, start),
    query: text.substring(start),
    unitSlot: false,
  );
}
