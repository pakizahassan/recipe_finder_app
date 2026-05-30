import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_finder_app/repositories/ai_recipe_repository_impl.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'package:recipe_finder_app/repositories/ai_recipe_repository.dart';

final aiRecipeRepositoryProvider = Provider<AiRecipeRepository>(
  (_) => AiRecipeRepositoryImpl(),
);

class AiRecipeNotifier extends AsyncNotifier<AiRecipe?> {
  @override
  Future<AiRecipe?> build() async => null;

  Future<void> generate(String foodName) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(aiRecipeRepositoryProvider).generateRecipe(foodName),
    );
  }

  void reset() => state = const AsyncData(null);
}

final aiRecipeProvider =
    AsyncNotifierProvider<AiRecipeNotifier, AiRecipe?>(AiRecipeNotifier.new);
