// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) => ShoppingItem(
      id: json['id'] as String,
      shoppingListId: json['shoppingListId'] as String?,
      checked: json['checked'] as bool? ?? false,
      position: (json['position'] as num?)?.toInt(),
      label: json['label'] == null
          ? null
          : ShoppingLabel.fromJson(json['label'] as Map<String, dynamic>),
      note: json['note'] as String?,
      isFood: json['isFood'] as bool? ?? false,
      quantity: (json['quantity'] as num?)?.toDouble(),
      food: json['food'] == null
          ? null
          : ShoppingFood.fromJson(json['food'] as Map<String, dynamic>),
      unit: json['unit'] == null
          ? null
          : ShoppingUnit.fromJson(json['unit'] as Map<String, dynamic>),
      display: json['display'] as String?,
      recipeReferences: (json['recipeReferences'] as List<dynamic>?)
              ?.whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList() ??
          const [],
      extras: (json['extras'] as Map?)?.cast<String, dynamic>(),
    );

Map<String, dynamic> _$ShoppingItemToJson(ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shoppingListId': instance.shoppingListId,
      'checked': instance.checked,
      'position': instance.position,
      'label': instance.label?.toJson(),
      'note': instance.note,
      'isFood': instance.isFood,
      'quantity': instance.quantity,
      'food': instance.food?.toJson(),
      'unit': instance.unit?.toJson(),
      'display': instance.display,
      'recipeReferences': instance.recipeReferences,
      'extras': instance.extras,
    };

ShoppingLabel _$ShoppingLabelFromJson(Map<String, dynamic> json) =>
    ShoppingLabel(
      id: json['id'] as String,
      name: json['name'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$ShoppingLabelToJson(ShoppingLabel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
    };

ShoppingFood _$ShoppingFoodFromJson(Map<String, dynamic> json) => ShoppingFood(
      id: json['id'] as String?,
      name: json['name'] as String?,
      pluralName: json['pluralName'] as String?,
      householdsWithIngredientFood:
          (json['householdsWithIngredientFood'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      onHand: json['onHand'] as bool?,
      labelId: json['labelId'] as String?,
    );

Map<String, dynamic> _$ShoppingFoodToJson(ShoppingFood instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pluralName': instance.pluralName,
      'householdsWithIngredientFood': instance.householdsWithIngredientFood,
      'onHand': instance.onHand,
      'labelId': instance.labelId,
    };

ShoppingUnit _$ShoppingUnitFromJson(Map<String, dynamic> json) => ShoppingUnit(
      id: json['id'] as String?,
      name: json['name'] as String?,
      pluralName: json['pluralName'] as String?,
      abbreviation: json['abbreviation'] as String?,
    );

Map<String, dynamic> _$ShoppingUnitToJson(ShoppingUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pluralName': instance.pluralName,
      'abbreviation': instance.abbreviation,
    };

ShoppingItemCreate _$ShoppingItemCreateFromJson(Map<String, dynamic> json) =>
    ShoppingItemCreate(
      shoppingListId: json['shoppingListId'] as String,
      note: json['note'] as String?,
      isFood: json['isFood'] as bool?,
      quantity: (json['quantity'] as num?)?.toDouble(),
      foodId: json['foodId'] as String?,
      unitId: json['unitId'] as String?,
      labelId: json['labelId'] as String?,
      checked: json['checked'] as bool?,
    );

Map<String, dynamic> _$ShoppingItemCreateToJson(ShoppingItemCreate instance) =>
    <String, dynamic>{
      'shoppingListId': instance.shoppingListId,
      if (instance.note case final value?) 'note': value,
      if (instance.isFood case final value?) 'isFood': value,
      if (instance.quantity case final value?) 'quantity': value,
      if (instance.foodId case final value?) 'foodId': value,
      if (instance.unitId case final value?) 'unitId': value,
      if (instance.labelId case final value?) 'labelId': value,
      if (instance.checked case final value?) 'checked': value,
      if (instance.recipeReferences case final value?)
        'recipeReferences': value,
    };
