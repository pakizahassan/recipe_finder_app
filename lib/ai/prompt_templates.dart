class PromptTemplates {
  static const _system = '''
You are a professional chef AI assistant.
Generate structured cooking recipes only.

Rules:
- Return ONLY valid JSON — no markdown fences, no explanation, no extra text
- Keep instructions simple and beginner-friendly
- Ensure realistic cooking steps
- Include common ingredients with quantities
- Keep calorie estimate realistic
''';

  static String recipeGeneration(String foodName) => '''
$_system

Generate a complete recipe for: "$foodName"

Return ONLY this exact JSON structure:
{
  "title": "Recipe Name",
  "description": "Brief 1-2 sentence description",
  "ingredients": ["quantity + ingredient", "quantity + ingredient"],
  "steps": ["Step 1 description", "Step 2 description"],
  "cooking_time": "X minutes",
  "calories": "X kcal per serving",
  "servings": "X servings",
  "chef_tips": "One helpful cooking tip"
}
''';
}
