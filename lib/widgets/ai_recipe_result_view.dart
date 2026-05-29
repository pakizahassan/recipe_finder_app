import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_finder_app/theme/app_theme.dart';
import 'package:recipe_finder_app/entities/ai_recipe.dart';

class AiRecipeResultView extends StatelessWidget {
  const AiRecipeResultView({super.key, required this.recipe});

  final AiRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _TitleCard(recipe: recipe),
        const SizedBox(height: 12),
        _StatsRow(recipe: recipe),
        if (recipe.description.isNotEmpty) ...[
          const SizedBox(height: 12),
          _DescriptionCard(text: recipe.description),
        ],
        if (recipe.ingredients.isNotEmpty) ...[
          const SizedBox(height: 12),
          _IngredientsCard(items: recipe.ingredients),
        ],
        if (recipe.steps.isNotEmpty) ...[
          const SizedBox(height: 12),
          _StepsCard(steps: recipe.steps),
        ],
        if (recipe.chefTips.isNotEmpty) ...[
          const SizedBox(height: 12),
          _ChefTipsCard(tip: recipe.chefTips),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

// ── Title card ────────────────────────────────────────────────────────────────

class _TitleCard extends StatelessWidget {
  const _TitleCard({required this.recipe});
  final AiRecipe recipe;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recipe.title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.recipe});
  final AiRecipe recipe;

  @override
  Widget build(BuildContext context) {
    final stats = <_Stat>[
      if (recipe.cookingTime.isNotEmpty)
        _Stat(Icons.schedule_rounded, recipe.cookingTime, 'Cook Time'),
      if (recipe.calories.isNotEmpty)
        _Stat(Icons.local_fire_department_rounded, recipe.calories, 'Calories'),
      if (recipe.servings.isNotEmpty)
        _Stat(Icons.people_outline_rounded, recipe.servings, 'Servings'),
    ];

    if (stats.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int i = 0; i < stats.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(child: _StatChip(stat: stats[i])),
        ],
      ],
    );
  }
}

class _Stat {
  const _Stat(this.icon, this.value, this.label);
  final IconData icon;
  final String value;
  final String label;
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.stat});
  final _Stat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Icon(stat.icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            stat.value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Description ───────────────────────────────────────────────────────────────

class _DescriptionCard extends StatelessWidget {
  const _DescriptionCard({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: AppColors.textSecondary,
          height: 1.6,
        ),
      ),
    );
  }
}

// ── Ingredients ───────────────────────────────────────────────────────────────

class _IngredientsCard extends StatelessWidget {
  const _IngredientsCard({required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.kitchen_rounded,
      title: 'Ingredients',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: items.map((item) => _IngredientChip(label: item)).toList(),
      ),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  const _IngredientChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ── Steps ─────────────────────────────────────────────────────────────────────

class _StepsCard extends StatelessWidget {
  const _StepsCard({required this.steps});
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.format_list_numbered_rounded,
      title: 'Instructions',
      child: Column(
        children: [
          for (int i = 0; i < steps.length; i++)
            _StepTile(number: i + 1, text: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({required this.number, required this.text, required this.isLast});
  final int number;
  final String text;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            margin: const EdgeInsets.only(top: 1),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Text(
              '$number',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chef tips ─────────────────────────────────────────────────────────────────

class _ChefTipsCard extends StatelessWidget {
  const _ChefTipsCard({required this.tip});
  final String tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.12),
            AppColors.accentSoft,
          ],
        ),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tips_and_updates_rounded,
                color: AppColors.accent, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Chef's Tip",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────

class _Card extends StatelessWidget {
  const _Card({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });
  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
