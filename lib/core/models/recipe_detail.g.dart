// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$RecipeDetailToJson(RecipeDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'dateAdded': instance.dateAdded,
      'dateUpdated': instance.dateUpdated,
      'lastMade': instance.lastMade,
      'prepTime': durationToString(instance.prepTime),
      'cookTime': durationToString(instance.cookTime),
      'totalTime': durationToString(instance.totalTime),
      'rating': instance.rating,
      'recipeYield': instance.recipeYield,
      'recipeServings': instance.servings,
      'rawRecipeYield': instance.rawYield,
      'settings': instance.settings?.toJson(),
      'recipeIngredient':
          instance.recipeIngredient.map((e) => e.toJson()).toList(),
      'recipeInstructions':
          instance.recipeInstructions.map((e) => e.toJson()).toList(),
      'nutrition': instance.nutrition,
      'notes': instance.notes.map((e) => e.toJson()).toList(),
      'recipeCategory': instance.recipeCategory.map((e) => e.toJson()).toList(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'tools': instance.tools.map((e) => e.toJson()).toList(),
      'comments': instance.comments.map((e) => e.toJson()).toList(),
      'assets': instance.assets.map((e) => e.toJson()).toList(),
      'userId': instance.userId,
      'householdId': instance.householdId,
      'orgURL': instance.orgUrl,
      'cacheSchema': instance.cacheSchema,
    };

Ingredient _$IngredientFromJson(Map<String, dynamic> json) => Ingredient(
      referenceId: json['referenceId'] as String?,
      quantity: _parseDouble(json['quantity']),
      unit: _parseIngredientUnit(json['unit']),
      food: _parseIngredientFood(json['food']),
      note: json['note'] as String?,
      isFood: json['isFood'] as bool?,
      disableAmount: json['disableAmount'] as bool?,
      title: json['title'] as String?,
      referencedRecipe: _parseReferencedRecipe(json['referencedRecipe']),
      originalText: json['originalText'] as String?,
    );

Map<String, dynamic> _$IngredientToJson(Ingredient instance) =>
    <String, dynamic>{
      'referenceId': instance.referenceId,
      'quantity': instance.quantity,
      'unit': _ingredientUnitToJson(instance.unit),
      'food': _ingredientFoodToJson(instance.food),
      'note': instance.note,
      'isFood': instance.isFood,
      'disableAmount': instance.disableAmount,
      'title': instance.title,
      'referencedRecipe': _referencedRecipeToJson(instance.referencedRecipe),
      'originalText': instance.originalText,
    };

IngredientUnit _$IngredientUnitFromJson(Map<String, dynamic> json) =>
    IngredientUnit(
      id: json['id'] as String?,
      name: json['name'] as String?,
      pluralName: json['pluralName'] as String?,
      abbreviation: json['abbreviation'] as String?,
    );

Map<String, dynamic> _$IngredientUnitToJson(IngredientUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pluralName': instance.pluralName,
      'abbreviation': instance.abbreviation,
    };

IngredientFood _$IngredientFoodFromJson(Map<String, dynamic> json) =>
    IngredientFood(
      id: json['id'] as String?,
      name: json['name'] as String?,
      pluralName: json['pluralName'] as String?,
    );

Map<String, dynamic> _$IngredientFoodToJson(IngredientFood instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pluralName': instance.pluralName,
    };

Instruction _$InstructionFromJson(Map<String, dynamic> json) => Instruction(
      id: json['id'] as String?,
      text: json['text'] as String,
      title: json['title'] as String?,
      summary: json['summary'] as String?,
      ingredientRefs: (json['ingredientReferences'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InstructionToJson(Instruction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
      'summary': instance.summary,
      'ingredientReferences': instance.ingredientRefs,
    };

RecipeSettings _$RecipeSettingsFromJson(Map<String, dynamic> json) =>
    RecipeSettings(
      public: json['public'] as bool? ?? false,
      showNutrition: json['showNutrition'] as bool? ?? false,
      showAssets: json['showAssets'] as bool? ?? false,
      landscapeView: json['landscapeView'] as bool? ?? false,
      disableComments: json['disableComments'] as bool? ?? true,
      disableAmount: json['disableAmount'] as bool? ?? false,
      locked: json['locked'] as bool? ?? false,
    );

Map<String, dynamic> _$RecipeSettingsToJson(RecipeSettings instance) =>
    <String, dynamic>{
      'public': instance.public,
      'showNutrition': instance.showNutrition,
      'showAssets': instance.showAssets,
      'landscapeView': instance.landscapeView,
      'disableComments': instance.disableComments,
      'disableAmount': instance.disableAmount,
      'locked': instance.locked,
    };

RecipeNote _$RecipeNoteFromJson(Map<String, dynamic> json) => RecipeNote(
      title: json['title'] as String,
      text: json['text'] as String,
    );

Map<String, dynamic> _$RecipeNoteToJson(RecipeNote instance) =>
    <String, dynamic>{
      'title': instance.title,
      'text': instance.text,
    };

RecipeTool _$RecipeToolFromJson(Map<String, dynamic> json) => RecipeTool(
      id: json['id'] as String,
      name: json['name'] as String,
      onHand: json['onHand'] as bool? ?? false,
      slug: json['slug'] as String? ?? '',
    );

Map<String, dynamic> _$RecipeToolToJson(RecipeTool instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'onHand': instance.onHand,
      'slug': instance.slug,
    };

CategorySummary _$CategorySummaryFromJson(Map<String, dynamic> json) =>
    CategorySummary(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$CategorySummaryToJson(CategorySummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

TagSummary _$TagSummaryFromJson(Map<String, dynamic> json) => TagSummary(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
    );

Map<String, dynamic> _$TagSummaryToJson(TagSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };
