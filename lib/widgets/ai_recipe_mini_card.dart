import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';
import 'package:recipe_finder_app/theme/app_theme.dart';

class AiRecipeMiniCard extends StatelessWidget {
  const AiRecipeMiniCard({
    super.key,
    required this.recipe,
    this.onTap,
    this.width = 160,
  });

  final AiRecipe recipe;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ────────────────────────────────────────────
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadii.lg),
              ),
              child: SizedBox(
                height: 110,
                width: double.infinity,
                child: recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: recipe.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => const _ImagePlaceholder(),
                        errorWidget: (_, __, ___) => const _ImagePlaceholder(),
                      )
                    : const _ImagePlaceholder(),
              ),
            ),

            // ── Text content ─────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AI badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome,
                            color: AppColors.primary, size: 10),
                        const SizedBox(width: 3),
                        Text(
                          'AI Recipe',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Title
                  Text(
                    recipe.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Description
                  Text(
                    recipe.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                  const Spacer(),

                  // Cooking time chip
                  if (recipe.cookingTime.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined,
                            size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            recipe.cookingTime,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fallback when there is no image ──────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primarySoft,
      child: const Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          color: AppColors.primary,
          size: 32,
        ),
      ),
    );
  }
}
