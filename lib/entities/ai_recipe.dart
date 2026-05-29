class AiRecipe {
  const AiRecipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.steps,
    required this.cookingTime,
    required this.calories,
    required this.servings,
    required this.chefTips,
  });

  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> steps;
  final String cookingTime;
  final String calories;
  final String servings;
  final String chefTips;
}
