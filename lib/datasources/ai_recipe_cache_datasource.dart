import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_finder_app/models/ai_recipe_model.dart';

class AiRecipeCacheDatasource {
  AiRecipeCacheDatasource(this._client);
  final SupabaseClient _client;

  static const _cacheTable = 'ai_recipes';
  static const _recipesTable = 'recipes';

  String _normalize(String name) =>
      name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  Future<AiRecipeModel?> getCachedRecipe(String foodName) async {
    try {
      final rows = await _client
          .from(_cacheTable)
          .select()
          .eq('food_name_normalized', _normalize(foodName))
          .limit(1);
      if (rows.isEmpty) return null;
      return AiRecipeModel.fromJson(Map<String, dynamic>.from(rows.first));
    } catch (_) {
      return null;
    }
  }

  Future<void> saveRecipe(String foodName, AiRecipeModel recipe) async {
    try {
      await _client.from(_cacheTable).upsert({
        'food_name': foodName,
        'food_name_normalized': _normalize(foodName),
        ...recipe.toJson(),
      });
    } catch (_) {}
  }

  Future<List<AiRecipeModel>> getAllRecipes() async {
    try {
      final rows = await _client
          .from(_cacheTable)
          .select()
          .order('created_at', ascending: false);
      return rows
          .map((row) => AiRecipeModel.fromJson(Map<String, dynamic>.from(row)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveToRecipesTable(AiRecipeModel recipe) async {
    try {
      await _client.from(_recipesTable).upsert(
        {
          'title': recipe.title,
          'image_url': recipe.imageUrl ?? '',
          'rating': 0.0,
          'cook_time_minutes': _parseMinutes(recipe.cookingTime),
          'category_id': 'all',
          'description': recipe.description,
          'calories': _parseCalories(recipe.calories),
          'ingredients': recipe.ingredients,
          'instructions': recipe.steps,
          'is_featured': false,
        },
        onConflict: 'title',
      );
    } catch (_) {}
  }

  static int _parseMinutes(String cookingTime) {
    final match = RegExp(r'(\d+)').firstMatch(cookingTime);
    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
  }

  static int _parseCalories(String calories) {
    final match = RegExp(r'(\d+)').firstMatch(calories);
    return match != null ? int.tryParse(match.group(1)!) ?? 0 : 0;
  }
}
