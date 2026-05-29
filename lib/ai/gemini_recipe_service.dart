import 'package:google_generative_ai/google_generative_ai.dart';

import 'ai_config.dart';

class GeminiRecipeService {
  GeminiRecipeService({
    String? apiKey,
    GenerativeModel? model,
  }) : _model = model ??
            GenerativeModel(
              model: 'gemini-2.5-flash',
              apiKey: apiKey ?? AiConfig.geminiApiKey,
            );

  final GenerativeModel _model;

  Future<String> generateRecipe(List<String> ingredients) async {
    final cleanedIngredients = ingredients
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();

    if (cleanedIngredients.isEmpty) {
      throw ArgumentError('At least one ingredient is required.');
    }

    final prompt = '''
Create a practical recipe using these ingredients:
${cleanedIngredients.map((ingredient) => '- $ingredient').join('\n')}

Return a clear recipe with:
- Recipe title
- Short description
- Ingredients with quantities
- Step-by-step instructions
- Cooking time
- Servings
- One helpful chef tip
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();

    if (text == null || text.isEmpty) {
      throw StateError('Gemini returned an empty recipe response.');
    }

    return text;
  }
}
