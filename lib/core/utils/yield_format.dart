import '../models/recipe_detail.dart';
import 'ingredient_display.dart' show formatQuantity;

/// Skaliert eine Portions-/Yield-Angabe mit dem Multiplikator.
/// `recipeYield` ist ein freier String (z. B. "4" oder "4 Portionen") — die
/// erste enthaltene Zahl wird multipliziert, der restliche Text bleibt erhalten.
/// Bei `m == 1.0` (oder ohne erkennbare Zahl) wird der Originaltext zurückgegeben.
String scaleYield(String yield, double m) {
  if (m == 1.0) return yield;
  final match = RegExp(r'\d+([.,]\d+)?').firstMatch(yield);
  if (match == null) return yield;
  final val = double.tryParse(match.group(0)!.replaceAll(',', '.'));
  if (val == null || val <= 0) return yield;
  // Auf 2 Nachkommastellen runden, BEVOR auf Ganzzahligkeit geprüft wird:
  // Multiplikatoren aus einer eingegebenen/gesteppten Zielportionenzahl
  // (siehe _PortionStepper) sind i. Allg. keine exakten Binärbrüche — 6 × (4/6)
  // ergibt in double-Arithmetik 3.9999999999999996 statt 4.0, die
  // Ganzzahl-Prüfung würde sonst fälschlich "4.0" statt "4" anzeigen.
  final scaled = double.parse((val * m).toStringAsFixed(2));
  // Bis zu 2 Nachkommastellen wie bei den Zutatenmengen (0.33 statt „0.3").
  final str = scaled == scaled.truncateToDouble()
      ? scaled.truncate().toString()
      : scaled
          .toStringAsFixed(2)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
  return yield.replaceRange(match.start, match.end, str);
}

/// Portionen und Ergibt getrennt wie die Webapp (RecipeYield.vue +
/// Portionen-Knopf): „4 Portionen" (skaliert) und „24 Kekse" (skalierte
/// Ergibt-Menge + Text). Ältere Server ohne Ergibt-Menge: Zahl im Text
/// skalieren. Doppelte Angaben (Text = Portionenzahl) fallen weg.
List<String> recipeYieldParts(
    RecipeDetail r, double m, String servingsLabel) {
  String fmt(double v) {
    final c = double.parse(v.toStringAsFixed(2));
    return c == c.truncateToDouble()
        ? c.truncate().toString()
        : formatQuantity(c);
  }

  final parts = <String>[];
  final servings = r.servings ?? 0;
  if (servings > 0) parts.add('${fmt(servings * m)} $servingsLabel');
  final text = (r.rawYield ?? '').trim();
  final q = r.yieldQuantity ?? 0;
  String? y;
  if (q > 0) {
    y = [fmt(q * m), if (text.isNotEmpty) text].join(' ');
  } else if (text.isNotEmpty) {
    y = scaleYield(text, m);
  }
  if (y != null && y.isNotEmpty) {
    final dup = parts.isNotEmpty &&
        (y.toLowerCase() == parts.first.toLowerCase() ||
            double.tryParse(text.replaceAll(',', '.')) == servings);
    if (!dup) parts.add(y);
  }
  // Ganz alte Server/Caches: nur der zusammengesetzte Anzeige-Wert.
  if (parts.isEmpty && (r.recipeYield ?? '').trim().isNotEmpty) {
    parts.add(scaleYield(r.recipeYield!.trim(), m));
  }
  return parts;
}
