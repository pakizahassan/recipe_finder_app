import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_finder_app/datasources/profile_remote_data_source.dart';
import 'package:recipe_finder_app/models/profile_model.dart';
import 'package:recipe_finder_app/entities/user_profile.dart';
import 'package:recipe_finder_app/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(SupabaseClient client)
      : _source = ProfileRemoteDataSource(client);

  final ProfileRemoteDataSource _source;

  @override
  Future<UserProfile?> getProfile(String userId) async {
    final data = await _source.fetchProfile(userId);
    if (data == null) return null;
    return ProfileModel.fromJson(data);
  }

  @override
  Future<void> upsertProfile(UserProfile profile) async {
    await _source.upsertProfile(ProfileModel.toJson(profile));
  }

  @override
  Future<String?> uploadAvatar(
      String userId, Uint8List bytes, String ext) async {
    return _source.uploadAvatar(userId, bytes, ext);
  }
}
