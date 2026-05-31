import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ai_config.dart';

class McpClient {
  McpClient._();
  static final McpClient instance = McpClient._();

  final _client = http.Client();

  Future<String> generateContent(String prompt) async {
    if (!AiConfig.isConfigured) {
      throw const AiConfigurationException(AiConfig.missingApiKeyMessage);
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
        'responseMimeType': 'application/json',
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
    final content = candidates.first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List?;
    final text = parts?.isNotEmpty == true
        ? (parts!.first as Map<String, dynamic>)['text'] as String?
        : null;

    if (text == null || text.trim().isEmpty) {
      throw const McpException('AI returned an empty response.');
    }

    return text;
  }
}

class McpException implements Exception {
  final String message;
  const McpException(this.message);
  @override
  String toString() => message;
}
