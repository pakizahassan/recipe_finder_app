import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:recipe_finder_app/config/supabase_config.dart';
import 'package:recipe_finder_app/datasources/recipe_remote_data_source.dart';
import 'package:recipe_finder_app/repositories/recipe_repository_impl.dart';
import 'package:recipe_finder_app/entities/category.dart';
import 'package:recipe_finder_app/entities/recipe.dart';
import 'package:recipe_finder_app/repositories/recipe_repository.dart';

final recipeRepositoryProvider = Provider<RecipeRepository>((ref) {
  final remote = SupabaseConfig.isConfigured
      ? RecipeRemoteDataSource(Supabase.instance.client)
      : null;
  return RecipeRepositoryImpl(remoteDataSource: remote);
});

final categoriesProvider = FutureProvider<List<RecipeCategory>>((ref) {
  return ref.watch(recipeRepositoryProvider).getCategories();
});

final recipesControllerProvider =
    StateNotifierProvider<RecipesController, AsyncValue<List<Recipe>>>((ref) {
  return RecipesController(ref.watch(recipeRepositoryProvider))..load();
});

final featuredRecipeProvider = Provider<AsyncValue<Recipe?>>((ref) {
  return ref.watch(recipesControllerProvider).whenData((recipes) {
    return recipes.where((recipe) => recipe.isFeatured).firstOrNull ??
        recipes.firstOrNull;
  });
});

final favoriteRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  return ref.watch(recipesControllerProvider).whenData(
        (recipes) => recipes.where((recipe) => recipe.isFavorite).toList(),
      );
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider = Provider.autoDispose<AsyncValue<List<Recipe>>>(
  (ref) {
    final query = ref.watch(searchQueryProvider);
    return ref.watch(recipesControllerProvider).whenData((recipes) {
      final normalized = query.trim().toLowerCase();
      if (normalized.isEmpty) return recipes;

      return recipes.where((recipe) {
        return recipe.title.toLowerCase().contains(normalized) ||
            recipe.description.toLowerCase().contains(normalized) ||
            recipe.categoryId.toLowerCase().contains(normalized);
      }).toList();
    });
  },
);

class RecipesController extends StateNotifier<AsyncValue<List<Recipe>>> {
  final RecipeRepository repository;

  RecipesController(this.repository) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(repository.getRecipes);
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final previous = state;
    final nextFavoriteValue = !recipe.isFavorite;

    state = state.whenData((recipes) {
      return recipes.map((item) {
        if (item.id != recipe.id) return item;
        return item.copyWith(isFavorite: nextFavoriteValue);
      }).toList();
    });

    try {
      await repository.setFavorite(recipe.id, nextFavoriteValue);
    } catch (error, stackTrace) {
      state = previous;
      Error.throwWithStackTrace(error, stackTrace);
    }
  }
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
