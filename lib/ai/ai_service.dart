import 'dart:convert';
import 'mcp_client.dart';
import 'prompt_templates.dart';

class AiService {
  AiService({McpClient? client}) : _client = client ?? McpClient.instance;

  final McpClient _client;

  Future<Map<String, dynamic>> generateRecipe(String foodName) async {
    final prompt = PromptTemplates.recipeGeneration(foodName.trim());
    final raw = await _client.generateContent(prompt);
    final cleaned = _extractJson(raw);
    try {
      return jsonDecode(cleaned) as Map<String, dynamic>;
    } catch (_) {
      throw McpException(
        'Could not parse AI response as JSON.\n\nReceived:\n$raw',
      );
    }
  }

  String _extractJson(String text) {
    final s = text.trim();
    // Strip ```json ... ``` or ``` ... ``` code fences
    final fence = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```');
    final m = fence.firstMatch(s);
    if (m != null) return m.group(1)!.trim();
    // Fallback: extract first { ... } block
    final start = s.indexOf('{');
    final end = s.lastIndexOf('}');
    if (start != -1 && end > start) return s.substring(start, end + 1);
    return s;
  }
}
