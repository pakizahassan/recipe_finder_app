import 'package:recipe_finder_app/entities/ai_recipe.dart';

class AiRecipeModel extends AiRecipe {
  const AiRecipeModel({
    required super.title,
    required super.description,
    required super.ingredients,
    required super.steps,
    required super.cookingTime,
    required super.calories,
    required super.servings,
    required super.chefTips,
  });

  factory AiRecipeModel.fromJson(Map<String, dynamic> json) {
    return AiRecipeModel(
      title: _str(json['title']) ?? 'AI Generated Recipe',
      description: _str(json['description']) ?? '',
      ingredients: _list(json['ingredients']),
      steps: _list(json['steps']),
      cookingTime: _str(json['cooking_time']) ?? '',
      calories: _str(json['calories']) ?? '',
      servings: _str(json['servings']) ?? '',
      chefTips: _str(json['chef_tips']) ?? '',
    );
  }

  static String? _str(dynamic v) => v is String ? v : null;

  static List<String> _list(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return [v];
    return [];
  }
}
