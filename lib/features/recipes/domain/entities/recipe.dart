class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final double rating;
  final int cookTimeMinutes;
  final String categoryId;
  final String description;
  final int calories;
  final List<String> ingredients;
  final List<String> instructions;
  final bool isFeatured;
  final bool isFavorite;

  const Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.cookTimeMinutes,
    required this.categoryId,
    required this.description,
    required this.calories,
    required this.ingredients,
    required this.instructions,
    this.isFeatured = false,
    this.isFavorite = false,
  });

  String get cookTimeLabel => '$cookTimeMinutes min';
  String get ratingLabel => rating.toStringAsFixed(1);

  Recipe copyWith({
    bool? isFavorite,
  }) {
    return Recipe(
      id: id,
      title: title,
      imageUrl: imageUrl,
      rating: rating,
      cookTimeMinutes: cookTimeMinutes,
      categoryId: categoryId,
      description: description,
      calories: calories,
      ingredients: ingredients,
      instructions: instructions,
      isFeatured: isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
