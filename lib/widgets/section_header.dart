import 'package:flutter/material.dart';

import 'package:recipe_finder_app/constants/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: Theme.of(context).textTheme.titleLarge),
          ),
          if (onAction != null)
            TextButton(
              onPressed: onAction,
              child: const Text('See All'),
            ),
        ],
      ),
    );
  }
}
