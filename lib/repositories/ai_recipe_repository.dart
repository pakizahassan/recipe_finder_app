import 'package:recipe_finder_app/entities/ai_recipe.dart';

abstract class AiRecipeRepository {
  Future<AiRecipe> generateRecipe(String foodName);
  Future<List<AiRecipe>> getAllRecipes();
}