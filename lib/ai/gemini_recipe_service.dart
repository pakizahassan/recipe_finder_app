import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'ai_config.dart';

class GeminiRecipeService {
  GeminiRecipeService({
    String? apiKey,
    GenerativeModel? model,
  }) : _model = model ??
            GenerativeModel(
              model: AiConfig.model,
              apiKey: apiKey ?? AiConfig.geminiApiKey,
            );

  final GenerativeModel _model;

  /// Takes a list of ingredients, returns a plain-text recipe.
  Future<String> generateRecipe(List<String> ingredients) async {
    final cleaned =
        ingredients.map((i) => i.trim()).where((i) => i.isNotEmpty).toList();

    if (cleaned.isEmpty) {
      throw ArgumentError('At least one ingredient is required.');
    }

    final prompt = '''
Create a practical recipe using these ingredients:
${cleaned.map((i) => '- $i').join('\n')}

Return a clear recipe with:
- Recipe title
- Short description
- Ingredients with quantities
- Step-by-step instructions
- Cooking time and servings
- One helpful chef tip
''';

    final response = await _model.generateContent([Content.text(prompt)]);
    final text = response.text?.trim();

    if (text == null || text.isEmpty) {
      throw StateError('Gemini returned an empty recipe response.');
    }

    return text;
  }

  /// Takes a food name (e.g. "Chicken Biryani"), returns a structured JSON map.
  Future<Map<String, dynamic>> generateRecipeByName(String foodName) async {
    final name = foodName.trim();

    if (name.isEmpty) {
      throw ArgumentError('Food name cannot be empty.');
    }

    final prompt = '''
You are a professional chef AI assistant.
Generate a complete recipe for: "$name"

IMPORTANT: Return ONLY valid JSON. No markdown code fences, no extra text.

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
      final decoded = jsonDecode(cleaned);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return decoded;
    } catch (e, st) {
      debugPrint('AI JSON parse error: $e');
      throw StateError(
          'Could not parse AI response as JSON.\n\nReceived:\n$raw');
    }
  }

  /// Strips markdown code fences like ```json ... ``` if Gemini adds them.
  String _extractJson(String text) {
    final s = text.trim();
    final fence = RegExp(r'```(?:json)?\\s*([\\s\\S]*?)\\s*```');
    final match = fence.firstMatch(s);
    if (match != null) return match.group(1)!.trim();

    final start = s.indexOf('{');
    final end = s.lastIndexOf('}');
    if (start != -1 && end > start) return s.substring(start, end + 1);

    return s;
  }
}
