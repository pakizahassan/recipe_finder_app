import 'package:recipe_finder_app/ai/gemini_recipe_service.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'package:recipe_finder_app/models/ai_recipe_model.dart';

import 'ai_recipe_repository.dart';

class AiRecipeRepositoryImpl implements AiRecipeRepository {
  AiRecipeRepositoryImpl({GeminiRecipeService? geminiService})
      : _service = geminiService ?? GeminiRecipeService();

  final GeminiRecipeService _service;

  @override
  Future<AiRecipe> generateRecipe(String foodName) async {
    final json = await _service.generateRecipeByName(foodName);
    return AiRecipeModel.fromJson(json);
  }
}
