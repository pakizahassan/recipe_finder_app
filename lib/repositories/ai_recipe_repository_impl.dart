<<<<<<< HEAD
import 'package:recipe_finder_app/ai/gemini_recipe_service.dart';
=======
import 'package:recipe_finder_app/ai/ai_service.dart';
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
import 'package:recipe_finder_app/models/ai_recipe_model.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'package:recipe_finder_app/repositories/ai_recipe_repository.dart';

class AiRecipeRepositoryImpl implements AiRecipeRepository {
<<<<<<< HEAD
  AiRecipeRepositoryImpl({GeminiRecipeService? geminiService})
      : _service = geminiService ?? GeminiRecipeService();

  final GeminiRecipeService _service;

  @override
  Future<AiRecipe> generateRecipe(String foodName) async {
    final json = await _service.generateRecipeByName(foodName);
    return AiRecipeModel.fromJson(json);
  }
}
=======
  AiRecipeRepositoryImpl({AiService? aiService})
      : _service = aiService ?? AiService();

  final AiService _service;

  @override
  Future<AiRecipe> generateRecipe(String foodName) async {
    final json = await _service.generateRecipe(foodName);
    return AiRecipeModel.fromJson(json);
  }
}
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
