// ---------------------------------------------------------------------------
// Zutaten-Notentext zerlegen.
//
// Manche Mealie-Rezepte speichern Zutaten unstrukturiert als reinen `note`-Text
// wie "200.0 Gramm Gouda" oder "100g Mehl" (food/unit/quantity leer) — z.B.
// nach einem Bearbeiten durch eine ältere App-Version. Damit die App trotzdem
// nur die ZUTAT (für die Einkaufsliste) bzw. getrennte Felder (für den Edit)
// gewinnt, zerlegen wir den Text:
//   führende Menge  →  bekannte Einheit  →  Rest = Zutat.
//
// `unitLookup` bildet jeden erkennbaren Einheits-Token (klein geschrieben) auf
// den kanonischen Einheitsnamen ab — sowohl der NAME ("gramm" → "Gramm") als
// auch die ABKÜRZUNG ("g" → "Gramm"). So wird auch "100g Mehl" (ohne Leerzeichen
// vor der Einheit, nur Abkürzung) korrekt in 100 / Gramm / Mehl zerlegt. Die
// Erkennung ist sprachunabhängig, weil sie gegen die echten Einheiten des
// Mealie-Servers matcht statt gegen eine fixe Wortliste.
// ---------------------------------------------------------------------------

typedef IngredientParts = ({String quantity, String unit, String food});

/// Gängige Einheiten/Abkürzungen der unterstützten Sprachen (de/en/es/fr/nl)
/// als FALLBACK — falls eine Einheit auf dem Mealie-Server keine Abkürzung
/// hinterlegt hat oder gar nicht existiert. Token (klein) → kanonischer Name.
/// Server-Einträge haben in buildUnitLookup Vorrang. Eindeutige Schlüssel
/// (keine Duplikate) — ein Token darf nur einmal vorkommen.
const Map<String, String> commonUnitTokens = {
  // Metrisch (sprachneutrale Abkürzungen → so belassen)
  'g': 'g', 'gr': 'g', 'kg': 'kg', 'mg': 'mg',
  'l': 'l', 'ml': 'ml', 'dl': 'dl', 'cl': 'cl',
  // Deutsch
  'gramm': 'Gramm', 'kilogramm': 'Kilogramm', 'milligramm': 'Milligramm',
  'liter': 'Liter', 'milliliter': 'Milliliter', 'deziliter': 'Deziliter',
  'esslöffel': 'Esslöffel', 'el': 'Esslöffel', 'teelöffel': 'Teelöffel',
  'tl': 'Teelöffel', 'stück': 'Stück', 'stk': 'Stück', 'prise': 'Prise',
  'päckchen': 'Päckchen', 'packung': 'Packung', 'dose': 'Dose',
  'becher': 'Becher', 'bund': 'Bund', 'scheibe': 'Scheibe', 'zehe': 'Zehe',
  // English
  'gram': 'Gram', 'grams': 'Gram', 'kilogram': 'Kilogram', 'litre': 'Litre',
  'tablespoon': 'Tablespoon', 'tbsp': 'Tablespoon', 'teaspoon': 'Teaspoon',
  'tsp': 'Teaspoon', 'cup': 'Cup', 'cups': 'Cup', 'ounce': 'Ounce',
  'oz': 'Ounce', 'pound': 'Pound', 'lb': 'Pound', 'lbs': 'Pound',
  'pinch': 'Pinch', 'can': 'Can', 'package': 'Package', 'pack': 'Package',
  'clove': 'Clove', 'slice': 'Slice',
  // Español
  'gramo': 'Gramo', 'gramos': 'Gramo', 'kilogramo': 'Kilogramo',
  'litro': 'Litro', 'mililitro': 'Mililitro', 'cucharada': 'Cucharada',
  'cda': 'Cucharada', 'cucharadita': 'Cucharadita', 'cdta': 'Cucharadita',
  'taza': 'Taza', 'tazas': 'Taza', 'pizca': 'Pizca', 'lata': 'Lata',
  'paquete': 'Paquete', 'diente': 'Diente', 'rodaja': 'Rodaja',
  // Français
  'gramme': 'Gramme', 'grammes': 'Gramme', 'kilogramme': 'Kilogramme',
  'millilitre': 'Millilitre', 'cuillère': 'Cuillère', 'càs': 'Cuillère à soupe',
  'càc': 'Cuillère à café', 'tasse': 'Tasse', 'pincée': 'Pincée',
  'boîte': 'Boîte', 'sachet': 'Sachet', 'gousse': 'Gousse',
  'tranche': 'Tranche',
  // Nederlands
  'kilo': 'Kilo', 'eetlepel': 'Eetlepel', 'theelepel': 'Theelepel',
  'kopje': 'Kopje', 'snufje': 'Snufje', 'blik': 'Blik', 'pak': 'Pak',
  'teen': 'Teen', 'plak': 'Plak',
};

/// Baut die Token→kanonischer-Name-Map: gängige Tokens (Fallback) + Mealies
/// Units-Rohdaten (Liste von {name, abbreviation, ...}). SERVER hat Vorrang.
Map<String, String> buildUnitLookup(List<Map<String, dynamic>> unitsRaw) {
  final m = <String, String>{...commonUnitTokens};
  for (final u in unitsRaw) {
    final name = (u['name'] as String?)?.trim() ?? '';
    if (name.isEmpty) continue;
    m[name.toLowerCase()] = name; // Server-Name überschreibt Fallback
  }
  for (final u in unitsRaw) {
    final name = (u['name'] as String?)?.trim() ?? '';
    final abbr = (u['abbreviation'] as String?)?.trim() ?? '';
    if (name.isEmpty || abbr.isEmpty) continue;
    m[abbr.toLowerCase()] = name; // Server-Abkürzung → kanonischer Server-Name
  }
  return m;
}

IngredientParts splitIngredientNote(
    String note, Map<String, String> unitLookup) {
  var s = note.trim();

  // 1) Führende Menge: Ziffern, Dezimal/Komma, Brüche, Bereiche. (Stoppt vor
  //    einem direkt anschließenden Buchstaben, daher wird "100g" → "100".)
  var quantity = '';
  final qtyMatch = RegExp(r'^[\d.,/½¼¾⅓⅔⅛⅜⅝⅞\s\-–]+').firstMatch(s);
  if (qtyMatch != null) {
    quantity = qtyMatch.group(0)!.trim();
    s = s.substring(qtyMatch.end).trimLeft();
  }
  // "200.0" → "200", "1.5" → "1.5".
  final q = double.tryParse(quantity.replaceAll(',', '.'));
  if (q != null) {
    quantity =
        q == q.truncateToDouble() ? q.truncate().toString() : q.toString();
  }

  // 2) Führende Einheit: längster passender Token (Name ODER Abkürzung) als
  //    ganzes führendes Wort. Längster zuerst, damit z.B. "EL" vor "E" greift.
  var unit = '';
  final tokens = unitLookup.keys.where((k) => k.isNotEmpty).toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  final lower = s.toLowerCase();
  for (final t in tokens) {
    if (lower == t) {
      unit = unitLookup[t]!;
      s = '';
      break;
    }
    if (lower.startsWith('$t ')) {
      unit =
          unitLookup[t]!; // kanonischer Name, auch wenn per Abkürzung erkannt
      s = s.substring(t.length).trimLeft();
      break;
    }
  }

  return (quantity: quantity, unit: unit, food: s.trim());
}
