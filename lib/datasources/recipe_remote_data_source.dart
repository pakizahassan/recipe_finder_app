import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:recipe_finder_app/models/category_model.dart';
import 'package:recipe_finder_app/models/recipe_model.dart';

class RecipeRemoteDataSource {
  RecipeRemoteDataSource(this._client);
  final SupabaseClient _client;

  Future<List<CategoryModel>> getCategories() async {
    final rows = await _client.from('categories').select().order('name');
    return rows.map(CategoryModel.fromJson).toList();
  }

  Future<List<RecipeModel>> getRecipes() async {
    final userId = _client.auth.currentUser?.id;

    // Fetch all recipes ordered by rating desc
    final rows = await _client
        .from('recipes')
        .select()
        .order('rating', ascending: false);

    // Fetch user's favorites in one extra query
    Set<String> favoriteIds = {};
    if (userId != null) {
      final favRows = await _client
          .from('favorites')
          .select('recipe_id')
          .eq('user_id', userId);
      favoriteIds = {
        for (final r in favRows) r['recipe_id'] as String
      };
    }

    return rows.map((row) {
      return RecipeModel.fromJson({
        ...row,
        'is_favorite': favoriteIds.contains(row['id'] as String),
      });
    }).toList();
  }

  Future<void> setFavorite(String recipeId, bool isFavorite) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    if (isFavorite) {
      await _client.from('favorites').upsert({
        'recipe_id': recipeId,
        'user_id': userId,
      });
    } else {
      await _client
          .from('favorites')
          .delete()
          .eq('recipe_id', recipeId)
          .eq('user_id', userId);
    }
  }
}
