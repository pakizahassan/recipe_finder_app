import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileRemoteDataSource {
  ProfileRemoteDataSource(this._client);
  final SupabaseClient _client;

  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    return _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
  }

  Future<void> upsertProfile(Map<String, dynamic> data) async {
    await _client.from('profiles').upsert(data);
  }

  Future<String?> uploadAvatar(
      String userId, Uint8List bytes, String ext) async {
    final path = '$userId.$ext';
    await _client.storage.from('avatars').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            upsert: true,
            contentType: 'image/$ext',
          ),
        );
    return _client.storage.from('avatars').getPublicUrl(path);
  }
}
