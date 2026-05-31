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

  static String get geminiApiKey {
    final key = _geminiApiKey.trim();
    return key == 'your_key' ? '' : key;
  }

  static String get model {
    final configuredModel = _model.trim();
    return configuredModel.isEmpty ? _defaultModel : configuredModel;
  }

  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static bool get isConfigured => geminiApiKey.isNotEmpty;

  static const String missingApiKeyMessage =
      'Gemini API key is missing. Build or run Flutter with '
      '--dart-define=GEMINI_API_KEY=YOUR_API_KEY. For local development, '
      'you can also use --dart-define-from-file=config.json.';

  static String get generateContentUrl =>
      '$_baseUrl/$model:generateContent';
}

class AiConfigurationException implements Exception {
  const AiConfigurationException(this.message);

  final String message;

  @override
  String toString() => message;
}
