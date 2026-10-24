import 'package:mealie_recipes/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Mahlzeitentypen im Essensplan — genau die von Mealie (PlanEntryType):
// Frühstück, Mittagessen, Abendessen, Beilage, Zwischenmahlzeit, Getränk,
// Nachspeise. EINE Stelle für Reihenfolge, Symbol und Bezeichnung; vorher
// kannte die App nur die ersten drei und zeigte Webapp-Einträge wie „side"
// als Rohtext.
// ---------------------------------------------------------------------------

const kMealTypes = [
  'breakfast',
  'lunch',
  'dinner',
  'side',
  'snack',
  'drink',
  'dessert',
];

/// Sortierung innerhalb eines Tages (unbekannte Typen ans Ende).
int mealTypeOrder(String type) {
  final i = kMealTypes.indexOf(type.toLowerCase());
  return i < 0 ? kMealTypes.length : i;
}

String mealTypeEmoji(String type) => switch (type.toLowerCase()) {
      'breakfast' => '🍳',
      'lunch' => '🥪',
      'dinner' => '🍽',
      'side' => '🥗',
      'snack' => '🍿',
      'drink' => '🥤',
      'dessert' => '🍰',
      _ => '🍴',
    };

/// Bezeichnung wie in Mealie-Web (je Sprache); unbekannt → Rohwert.
String mealTypeLabel(String type, AppLocalizations l) =>
    switch (type.toLowerCase()) {
      'breakfast' => l.breakfast,
      'lunch' => l.lunch,
      'dinner' => l.dinner,
      'side' => l.mealTypeSide,
      'snack' => l.mealTypeSnack,
      'drink' => l.mealTypeDrink,
      'dessert' => l.mealTypeDessert,
      _ => type,
    };
