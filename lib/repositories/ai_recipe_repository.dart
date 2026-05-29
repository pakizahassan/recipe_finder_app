import 'package:recipe_finder_app/entities/ai_recipe.dart';

abstract interface class AiRecipeRepository {
  Future<AiRecipe> generateRecipe(String foodName);
}
