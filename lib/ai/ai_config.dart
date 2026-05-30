class AiConfig {
<<<<<<< HEAD
=======
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

  On Flutter Web, these values are compiled into the app bundle. Do not put
  server-only secrets here; restrict API keys in the provider console and use
  a backend proxy for secrets that must never be exposed to browsers.
  */
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
  static const String _defaultModel = 'gemini-2.5-flash';

  static const String _geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

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

<<<<<<< HEAD
  static bool get isConfigured => geminiApiKey.isNotEmpty;
}
=======
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static bool get isConfigured => geminiApiKey.isNotEmpty;

  static String get generateContentUrl =>
      '$_baseUrl/$model:generateContent';
}
>>>>>>> eab243aeff831e31a6572de34aab6cbdd5487cf1
