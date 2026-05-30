import 'package:recipe_finder_app/utils/recipe_seed_data.dart';
import 'package:recipe_finder_app/models/category_model.dart';
import 'package:recipe_finder_app/entities/category.dart';
import 'package:recipe_finder_app/entities/recipe.dart';
import 'package:recipe_finder_app/repositories/recipe_repository.dart';
import 'package:recipe_finder_app/datasources/recipe_remote_data_source.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource? remoteDataSource;
  List<Recipe> _recipes = seedRecipes;

  RecipeRepositoryImpl({this.remoteDataSource});

  static const _allCategory = CategoryModel(id: 'all', name: 'All', icon: 'Dining');

  @override
  Future<List<RecipeCategory>> getCategories() async {
    if (remoteDataSource == null) return seedCategories;

    try {
      final categories = await remoteDataSource!.getCategories();
      if (categories.isEmpty) return seedCategories;
      return [_allCategory, ...categories];
    } catch (_) {
      return seedCategories;
    }
  }

  @override
  Future<List<Recipe>> getRecipes() async {
    if (remoteDataSource == null) return _recipes;

    try {
      final recipes = await remoteDataSource!.getRecipes();
      _recipes = recipes.isEmpty ? seedRecipes : recipes;
      return _recipes;
    } catch (_) {
      return _recipes;
    }
  }

  @override
  Future<List<Recipe>> searchRecipes(String query) async {
    final recipes = await getRecipes();
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return recipes;

    return recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(normalized) ||
          recipe.description.toLowerCase().contains(normalized) ||
          recipe.categoryId.toLowerCase().contains(normalized);
    }).toList();
  }

  @override
  Future<void> setFavorite(String recipeId, bool isFavorite) async {
    _recipes = _recipes.map((recipe) {
      if (recipe.id != recipeId) return recipe;
      return recipe.copyWith(isFavorite: isFavorite);
    }).toList();

    await remoteDataSource?.setFavorite(recipeId, isFavorite);
  }
}
