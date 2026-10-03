// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mealplan_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MealplanEntry _$MealplanEntryFromJson(Map<String, dynamic> json) =>
    MealplanEntry(
      id: _idToString(json['id']),
      groupId: _idToStringNullable(json['groupId']),
      date: json['date'] as String,
      entryType: json['entryType'] as String,
      title: json['title'] as String?,
      text: json['text'] as String?,
      recipe: json['recipe'] == null
          ? null
          : RecipeSummary.fromJson(json['recipe'] as Map<String, dynamic>),
      householdId: _idToStringNullable(json['householdId']),
      userId: _idToStringNullable(json['userId']),
      recipeId: _idToStringNullable(json['recipeId']),
    );

Map<String, dynamic> _$MealplanEntryToJson(MealplanEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'groupId': instance.groupId,
      'date': instance.date,
      'entryType': instance.entryType,
      'title': instance.title,
      'text': instance.text,
      'recipe': instance.recipe?.toJson(),
      'householdId': instance.householdId,
      'userId': instance.userId,
      'recipeId': instance.recipeId,
    };

MealplanEntryCreate _$MealplanEntryCreateFromJson(Map<String, dynamic> json) =>
    MealplanEntryCreate(
      date: json['date'] as String,
      entryType: json['entryType'] as String,
      title: json['title'] as String?,
      recipeId: json['recipeId'] as String?,
    );

Map<String, dynamic> _$MealplanEntryCreateToJson(
        MealplanEntryCreate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'entryType': instance.entryType,
      if (instance.title case final value?) 'title': value,
      if (instance.recipeId case final value?) 'recipeId': value,
    };
