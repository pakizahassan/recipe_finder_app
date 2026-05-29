import 'package:recipe_finder_app/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.rating,
    required super.cookTimeMinutes,
    required super.categoryId,
    required super.description,
    required super.calories,
    required super.ingredients,
    required super.instructions,
    super.isFeatured,
    super.isFavorite,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      cookTimeMinutes: json['cook_time_minutes'] as int? ?? 0,
      categoryId: json['category_id'] as String? ?? 'all',
      description: json['description'] as String? ?? '',
      calories: json['calories'] as int? ?? 0,
      ingredients: _stringList(json['ingredients']),
      instructions: _stringList(json['instructions']),
      isFeatured: json['is_featured'] as bool? ?? false,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  static List<String> _stringList(Object? value) {
    if (value is List) {
      return value.map((item) => item.toString()).toList();
    }
    return const [];
  }
}
