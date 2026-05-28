import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loading_state.dart';
import '../providers/recipe_providers.dart';
import '../widgets/category_chips.dart';
import '../widgets/featured_recipe_banner.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_search_field.dart';
import '../widgets/section_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategoryId = 'all';

  @override
  Widget build(BuildContext context) {
    final recipesState = ref.watch(recipesControllerProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final featuredState = ref.watch(featuredRecipeProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 84,
        titleSpacing: AppSpacing.page,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What are we cooking?',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Premium recipes for everyday cravings',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.page),
            child: CircleAvatar(
              backgroundColor: AppColors.primarySoft,
              child: Text(
                'P',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                    ),
              ),
            ),
          ),
        ],
      ),
      body: recipesState.when(
        loading: () => const LoadingState(),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (recipes) {
          final filteredRecipes = _selectedCategoryId == 'all'
              ? recipes
              : recipes
                  .where((recipe) => recipe.categoryId == _selectedCategoryId)
                  .toList();

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () =>
                ref.read(recipesControllerProvider.notifier).load(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.page,
                      6,
                      AppSpacing.page,
                      AppSpacing.xxl,
                    ),
                    child: RecipeSearchField(
                      readOnly: true,
                      onTap: () => context.push('/search'),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: categoriesState.maybeWhen(
                    data: (categories) => CategoryChips(
                      categories: categories,
                      selectedId: _selectedCategoryId,
                      onSelected: (id) =>
                          setState(() => _selectedCategoryId = id),
                    ),
                    orElse: () => const SizedBox(height: 48),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                SliverToBoxAdapter(
                  child: featuredState.maybeWhen(
                    data: (recipe) => recipe == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.page,
                            ),
                            child: FeaturedRecipeBanner(
                              recipe: recipe,
                              onTap: () => context.push('/recipe/${recipe.id}'),
                              onFavoriteTap: () => ref
                                  .read(recipesControllerProvider.notifier)
                                  .toggleFavorite(recipe),
                            ),
                          ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Popular recipes',
                    onAction: () {},
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 238,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.page,
                      ),
                      itemCount: filteredRecipes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (context, index) {
                        final recipe = filteredRecipes[index];
                        return RecipeCard(
                          recipe: recipe,
                          width: 190,
                          onTap: () => context.push('/recipe/${recipe.id}'),
                          onFavoriteTap: () => ref
                              .read(recipesControllerProvider.notifier)
                              .toggleFavorite(recipe),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxl)),
                const SliverToBoxAdapter(child: _ChefRecommendationBand()),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ChefRecommendationBand extends StatelessWidget {
  const _ChefRecommendationBand();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_menu_rounded,
                  color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chef recommendations',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Balanced picks with high ratings and clear instructions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
