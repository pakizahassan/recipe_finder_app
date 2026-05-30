class SupabaseConfig {
  static const url = 'https://ukxzkepdremawcgtmwnl.supabase.co';
  static const anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVreHprZXBkcmVtYXdjZ3Rtd25sIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzk5NzM5MjcsImV4cCI6MjA5NTU0OTkyN30.zh5rOechwOpv0rrc3hcHu5iDecFmTpobTUP4L89GAbA';

  static bool get isConfigured => anonKey.isNotEmpty;
}
