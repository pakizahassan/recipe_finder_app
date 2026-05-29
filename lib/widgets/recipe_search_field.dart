import 'package:flutter/material.dart';

import 'package:recipe_finder_app/theme/app_theme.dart';

class RecipeSearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final bool readOnly;

  const RecipeSearchField({
    super.key,
    this.onChanged,
    this.onTap,
    this.onFilterTap,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Search recipes',
      textField: true,
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        elevation: 0,
        child: TextField(
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Search recipes, ingredients, cuisines…',
            prefixIcon:
                const Icon(Icons.search_rounded, color: AppColors.primary),
            suffixIcon: onFilterTap == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Tooltip(
                      message: 'Filters',
                      child: IconButton.filled(
                        onPressed: onFilterTap,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                          ),
                        ),
                        icon: const Icon(Icons.tune_rounded, size: 18),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
