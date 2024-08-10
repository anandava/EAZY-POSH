class SupabaseClient {
  final String url;
  final String token;

  SupabaseClient._internal(this.url, this.token);

  static final SupabaseClient _instance = SupabaseClient._internal(
    'https://oukwkoishrxtyqvbqiia.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im91a3drb2lzaHJ4dHlxdmJxaWlhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUxOTgzMjgsImV4cCI6MjAzMDc3NDMyOH0.-Hz5v248e__0V2PpFRw_nfK9cZxdSXeozUtB097hz6I',
  );

  factory SupabaseClient() => _instance;

  static SupabaseClient get instance => _instance;
}
