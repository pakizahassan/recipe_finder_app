import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../providers/recipe_providers.dart';
import '../widgets/recipe_image.dart';

class RecipeDetailsScreen extends ConsumerWidget {
  final String recipeId;

  const RecipeDetailsScreen({
    super.key,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesState = ref.watch(recipesControllerProvider);

    return Scaffold(
      body: recipesState.when(
        loading: () => const LoadingState(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (recipes) {
          final recipe = recipes.where((item) => item.id == recipeId).firstOrNull;
          if (recipe == null) {
            return const EmptyState(
              icon: Icons.no_meals_outlined,
              title: 'Recipe not found',
              message: 'This recipe is no longer available.',
            );
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 360,
                pinned: true,
                stretch: true,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: IconButton.filled(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
                actions: [
                  IconButton.filled(
                    onPressed: () => ref
                        .read(recipesControllerProvider.notifier)
                        .toggleFavorite(recipe),
                    icon: Icon(
                      recipe.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'recipe-image-${recipe.id}',
                    child: RecipeImage(imageUrl: recipe.imageUrl),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.page),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        recipe.description,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _StatTile(Icons.star_rounded, recipe.ratingLabel, 'Rating'),
                          const SizedBox(width: 10),
                          _StatTile(Icons.schedule_rounded, recipe.cookTimeLabel, 'Time'),
                          const SizedBox(width: 10),
                          _StatTile(Icons.local_fire_department_rounded,
                              '${recipe.calories}', 'Calories'),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _ContentSection(
                        title: 'Ingredients',
                        items: recipe.ingredients,
                      ),
                      const SizedBox(height: 28),
                      _ContentSection(
                        title: 'Instructions',
                        items: recipe.instructions,
                        numbered: true,
                      ),
                      const SizedBox(height: 28),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatTile(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ContentSection extends StatelessWidget {
  final String title;
  final List<String> items;
  final bool numbered;

  const _ContentSection({
    required this.title,
    required this.items,
    this.numbered = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 14),
        ...items.indexed.map((entry) {
          final index = entry.$1;
          final item = entry.$2;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    numbered ? '${index + 1}' : '',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(item, style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
