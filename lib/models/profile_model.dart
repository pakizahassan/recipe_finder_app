import 'package:recipe_finder_app/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    required super.displayName,
    super.avatarUrl,
    super.bio,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      displayName: json['display_name'] as String? ?? 'Food Lover',
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String? ?? 'Food lover & home cook',
    );
  }

  static Map<String, dynamic> toJson(UserProfile p) => {
        'id': p.id,
        'display_name': p.displayName,
        'avatar_url': p.avatarUrl,
        'bio': p.bio,
        'updated_at': DateTime.now().toIso8601String(),
      };
}
