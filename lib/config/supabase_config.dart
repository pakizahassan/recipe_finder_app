/// Supabase configuration.
///
/// NOTE: In real apps, never commit service-role keys.
class SupabaseConfig {
  static const url = 'https://ukxzkepdremawcgtmwnl.supabase.co';

  // Set your publishable anon key here.
  static const anonKey = 'sb_publishable_F-d5sRKSVgt14iDuA9PpJA_uUXqNcJZ';

  // Injected at build time via --dart-define=APP_URL=https://...
  // Defaults to the known production URL.
  static const _appUrl = String.fromEnvironment(
    'APP_URL',
    defaultValue: 'https://recipe-finder-app-zeta-nine.vercel.app',
  );

  static String get emailRedirectTo => _appUrl;

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
