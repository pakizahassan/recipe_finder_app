import 'package:google_generative_ai/google_generative_ai.dart';

class AiConfig {
  static const String _defaultModel = 'gemini-2.5-flash';

  static const String _geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const String _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: _defaultModel,
  );

  static String get geminiApiKey => _geminiApiKey.trim();

  static String get model =>
      _model.trim().isEmpty ? _defaultModel : _model.trim();

  static bool get isConfigured => geminiApiKey.isNotEmpty;

  static const String missingApiKeyMessage =
      'Gemini API key is missing. Build or run Flutter with '
      '--dart-define=GEMINI_API_KEY=YOUR_API_KEY.';

  static String get generateContentUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';

  static GenerativeModel get modelInstance =>
      GenerativeModel(model: model, apiKey: geminiApiKey);
}

class AiConfigurationException implements Exception {
  const AiConfigurationException(this.message);
  final String message;
  @override
  String toString() => message;
}
