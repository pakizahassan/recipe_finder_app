import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:recipe_finder_app/constants/app_spacing.dart';
import 'package:recipe_finder_app/widgets/empty_state.dart';
import 'package:recipe_finder_app/widgets/loading_state.dart';
import 'package:recipe_finder_app/providers/recipe_providers.dart';
import 'package:recipe_finder_app/widgets/recipe_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteRecipesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.when(
        loading: () => const LoadingState(),
        error: (error, _) => const EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Favorites could not load',
          message: 'Refresh the app and try again.',
        ),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const EmptyState(
              icon: Icons.favorite_border_rounded,
              title: 'No favorites yet',
              message: 'Save recipes you love and they will appear here.',
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 900
                  ? 4
                  : constraints.maxWidth >= 620
                      ? 3
                      : 2;

              return GridView.builder(
                padding: const EdgeInsets.all(AppSpacing.page),
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.78,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return RecipeCard(
                    recipe: recipe,
                    onTap: () => context.push('/recipe/${recipe.id}'),
                    onFavoriteTap: () => ref
                        .read(recipesControllerProvider.notifier)
                        .toggleFavorite(recipe),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
