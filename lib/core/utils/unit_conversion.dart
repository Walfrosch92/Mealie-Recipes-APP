// Einheiten-Umrechnung „Wie angegeben / Metrisch / Imperial" (Issue #50).
// 1:1-Port von Mealie frontend/app/composables/recipes/use-unit-conversion.ts
// + unit-systems.ts (Stand 2026-11-17). Reine Anzeige — nichts wird
// zurückgeschrieben, Editor/Einkaufsliste sehen immer die Originaldaten.

import 'dart:math' as math;

import '../models/recipe_detail.dart';
import 'unit_seed_names.dart';

/// Gewähltes Einheitensystem. `null` = wie angegeben (Mealie-Default).
/// Gespeichert als 'metric' / 'us' — wie Mealie heißt „us" in der
/// Oberfläche „Imperial".
enum UnitSystem { metric, us }

UnitSystem? unitSystemFromKey(String? key) => switch (key) {
      'metric' => UnitSystem.metric,
      'us' => UnitSystem.us,
      _ => null,
    };

String unitSystemKey(UnitSystem? s) => s?.name ?? '';

enum _Dimension { mass, volume }

class _StandardizedUnit {
  final _Dimension dimension;

  /// Basiseinheiten (Gramm bzw. Milliliter) in einer dieser Einheit.
  final double base;
  final bool customary;
  const _StandardizedUnit(this.dimension, this.base, this.customary);
}

class _UnitRung {
  final String seedKey;
  final double base;

  /// Ganze Einheiten, ab denen diese Stufe die darunter ablöst.
  final double takeover;
  final bool fraction;
  const _UnitRung(this.seedKey, this.base, this.takeover, this.fraction);
}

const _standardizedUnits = <String, _StandardizedUnit>{
  'fluid_ounce': _StandardizedUnit(_Dimension.volume, 29.5735295625, true),
  'cup': _StandardizedUnit(_Dimension.volume, 236.5882365, true),
  'ounce': _StandardizedUnit(_Dimension.mass, 28.349523125, true),
  'pound': _StandardizedUnit(_Dimension.mass, 453.59237, true),
  'milliliter': _StandardizedUnit(_Dimension.volume, 1.0, false),
  'liter': _StandardizedUnit(_Dimension.volume, 1000.0, false),
  'gram': _StandardizedUnit(_Dimension.mass, 1.0, false),
  'kilogram': _StandardizedUnit(_Dimension.mass, 1000.0, false),
};

const _unitSystems = <UnitSystem, Map<_Dimension, List<_UnitRung>>>{
  UnitSystem.metric: {
    _Dimension.mass: [
      _UnitRung('gram', 1.0, 1.0, false),
      _UnitRung('kilogram', 1000.0, 1.0, false),
    ],
    _Dimension.volume: [
      _UnitRung('milliliter', 1.0, 1.0, false),
      _UnitRung('liter', 1000.0, 1.0, false),
    ],
  },
  UnitSystem.us: {
    _Dimension.mass: [
      _UnitRung('ounce', 28.349523125, 1.0, true),
      _UnitRung('pound', 453.59237, 1.0, true),
    ],
    _Dimension.volume: [
      _UnitRung('teaspoon', 4.92892159375, 1.0, true),
      _UnitRung('tablespoon', 14.78676478125, 1.0, true),
      _UnitRung('cup', 236.5882365, 0.25, true),
      _UnitRung('quart', 946.352946, 1.0, true),
      _UnitRung('gallon', 3785.411784, 1.0, true),
    ],
  },
};

const _decimalRoundingThreshold = 0.025;
const _fractionRoundingThreshold = 0.05;
const _decimalSteps = [1, 2, 5];
const _fractionDenominators = [1, 2, 3, 4, 8];
const _finestDenominator = 8;

({double quantity, double standardQuantity, _StandardizedUnit standard})?
    _resolveConvertible(Ingredient ing) {
  final q = ing.quantity;
  final unit = ing.unit;
  final sq = unit?.standardQuantity;
  if (q == null || q == 0 || unit == null || sq == null || sq == 0) {
    return null;
  }
  final std = _standardizedUnits[unit.standardUnit];
  if (std == null) return null;
  return (quantity: q, standardQuantity: sq, standard: std);
}

/// Lässt sich die Zutat umrechnen? (Einheit mit Mealie-„Standardisierung").
bool canConvertIngredient(Ingredient ing) =>
    ing.disableAmount != true && _resolveConvertible(ing) != null;

_UnitRung _pickRung(List<_UnitRung> rungs, double magnitude) {
  var chosen = rungs.first;
  for (final r in rungs) {
    if (magnitude >= r.base * r.takeover) chosen = r;
  }
  return chosen;
}

double _roundDecimal(double value) {
  final target = value * _decimalRoundingThreshold * 2;
  final power = math.pow(10, (math.log(target) / math.ln10).floor()).toDouble();
  var step = power;
  for (final c in _decimalSteps) {
    if (target / power >= c) step = c * power;
  }
  return (value / step).round() * step;
}

double? _roundFraction(double value) {
  for (final d in _fractionDenominators) {
    final rounded = (value * d).round() / d;
    if (rounded > 0 &&
        (rounded - value).abs() <= value * _fractionRoundingThreshold) {
      return rounded;
    }
  }
  return null;
}

double _finestFraction(double value) {
  final r = (value * _finestDenominator).round() / _finestDenominator;
  return r == 0 ? value : r;
}

({_UnitRung rung, double quantity}) _roundToRung(
    List<_UnitRung> rungs, double magnitude) {
  final rung = _pickRung(rungs, magnitude);
  final value = magnitude / rung.base;
  if (!rung.fraction) return (rung: rung, quantity: _roundDecimal(value));

  final rounded = _roundFraction(value);
  if (rounded != null) return (rung: rung, quantity: rounded);

  final i = rungs.indexOf(rung);
  if (i > 0 && value < 1) {
    final below = rungs[i - 1];
    final dropped = magnitude / below.base;
    return (
      rung: below,
      quantity: _roundFraction(dropped) ?? _finestFraction(dropped)
    );
  }
  return (rung: rung, quantity: _finestFraction(value));
}

/// Einheitennamen aus Mealies Einheiten-Seed der App-Sprache (Rückfall
/// Grundsprache → Englisch). Umgerechnete Einheiten folgen wie in Mealie
/// den Konventionen ihres Systems: abgekürzt, metrisch dezimal, US als Bruch.
IngredientUnit _unitFromRung(_UnitRung rung, String lang) {
  final table = kSeedUnitNames[lang] ??
      kSeedUnitNames[lang.split('_').first] ??
      kSeedUnitNames['en']!;
  final (name, plural, abbr, pluralAbbr) =
      table[rung.seedKey] ?? kSeedUnitNames['en']![rung.seedKey]!;
  return IngredientUnit(
    name: name,
    pluralName: plural,
    abbreviation: abbr,
    pluralAbbreviation: pluralAbbr,
    fraction: rung.fraction,
    useAbbreviation: true,
  );
}

/// Zutat im gewählten System ausdrücken. Wie Mealie:
/// - nicht umrechenbar oder schon im gewünschten System → unverändert
///   (gleiches Objekt), „1 Pint" wird also nicht zu „2 Tassen";
/// - Stufe und Rundung werden an der SKALIERTEN Menge entschieden und die
///   Menge danach wieder durch [scale] geteilt, weil die Anzeige selbst noch
///   skaliert (4 oz bei 10× → 1,15 kg statt 1134 g).
Ingredient convertIngredient(Ingredient ing, UnitSystem? system,
    {double scale = 1, String lang = 'en'}) {
  if (system == null || ing.disableAmount == true) return ing;
  final c = _resolveConvertible(ing);
  if (c == null) return ing;
  if (c.standard.customary == (system == UnitSystem.us)) return ing;

  final magnitude = c.quantity * c.standardQuantity * c.standard.base;
  final rungs = _unitSystems[system]![c.standard.dimension]!;
  final s = scale <= 0 ? 1.0 : scale;
  final r = _roundToRung(rungs, magnitude * s);
  return ing.copyWith(
      quantity: r.quantity / s, unit: _unitFromRung(r.rung, lang));
}
