import 'package:google_generative_ai/google_generative_ai.dart';

/// Central place for Gemini configuration.
///
/// Values are read from compile-time defines:
/// - GEMINI_API_KEY
/// - GEMINI_MODEL
class AiConfig {
  static const String _defaultModel = 'gemini-2.5-flash';

  static const String _geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  static const String _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: _defaultModel,
  );

  static String get geminiApiKey => _geminiApiKey.trim();

  static String get model => _model.trim().isEmpty ? _defaultModel : _model.trim();

  static bool get isConfigured => geminiApiKey.isNotEmpty;

  static String get generateContentUrl =>
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent';

  static GenerativeModel get modelInstance =>
      GenerativeModel(model: model, apiKey: geminiApiKey);
}

