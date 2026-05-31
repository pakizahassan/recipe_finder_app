class SupabaseConfig {
  static const url = 'https://ukxzkepdremawcgtmwnl.supabase.co';
  static const anonKey = 'sb_publishable_F-d5sRKSVgt14iDuA9PpJA_uUXqNcJZ';

  // Injected at build time via --dart-define=APP_URL=https://your-app.vercel.app
  // Falls back to localhost for local development.
  static const _appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String get emailRedirectTo => _appUrl;

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
