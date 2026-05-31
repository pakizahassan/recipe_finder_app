import 'package:recipe_finder_app/ai/ai_service.dart';
import 'package:recipe_finder_app/ai/recipe_image_service.dart';
import 'package:recipe_finder_app/datasources/ai_recipe_cache_datasource.dart';
import 'package:recipe_finder_app/models/ai_recipe_model.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'ai_recipe_repository.dart';

class AiRecipeRepositoryImpl implements AiRecipeRepository {
  AiRecipeRepositoryImpl({
    AiService? aiService,
    AiRecipeCacheDatasource? cache,
  })  : _service = aiService ?? AiService(),
        _cache = cache;

  final AiService _service;
  final AiRecipeCacheDatasource? _cache;

  @override
  Future<AiRecipe> generateRecipe(String foodName) async {
    final cached = await _cache?.getCachedRecipe(foodName);
    if (cached != null) return cached;

    final json = await _service.generateRecipe(foodName);

    final imageUrl = await RecipeImageService.fetchImageUrl(foodName);
    if (imageUrl != null) json['image_url'] = imageUrl;

    final recipe = AiRecipeModel.fromJson(json);

    _cache?.saveRecipe(foodName, recipe).ignore();
    _cache?.saveToRecipesTable(recipe).ignore();

    return recipe;
  }

  @override
  Future<List<AiRecipe>> getAllRecipes() async {
    final cache = _cache;
    if (cache == null) return [];
    return cache.getAllRecipes();
  }
}
