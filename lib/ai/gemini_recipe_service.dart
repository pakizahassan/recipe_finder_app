<<<<<<< HEAD
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
=======
import 'package:google_generative_ai/google_generative_ai.dart';

>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
import 'ai_config.dart';

class GeminiRecipeService {
  GeminiRecipeService({
    String? apiKey,
    GenerativeModel? model,
  }) : _model = model ??
            GenerativeModel(
<<<<<<< HEAD
              model: AiConfig.model,
=======
              model: 'gemini-2.5-flash',
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
              apiKey: apiKey ?? AiConfig.geminiApiKey,
            );

  final GenerativeModel _model;

<<<<<<< HEAD
  // Used by RecipeTestScreen — takes ingredients, returns plain text
  Future<String> generateRecipe(List<String> ingredients) async {
    final cleaned = ingredients
        .map((i) => i.trim())
        .where((i) => i.isNotEmpty)
        .toList();

    if (cleaned.isEmpty) {
=======
  Future<String> generateRecipe(List<String> ingredients) async {
    final cleanedIngredients = ingredients
        .map((ingredient) => ingredient.trim())
        .where((ingredient) => ingredient.isNotEmpty)
        .toList();

    if (cleanedIngredients.isEmpty) {
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
      throw ArgumentError('At least one ingredient is required.');
    }

    final prompt = '''
Create a practical recipe using these ingredients:
<<<<<<< HEAD
${cleaned.map((i) => '- $i').join('\n')}
=======
${cleanedIngredients.map((ingredient) => '- $ingredient').join('\n')}
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1

Return a clear recipe with:
- Recipe title
- Short description
- Ingredients with quantities
- Step-by-step instructions
<<<<<<< HEAD
- Cooking time and servings
=======
- Cooking time
- Servings
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
- One helpful chef tip
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();

    if (text == null || text.isEmpty) {
      throw StateError('Gemini returned an empty recipe response.');
    }
<<<<<<< HEAD
    return text;
  }

  // Used by AI Chef screen — takes food name, returns structured JSON map
  Future<Map<String, dynamic>> generateRecipeByName(String foodName) async {
    final name = foodName.trim();

    if (name.isEmpty) {
      throw ArgumentError('Food name cannot be empty.');
    }

    final prompt = '''
You are a professional chef AI assistant.
Generate a complete recipe for: "$name"

You MUST return ONLY valid JSON. No markdown, no code fences, no explanation.

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

    final response = await _model.generateContent([Content.text(prompt)]);
    final raw = response.text?.trim() ?? '';

    if (raw.isEmpty) {
      throw StateError('Gemini returned an empty response.');
    }

    final cleaned = _extractJson(raw);
    try {
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      throw StateError(
        'Could not parse AI response as JSON.\n\nReceived:\n$raw',
      );
    }
  }

  // Strips markdown code fences if Gemini adds them anyway
  String _extractJson(String text) {
    final s = text.trim();
    final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
    final match = fence.firstMatch(s);
    if (match != null) return match.group(1)!.trim();
    final start = s.indexOf('{');
    final end = s.lastIndexOf('}');
    if (start != -1 && end > start) return s.substring(start, end + 1);
    return s;
  }
}
=======

    return text;
  }
}
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
