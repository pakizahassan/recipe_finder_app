/// Supabase configuration.
///
/// NOTE: In real apps, never commit service-role keys.
class SupabaseConfig {
  static const url = 'https://ukxzkepdremawcgtmwnl.supabase.co';

  // Set your publishable anon key here.
  static const anonKey = 'sb_publishable_F-d5sRKSVgt14iDuA9PpJA_uUXqNcJZ';

  static bool get isConfigured => anonKey.isNotEmpty;
}
