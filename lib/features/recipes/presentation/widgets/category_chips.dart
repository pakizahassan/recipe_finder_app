import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/category.dart';

class CategoryChips extends StatelessWidget {
  final List<RecipeCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;
          return ChoiceChip(
            selected: selected,
            label: Text(category.name),
            avatar: Icon(
              _iconFor(category.icon),
              size: 16,
              color: selected ? Colors.white : AppColors.primary,
            ),
            onSelected: (_) => onSelected(category.id),
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.card,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: selected ? AppColors.primary : AppColors.surfaceAlt,
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _iconFor(String value) {
    return switch (value) {
      'Morning' => Icons.wb_sunny_outlined,
      'Sweet' => Icons.cake_outlined,
      'Coastal' => Icons.set_meal_outlined,
      'Garden' => Icons.eco_outlined,
      'Protein' => Icons.restaurant_outlined,
      'Classic' => Icons.dinner_dining_outlined,
      _ => Icons.local_dining_outlined,
    };
  }
}
