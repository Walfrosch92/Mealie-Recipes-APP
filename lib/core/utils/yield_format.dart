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
  final str = scaled == scaled.truncateToDouble()
      ? scaled.truncate().toString()
      : scaled.toStringAsFixed(1);
  return yield.replaceRange(match.start, match.end, str);
}
