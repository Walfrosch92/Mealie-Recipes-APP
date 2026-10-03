import 'package:json_annotation/json_annotation.dart';
import 'recipe_summary.dart';

part 'mealplan_entry.g.dart';

// Mealie returns the mealplan entry `id` as an INTEGER (auto-increment),
// while recipe ids are UUID strings. Parse tolerantly to String.
String _idToString(dynamic v) => v?.toString() ?? '';
String? _idToStringNullable(dynamic v) => v?.toString();

@JsonSerializable(explicitToJson: true)
class MealplanEntry {
  @JsonKey(fromJson: _idToString)
  final String id;
  @JsonKey(name: 'groupId', fromJson: _idToStringNullable)
  final String? groupId;
  final String date; // "YYYY-MM-DD"
  final String entryType; // breakfast | lunch | dinner | side
  final String? title;
  final String? text;
  final RecipeSummary? recipe;
  // Optionale Server-Felder — mirror iOS MealplanEntry.swift
  // (householdId / userId / recipeId werden vom Server zurückgegeben,
  // aktuell nicht im UI verwendet, aber im Modell vorgesehen).
  @JsonKey(fromJson: _idToStringNullable)
  final String? householdId;
  @JsonKey(fromJson: _idToStringNullable)
  final String? userId;
  @JsonKey(fromJson: _idToStringNullable)
  final String? recipeId;

  const MealplanEntry({
    required this.id,
    this.groupId,
    required this.date,
    required this.entryType,
    this.title,
    this.text,
    this.recipe,
    this.householdId,
    this.userId,
    this.recipeId,
  });

  factory MealplanEntry.fromJson(Map<String, dynamic> json) =>
      _$MealplanEntryFromJson(json);

  Map<String, dynamic> toJson() => _$MealplanEntryToJson(this);
}

// 1:1 zum Swift `Payload`-Struct in APIService.addMealEntry:
//   struct Payload: Codable {
//       let date: String
//       let entryType: String
//       let recipeId: String?
//       let title: String?
//   }
// `includeIfNull: false` bildet Swifts Codable-Default exakt nach:
// auto-synthesized `encode(to:)` ruft für Optionals `encodeIfPresent` auf,
// d.h. nil-Felder werden komplett aus dem JSON weggelassen (nicht als
// `null` serialisiert). Ohne das wirft Mealie ein 422, weil das Create-
// Schema `title: str = ""` als non-nullable validiert.
// Freitext-Einträge laufen über `title`, exakt wie iOS:
//   title: recipeId == nil ? note : nil
// (Mutex-Logik in MealplanNotifier.addEntry.)
@JsonSerializable(includeIfNull: false)
class MealplanEntryCreate {
  final String date;
  final String entryType;
  final String? title;
  final String? recipeId;

  const MealplanEntryCreate({
    required this.date,
    required this.entryType,
    this.title,
    this.recipeId,
  });

  factory MealplanEntryCreate.fromJson(Map<String, dynamic> json) =>
      _$MealplanEntryCreateFromJson(json);

  Map<String, dynamic> toJson() => _$MealplanEntryCreateToJson(this);
}
