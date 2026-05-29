import 'dart:typed_data';
import 'package:recipe_finder_app/entities/user_profile.dart';

abstract interface class ProfileRepository {
  Future<UserProfile?> getProfile(String userId);
  Future<void> upsertProfile(UserProfile profile);
  Future<String?> uploadAvatar(String userId, Uint8List bytes, String ext);
}
