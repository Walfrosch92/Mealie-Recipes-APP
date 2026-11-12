/// Mealie-Sprachcodes (Dateien unter mealie/lang/messages) je App-Sprache —
/// für den Seeder und für übersetzte Server-Texte (z. B. Kalender-Abo).
const kMealieLocales = {
  'de': 'de-DE',
  'en': 'en-US',
  'es': 'es-ES',
  'fr': 'fr-FR',
  'fr_CA': 'fr-CA',
  'hu': 'hu-HU',
  'nb': 'no-NO',
  'nl': 'nl-NL',
  'pl': 'pl-PL',
  'pt': 'pt-BR',
  'sl': 'sl-SI',
};

/// Mealie-Sprachcode zur App-Sprache, unbekannt → Englisch.
String mealieLocaleFor(String? appLang) =>
    kMealieLocales[appLang] ?? kMealieLocales['en']!;
