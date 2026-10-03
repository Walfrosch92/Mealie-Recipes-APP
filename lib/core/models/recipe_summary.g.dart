// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecipeSummary _$RecipeSummaryFromJson(Map<String, dynamic> json) =>
    RecipeSummary(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] as String?,
      dateAdded: json['dateAdded'] as String?,
      dateUpdated: json['dateUpdated'] as String?,
      prepTime: parseDuration(json['prepTime']),
      cookTime: parseDuration(json['cookTime']),
      totalTime: parseDuration(json['totalTime']),
      rating: _parseRating(json['rating']),
      recipeCategory: (json['recipeCategory'] as List<dynamic>?)
              ?.map((e) => CategorySummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => TagSummary.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$RecipeSummaryToJson(RecipeSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'dateAdded': instance.dateAdded,
      'dateUpdated': instance.dateUpdated,
      'prepTime': durationToString(instance.prepTime),
      'cookTime': durationToString(instance.cookTime),
      'totalTime': durationToString(instance.totalTime),
      'rating': instance.rating,
      'recipeCategory': instance.recipeCategory.map((e) => e.toJson()).toList(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
    };
