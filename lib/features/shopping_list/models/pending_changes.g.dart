// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_changes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingCheckChange _$PendingCheckChangeFromJson(Map<String, dynamic> json) =>
    PendingCheckChange(
      itemId: json['itemId'] as String,
      checked: json['checked'] as bool,
    );

Map<String, dynamic> _$PendingCheckChangeToJson(PendingCheckChange instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'checked': instance.checked,
    };

PendingQuantityChange _$PendingQuantityChangeFromJson(
        Map<String, dynamic> json) =>
    PendingQuantityChange(
      itemId: json['itemId'] as String,
      quantity: (json['quantity'] as num).toDouble(),
    );

Map<String, dynamic> _$PendingQuantityChangeToJson(
        PendingQuantityChange instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'quantity': instance.quantity,
    };

PendingDeleteChange _$PendingDeleteChangeFromJson(Map<String, dynamic> json) =>
    PendingDeleteChange(
      itemId: json['itemId'] as String,
    );

Map<String, dynamic> _$PendingDeleteChangeToJson(
        PendingDeleteChange instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
    };

PendingAddChange _$PendingAddChangeFromJson(Map<String, dynamic> json) =>
    PendingAddChange(
      id: json['id'] as String,
      note: json['note'] as String,
      labelId: json['labelId'] as String?,
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      shoppingListId: json['shoppingListId'] as String? ?? '',
    );

Map<String, dynamic> _$PendingAddChangeToJson(PendingAddChange instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      if (instance.labelId case final value?) 'labelId': value,
      'quantity': instance.quantity,
      'shoppingListId': instance.shoppingListId,
    };

PendingCategoryChange _$PendingCategoryChangeFromJson(
        Map<String, dynamic> json) =>
    PendingCategoryChange(
      itemId: json['itemId'] as String,
      labelId: json['labelId'] as String?,
    );

Map<String, dynamic> _$PendingCategoryChangeToJson(
        PendingCategoryChange instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      if (instance.labelId case final value?) 'labelId': value,
    };
