import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/category_model.dart';
import '../models/recipe_model.dart';

class RecipeRemoteDataSource {
  final SupabaseClient client;

  RecipeRemoteDataSource(this.client);

  Future<List<CategoryModel>> getCategories() async {
    final rows = await client.from('categories').select().order('name');
    return rows.map(CategoryModel.fromJson).toList();
  }

  Future<List<RecipeModel>> getRecipes() async {
    final rows = await client.from('recipes').select().order('rating');
    return rows.map(RecipeModel.fromJson).toList();
  }

  Future<void> setFavorite(String recipeId, bool isFavorite) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    if (isFavorite) {
      await client.from('favorites').upsert({
        'recipe_id': recipeId,
        'user_id': userId,
      });
    } else {
      await client
          .from('favorites')
          .delete()
          .eq('recipe_id', recipeId)
          .eq('user_id', userId);
    }
  }
}
