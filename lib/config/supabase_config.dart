class SupabaseConfig {
  static const url = 'https://ukxzkepdremawcgtmwnl.supabase.co';
  static const anonKey = 'sb_publishable_F-d5sRKSVgt14iDuA9PpJA_uUXqNcJZ';

  static bool get isConfigured =>
      url.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
