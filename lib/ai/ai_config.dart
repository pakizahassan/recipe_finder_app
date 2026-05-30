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

  static String get geminiApiKey {
    final key = _geminiApiKey.trim();
    return key == 'your_key' ? '' : key;
  }

  static String get model {
    final configuredModel = _model.trim();
    return configuredModel.isEmpty ? _defaultModel : configuredModel;
  }

  static bool get isConfigured => geminiApiKey.isNotEmpty;
}