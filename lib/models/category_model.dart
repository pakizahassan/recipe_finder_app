import 'package:recipe_finder_app/entities/category.dart';

class CategoryModel extends RecipeCategory {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String? ?? 'Dining',
    );
  }
}
