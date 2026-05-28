import '../entities/category.dart';
import '../entities/recipe.dart';

abstract class RecipeRepository {
  Future<List<RecipeCategory>> getCategories();
  Future<List<Recipe>> getRecipes();
  Future<List<Recipe>> searchRecipes(String query);
  Future<void> setFavorite(String recipeId, bool isFavorite);
}
