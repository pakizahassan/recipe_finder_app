import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_finder_app/ai/ai_config.dart';
import 'package:recipe_finder_app/datasources/ai_recipe_cache_datasource.dart';
import 'package:recipe_finder_app/repositories/ai_recipe_repository_impl.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'package:recipe_finder_app/repositories/ai_recipe_repository.dart';

final aiRecipeRepositoryProvider = Provider<AiRecipeRepository>((ref) {
  AiRecipeCacheDatasource? cache;
  try {
    cache = AiRecipeCacheDatasource(Supabase.instance.client);
  } catch (_) {}
  return AiRecipeRepositoryImpl(cache: cache);
});

class AiRecipeNotifier extends AsyncNotifier<AiRecipe?> {
  @override
  Future<AiRecipe?> build() async => null;

  Future<void> generate(String foodName) async {
    if (!AiConfig.isConfigured) {
      state = AsyncError(
        const AiConfigurationException(AiConfig.missingApiKeyMessage),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(aiRecipeRepositoryProvider).generateRecipe(foodName),
    );
  }

  void reset() => state = const AsyncData(null);
}

final aiRecipeProvider =
    AsyncNotifierProvider<AiRecipeNotifier, AiRecipe?>(AiRecipeNotifier.new);

final savedAiRecipesProvider = FutureProvider<List<AiRecipe>>((ref) async {
  final repo = ref.watch(aiRecipeRepositoryProvider);
  // Add a getAllRecipes method to your repository interface + impl
  return repo.getAllRecipes();
});