import 'package:json_annotation/json_annotation.dart';
import 'recipe_detail.dart';

part 'recipe_summary.g.dart';

double? _parseRating(dynamic raw) {
  if (raw == null) return null;
  if (raw is num) return raw.toDouble();
  return double.tryParse(raw.toString());
}

@JsonSerializable(explicitToJson: true)
class RecipeSummary {
  final String id;
  final String slug;
  final String name;
  final String? description;
  final String? image;
  final String? dateAdded;
  final String? dateUpdated;
  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? prepTime;
  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? cookTime;
  @JsonKey(fromJson: parseDuration, toJson: durationToString)
  final int? totalTime;
  @JsonKey(fromJson: _parseRating)
  final double? rating;
  final List<CategorySummary> recipeCategory;
  final List<TagSummary> tags;

  const RecipeSummary({
    required this.id,
    required this.slug,
    required this.name,
    this.description,
    this.image,
    this.dateAdded,
    this.dateUpdated,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.rating,
    this.recipeCategory = const [],
    this.tags = const [],
  });

  factory RecipeSummary.fromJson(Map<String, dynamic> json) =>
      _$RecipeSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$RecipeSummaryToJson(this);
}
