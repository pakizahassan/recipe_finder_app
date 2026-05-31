import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_finder_app/models/ai_recipe_model.dart';

class AiRecipeCacheDatasource {
  AiRecipeCacheDatasource(this._client);
  final SupabaseClient _client;

  static const _table = 'ai_recipes';

  String _normalize(String name) =>
      name.toLowerCase().trim().replaceAll(RegExp(r'\s+'), ' ');

  Future<AiRecipeModel?> getCachedRecipe(String foodName) async {
    try {
      final rows = await _client
          .from(_table)
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
      await _client.from(_table).upsert({
        'food_name': foodName,
        'food_name_normalized': _normalize(foodName),
        ...recipe.toJson(),
      });
    } catch (_) {}
  }

  Future<List<AiRecipeModel>> getAllRecipes() async {
    try {
      final rows = await _client
          .from(_table)
          .select()
          .order('created_at', ascending: false)
          .limit(20);
      return rows
          .map((r) => AiRecipeModel.fromJson(Map<String, dynamic>.from(r)))
          .toList();
    } catch (_) {
      return [];
    }
  }
}