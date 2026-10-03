import 'package:json_annotation/json_annotation.dart';

part 'pending_changes.g.dart';

// ---------------------------------------------------------------------------
// Pending change models — 1:1 port of Swift ShoppingListViewModel structs:
//   PendingCheckChange    { itemId: UUID, checked: Bool }
//   PendingQuantityChange { itemId: UUID, quantity: Double }
//   PendingDeleteChange   { itemId: UUID }
//   PendingAddChange      { id: UUID, note: String, labelId: String? }
//   PendingCategoryChange { itemId: UUID, labelId: String? }
//
// `itemId` / `id` werden als String (UUID-Form) geführt, exakt wie der
// bestehende ShoppingItem.id-Typ im Flutter-Modell.
// ---------------------------------------------------------------------------

@JsonSerializable()
class PendingCheckChange {
  final String itemId;
  final bool checked;

  const PendingCheckChange({required this.itemId, required this.checked});

  factory PendingCheckChange.fromJson(Map<String, dynamic> json) =>
      _$PendingCheckChangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingCheckChangeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PendingCheckChange &&
      other.itemId == itemId &&
      other.checked == checked;
  @override
  int get hashCode => Object.hash(itemId, checked);
}

@JsonSerializable()
class PendingQuantityChange {
  final String itemId;
  final double quantity;

  const PendingQuantityChange({required this.itemId, required this.quantity});

  factory PendingQuantityChange.fromJson(Map<String, dynamic> json) =>
      _$PendingQuantityChangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingQuantityChangeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PendingQuantityChange &&
      other.itemId == itemId &&
      other.quantity == quantity;
  @override
  int get hashCode => Object.hash(itemId, quantity);
}

@JsonSerializable()
class PendingDeleteChange {
  final String itemId;

  const PendingDeleteChange({required this.itemId});

  factory PendingDeleteChange.fromJson(Map<String, dynamic> json) =>
      _$PendingDeleteChangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingDeleteChangeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PendingDeleteChange && other.itemId == itemId;
  @override
  int get hashCode => itemId.hashCode;
}

@JsonSerializable(includeIfNull: false)
class PendingAddChange {
  /// Eigene UUID des Pending-Adds (mirrors Swift `let id: UUID`).
  /// Wird gleichzeitig als ID des lokalen Dummy-ShoppingItem benutzt, damit
  /// nachträgliche Änderungen (Check/Qty/Delete) konsistent referenzieren.
  final String id;
  final String note;
  final String? labelId;

  /// Artikelmenge — 1 außer bei „exakte Mengen"-Adds (z. B. 200 für
  /// „200 g Butter"). Default 1 hält alte gecachte Einträge kompatibel.
  final double quantity;

  /// Ziel-Einkaufsliste dieses Adds — MUSS beim Nachschieben (sobald die
  /// Verbindung zurückkehrt) verwendet werden, nicht die gerade aktive Liste
  /// aus den Settings. Sonst landet ein offline auf Liste A erfasster
  /// Artikel auf Liste B, falls der User zwischenzeitlich die aktive Liste
  /// gewechselt hat. Default '' hält alte gecachte Einträge (vor diesem
  /// Feld) kompatibel — der Sync-Code fällt dann auf die aktuell aktive
  /// Liste zurück (bisheriges Verhalten).
  final String shoppingListId;

  const PendingAddChange({
    required this.id,
    required this.note,
    this.labelId,
    this.quantity = 1,
    this.shoppingListId = '',
  });

  factory PendingAddChange.fromJson(Map<String, dynamic> json) =>
      _$PendingAddChangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingAddChangeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PendingAddChange &&
      other.id == id &&
      other.note == note &&
      other.labelId == labelId &&
      other.quantity == quantity &&
      other.shoppingListId == shoppingListId;
  @override
  int get hashCode => Object.hash(id, note, labelId, quantity, shoppingListId);
}

@JsonSerializable(includeIfNull: false)
class PendingCategoryChange {
  final String itemId;
  final String? labelId;

  const PendingCategoryChange({required this.itemId, this.labelId});

  factory PendingCategoryChange.fromJson(Map<String, dynamic> json) =>
      _$PendingCategoryChangeFromJson(json);
  Map<String, dynamic> toJson() => _$PendingCategoryChangeToJson(this);

  @override
  bool operator ==(Object other) =>
      other is PendingCategoryChange &&
      other.itemId == itemId &&
      other.labelId == labelId;
  @override
  int get hashCode => Object.hash(itemId, labelId);
}

// ---------------------------------------------------------------------------
// Aggregated state
// ---------------------------------------------------------------------------

class PendingShoppingChangesState {
  final List<PendingCheckChange> checks;
  final List<PendingQuantityChange> quantities;
  final List<PendingDeleteChange> deletes;
  final List<PendingAddChange> adds;
  final List<PendingCategoryChange> categories;

  const PendingShoppingChangesState({
    this.checks = const [],
    this.quantities = const [],
    this.deletes = const [],
    this.adds = const [],
    this.categories = const [],
  });

  bool get hasChanges =>
      checks.isNotEmpty ||
      quantities.isNotEmpty ||
      deletes.isNotEmpty ||
      adds.isNotEmpty ||
      categories.isNotEmpty;

  PendingShoppingChangesState copyWith({
    List<PendingCheckChange>? checks,
    List<PendingQuantityChange>? quantities,
    List<PendingDeleteChange>? deletes,
    List<PendingAddChange>? adds,
    List<PendingCategoryChange>? categories,
  }) {
    return PendingShoppingChangesState(
      checks: checks ?? this.checks,
      quantities: quantities ?? this.quantities,
      deletes: deletes ?? this.deletes,
      adds: adds ?? this.adds,
      categories: categories ?? this.categories,
    );
  }
}
