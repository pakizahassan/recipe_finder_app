import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:recipe_finder_app/constants/app_spacing.dart';
import 'package:recipe_finder_app/theme/app_theme.dart';
import 'package:recipe_finder_app/widgets/empty_state.dart';
import 'package:recipe_finder_app/widgets/loading_state.dart';
import 'package:recipe_finder_app/widgets/user_avatar.dart';
import 'package:recipe_finder_app/providers/auth_providers.dart';
import 'package:recipe_finder_app/providers/profile_providers.dart';
import 'package:recipe_finder_app/providers/navigation_provider.dart';
import 'package:recipe_finder_app/providers/recipe_providers.dart';
import 'package:recipe_finder_app/widgets/category_chips.dart';
import 'package:recipe_finder_app/widgets/featured_recipe_banner.dart';
import 'package:recipe_finder_app/widgets/recipe_card.dart';
import 'package:recipe_finder_app/widgets/recipe_search_field.dart';
import 'package:recipe_finder_app/widgets/section_header.dart';

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
    final user = ref.watch(currentUserProvider).valueOrNull;
    final profile = ref.watch(profileNotifierProvider).valueOrNull;

    final firstName =
        (profile?.displayName ?? user?.displayName ?? 'Chef').split(' ').first;
    final avatarUrl = profile?.avatarUrl;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        titleSpacing: AppSpacing.page,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
                children: [
                  const TextSpan(text: 'Hi, '),
                  TextSpan(
                    text: firstName,
                    style: const TextStyle(color: AppColors.primary),
                  ),
                  const TextSpan(text: ' 👋'),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'What are we cooking today?',
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton.filledTonal(
            onPressed: () {},
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_outlined),
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.page),
            child: GestureDetector(
              onTap: () =>
                  ref.read(shellTabProvider.notifier).state = 4,
              child: UserAvatar(
                avatarUrl: avatarUrl,
                displayName: firstName,
                radius: 20,
              ),
            ),
          ),
        ],
      ),
      body: recipesState.when(
        loading: () => const LoadingState(),
        error: (error, _) => const EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Recipes could not load',
          message: 'Pull to refresh or check your connection.',
        ),
        data: (recipes) {
          final filteredRecipes = _selectedCategoryId == 'all'
              ? recipes
              : recipes
                  .where(
                      (r) => r.categoryId == _selectedCategoryId)
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
                        AppSpacing.page, 6, AppSpacing.page, AppSpacing.xxl),
                    child: RecipeSearchField(
                      readOnly: true,
                      onTap: () => context.push('/search'),
                      onFilterTap: () => context.push('/search'),
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
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xxl)),
                SliverToBoxAdapter(
                  child: featuredState.maybeWhen(
                    data: (recipe) => recipe == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.page),
                            child: FeaturedRecipeBanner(
                              recipe: recipe,
                              onTap: () =>
                                  context.push('/recipe/${recipe.id}'),
                              onFavoriteTap: () => ref
                                  .read(recipesControllerProvider.notifier)
                                  .toggleFavorite(recipe),
                            ),
                          ),
                    orElse: () => const SizedBox.shrink(),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xxl)),
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Popular recipes',
                    onAction: () => context.push('/search'),
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.md)),
                filteredRecipes.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.page),
                          child: EmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No recipes in this category',
                            message:
                                'Choose another category to keep browsing.',
                          ),
                        ),
                      )
                    : SliverToBoxAdapter(
                        child: SizedBox(
                          height: 238,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.page),
                            itemCount: filteredRecipes.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 14),
                            itemBuilder: (context, index) {
                              final recipe = filteredRecipes[index];
                              return RecipeCard(
                                recipe: recipe,
                                width: 190,
                                onTap: () => context
                                    .push('/recipe/${recipe.id}'),
                                onFavoriteTap: () => ref
                                    .read(recipesControllerProvider
                                        .notifier)
                                    .toggleFavorite(recipe),
                              );
                            },
                          ),
                        ),
                      ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xxl)),
                const SliverToBoxAdapter(
                    child: _ChefRecommendationBand()),
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
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restaurant_menu_rounded,
                  color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chef recommendations',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Balanced picks with high ratings and clear instructions.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
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
