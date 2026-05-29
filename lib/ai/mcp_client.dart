import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_config.dart';

class McpClient {
  McpClient._();
  static final McpClient instance = McpClient._();

  final _client = http.Client();

  Future<String> generateContent(String prompt) async {
    if (!AiConfig.isConfigured) {
      throw const McpException(
        'Gemini API key is missing. Run Flutter with '
        '--dart-define=GEMINI_API_KEY=your_key',
      );
    }

    final uri = Uri.parse(AiConfig.generateContentUrl);
    final payload = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'temperature': 0.7,
        'maxOutputTokens': 2048,
        'candidateCount': 1,
      },
    });

    final response = await _client
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': AiConfig.geminiApiKey.trim(),
          },
          body: payload,
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      final body = response.body;
      String detail = body;
      try {
        final decoded = jsonDecode(body) as Map<String, dynamic>;
        detail = (decoded['error']?['message'] as String?) ?? body;
      } catch (_) {}
      throw McpException('AI API error (${response.statusCode}): $detail');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = json['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      throw const McpException('AI returned no candidates.');
    }
    final parts =
        (candidates[0]['content'] as Map<String, dynamic>)['parts'] as List;
    return parts[0]['text'] as String;
  }
}

class McpException implements Exception {
  final String message;
  const McpException(this.message);
  @override
  String toString() => message;
}
