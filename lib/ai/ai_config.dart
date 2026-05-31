import 'package:google_generative_ai/google_generative_ai.dart';

/// Central place for Gemini configuration.
///
/// Values are read from compile-time defines:
/// - GEMINI_API_KEY
/// - GEMINI_MODEL
class AiConfig {
  /*
  Local configuration template:

  1. Create a file named config.json in the project root.
  2. Keep config.json out of version control.
  3. Use valid JSON with double-quoted keys and values:

     {
       "GEMINI_API_KEY": "your_key",
       "GEMINI_MODEL": "gemini-2.5-flash"
     }

  Flutter reads this file at run/build time with:
  --dart-define-from-file=config.json

  If Flutter Web keeps using an old API key or model after config.json changes,
  run `flutter clean` before launching again; the browser can cache a build that
  was compiled with stale environment values.

  On Flutter Web, these values are compiled into the app bundle. Do not put
  server-only secrets here; restrict API keys in the provider console and use
  a backend proxy for secrets that must never be exposed to browsers.

  Production web builds must inject the key at build time:

  flutter build web --release --dart-define=GEMINI_API_KEY=your_key
  */
  static const String _defaultModel = 'gemini-2.5-flash';

  static const String _geminiApiKey =
      String.fromEnvironment('GEMINI_API_KEY');

  static const String _model = String.fromEnvironment(
    'GEMINI_MODEL',
    defaultValue: _defaultModel,
  );

  static String get geminiApiKey => _geminiApiKey.trim();

  static String get model => _model.trim().isEmpty ? _defaultModel : _model.trim();

  static bool get isConfigured => geminiApiKey.isNotEmpty;

  static const String missingApiKeyMessage =
      'Gemini API key is missing. Build or run Flutter with '
      '--dart-define=GEMINI_API_KEY=YOUR_API_KEY. For local development, '
      'you can also use --dart-define-from-file=config.json.';

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
