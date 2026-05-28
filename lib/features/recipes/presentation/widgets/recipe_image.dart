import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

  const RecipeImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: AppColors.surfaceAlt),
        errorWidget: (_, __, ___) => Container(
          color: AppColors.surfaceAlt,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
