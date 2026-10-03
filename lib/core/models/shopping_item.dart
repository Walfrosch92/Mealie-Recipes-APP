import 'package:json_annotation/json_annotation.dart';

part 'shopping_item.g.dart';

@JsonSerializable(explicitToJson: true)
class ShoppingItem {
  final String id;
  final String? shoppingListId;
  final bool checked;
  final int? position;
  final ShoppingLabel? label;
  final String? note;
  final bool isFood;
  final double? quantity;
  final ShoppingFood? food;
  final ShoppingUnit? unit;
  final String? display;

  /// Mealie-Rezept-Verknüpfungen des Artikels (roh, wie vom Server). Müssen
  /// bei jedem PUT mitgehen — ein Update ohne sie löscht sie serverseitig,
  /// und mit ihnen verschwände das Rezept aus „verknüpfte Rezepte" der Liste.
  final List<Map<String, dynamic>> recipeReferences;

  /// Zusatzdaten von Integrationen (Mealie `extras`, z. B. Home Assistant) —
  /// wie [recipeReferences] bei jedem PUT unverändert zurückschicken, sonst
  /// setzt Mealie sie auf {}.
  final Map<String, dynamic>? extras;

  const ShoppingItem({
    required this.id,
    this.shoppingListId,
    this.checked = false,
    this.position,
    this.label,
    this.note,
    this.isFood = false,
    this.quantity,
    this.food,
    this.unit,
    this.display,
    this.recipeReferences = const [],
    this.extras,
  });

  /// IDs der Rezepte, aus denen der Artikel stammt.
  Iterable<String> get recipeIds => recipeReferences
      .map((r) => r['recipeId']?.toString() ?? '')
      .where((id) => id.isNotEmpty);

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);

  ShoppingItem copyWith({
    bool? checked,
    String? note,
    double? quantity,
    ShoppingLabel? label,
    ShoppingFood? food,
    ShoppingUnit? unit,
    bool clearLabel = false,
    bool clearUnit = false,
    bool clearFood = false,
  }) {
    return ShoppingItem(
      id: id,
      shoppingListId: shoppingListId,
      checked: checked ?? this.checked,
      position: position,
      label: clearLabel ? null : (label ?? this.label),
      note: note ?? this.note,
      // clearFood: Food-Verknüpfung lösen (Item wird Freitext-Artikel) —
      // genutzt, wenn der User ein Food-Item im Edit-Sheet umbenennt.
      isFood: clearFood ? false : (food != null ? true : isFood),
      quantity: quantity ?? this.quantity,
      // food/unit-Setter: fürs lokale Echo strukturierter Adds, wenn der
      // Server das Objekt (noch) nicht aufgelöst zurückliefert.
      food: clearFood ? null : (food ?? this.food),
      unit: clearUnit ? null : (unit ?? this.unit),
      display: display,
      recipeReferences: recipeReferences,
      extras: extras,
    );
  }

  /// True, wenn `food` den Produktnamen trägt und `note` höchstens eine
  /// Zusatzangabe ist („(Größe M)", „festkochend") — dann führt der Food-Name
  /// und die note hängt als [noteAnnotation] dahinter.
  ///
  /// Bewusst UNABHÄNGIG vom `isFood`-Flag: Mealie liefert Rezept-Adds aus der
  /// Webapp auch food-verknüpft mit isFood=false, und die frühere
  /// isFood-Bedingung zeigte für die dann NUR die Notiz („(Größe M)") statt
  /// des Produktnamens. Enthält die note dagegen den Food-Namen, ist sie der
  /// vollständige Anzeigetext (App-Konvention im Exakt-Modus mit
  /// eingebetteter Freitext-Einheit: „Esslöffel Butter") und bleibt führend.
  bool get foodLeads {
    final f = food?.name?.trim() ?? '';
    if (f.isEmpty) return false;
    final n = note?.trim() ?? '';
    if (n.isEmpty) return true;
    return !n.toLowerCase().contains(f.toLowerCase());
  }

  /// Parser-Sonderfall „4 Eier (Größe M)": Mealie legt dort das Nomen als
  /// EINHEIT an (unit="Eier") und nur die Klammer-Anmerkung als Food
  /// (food="(Größe M)"). Der Produktname steckt dann in der Einheit —
  /// food-first allein zeigte nur die Anmerkung. Solche Items rendern den
  /// Namen inklusive Einheit und verhalten sich wie Stück-Artikel (echte
  /// Anzahl im Stepper, kein 1x-Zwang, kein clearUnit bei +/−).
  bool get unitCarriesName {
    if (!foodLeads) return false;
    final f = food?.name?.trim() ?? '';
    final u = unit?.name?.trim() ?? '';
    return u.isNotEmpty && f.length > 2 && f.startsWith('(') && f.endsWith(')');
  }

  /// Menge für Stepper & Edit-Sheet: Webapp-Adds ungeparster Zutaten kommen
  /// mit quantity 0 (keine explizite Menge — der Betrag steckt im note-Text
  /// „500 g Spaghetti") — als 1x anzeigen statt einer nackten 0.
  double get effectiveQuantity {
    final q = quantity ?? 1;
    return q <= 0 ? 1 : q;
  }

  /// Item name only (no quantity/unit prefix) — mirrors iOS displayName.
  String get displayName {
    final foodName = food?.name?.trim() ?? '';
    if (foodLeads) {
      if (unitCarriesName) return '${unit!.name!.trim()} $foodName';
      return foodName;
    }
    final n = note?.trim() ?? '';
    if (n.isNotEmpty) return n;
    if (foodName.isNotEmpty) return foodName;
    if (display != null && display!.isNotEmpty) return display!;
    return '-';
  }

  /// Zusatznotiz eines Food-Items („(Größe M)", „festkochend") — nur nicht
  /// leer, wenn der Anzeigename aus `food` kommt. Die Listenzeile hängt sie
  /// gedimmt hinter den Produktnamen (Webapp-Verhalten: Food-Name und Notiz
  /// werden beide angezeigt).
  String get noteAnnotation => foodLeads ? (note?.trim() ?? '') : '';

  /// Wie [displayName], aber mit `food.pluralName` statt `food.name`, wenn
  /// [usePlural] und eine Pluralform vorhanden ist — für die Mengen-Anzeige
  /// im Exakt-Modus („3 Eier" statt „3 Ei", Issue #32). Die Parser-
  /// Sonderfälle (unitCarriesName, Freitext-Notiz-Items) liefern unverändert
  /// [displayName], da sie keine strukturierte Plural-Form tragen.
  String displayNamePlural(bool usePlural) {
    if (usePlural && foodLeads && !unitCarriesName) {
      final pl = food!.pluralName?.trim();
      if (pl != null && pl.isNotEmpty) return pl;
    }
    return displayName;
  }

  String get displayText {
    if (display != null && display!.isNotEmpty) return display!;
    final parts = <String>[];
    if (quantity != null && quantity! > 0) {
      parts.add(quantity! == quantity!.truncateToDouble()
          ? quantity!.truncate().toString()
          : quantity!.toStringAsFixed(1));
    }
    if (unit?.name != null) parts.add(unit!.name!);
    if (food?.name != null) {
      parts.add(food!.name!);
    } else if (note != null && note!.isNotEmpty) {
      parts.add(note!);
    }
    return parts.join(' ');
  }
}

@JsonSerializable()
class ShoppingLabel {
  final String id;
  final String name;
  final String? color;

  const ShoppingLabel({required this.id, required this.name, this.color});

  factory ShoppingLabel.fromJson(Map<String, dynamic> json) =>
      _$ShoppingLabelFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingLabelToJson(this);
}

@JsonSerializable()
class ShoppingFood {
  final String? id;
  final String? name;
  final String? pluralName;

  /// Mealie ≥ 2: Haushalte (Slugs), in denen das Lebensmittel vorrätig ist.
  final List<String>? householdsWithIngredientFood;

  /// Ältere Mealie-Versionen: globales „Vorrätig".
  final bool? onHand;

  /// Bezeichnung (Label) des Lebensmittels — Rezept-Suche-Filter offline.
  final String? labelId;

  const ShoppingFood(
      {this.id,
      this.name,
      this.pluralName,
      this.householdsWithIngredientFood,
      this.onHand,
      this.labelId});

  /// „Im Haushalt vorrätig" für den Haushalt [householdSlug] — dieselbe
  /// Regel wie Mealie-Web beim Hinzufügen zur Einkaufsliste.
  bool isOnHandIn(String? householdSlug) {
    final households = householdsWithIngredientFood;
    if (households != null) {
      return householdSlug != null && households.contains(householdSlug);
    }
    return onHand ?? false;
  }

  factory ShoppingFood.fromJson(Map<String, dynamic> json) =>
      _$ShoppingFoodFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingFoodToJson(this);
}

@JsonSerializable()
class ShoppingUnit {
  final String? id;
  final String? name;
  final String? pluralName;
  final String? abbreviation;

  const ShoppingUnit({this.id, this.name, this.pluralName, this.abbreviation});

  factory ShoppingUnit.fromJson(Map<String, dynamic> json) =>
      _$ShoppingUnitFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingUnitToJson(this);
}

// ---------------------------------------------------------------------------
// Create/update request
// ---------------------------------------------------------------------------

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class ShoppingItemCreate {
  final String shoppingListId;
  final String? note;
  final bool? isFood;
  final double? quantity;
  final String? foodId;
  final String? unitId;
  final String? labelId;
  final bool? checked;

  /// Rezept-Verknüpfung wie bei Mealies „Zur Einkaufsliste" ({recipeId,
  /// recipeQuantity, recipeScale, recipeNote}).
  @JsonKey(includeFromJson: false)
  final List<Map<String, dynamic>>? recipeReferences;

  const ShoppingItemCreate({
    required this.shoppingListId,
    this.note,
    this.isFood,
    this.quantity,
    this.foodId,
    this.unitId,
    this.labelId,
    this.checked,
    this.recipeReferences,
  });

  factory ShoppingItemCreate.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemCreateFromJson(json);

  Map<String, dynamic> toJson() => _$ShoppingItemCreateToJson(this);
}
