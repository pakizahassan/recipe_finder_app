import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:recipe_finder_app/config/supabase_config.dart';
import 'package:recipe_finder_app/providers/auth_providers.dart';
import 'package:recipe_finder_app/repositories/profile_repository_impl.dart';
import 'package:recipe_finder_app/entities/user_profile.dart';
import 'package:recipe_finder_app/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository?>((ref) {
  if (!SupabaseConfig.isConfigured) return null;
  return ProfileRepositoryImpl(Supabase.instance.client);
});

class ProfileNotifier extends AsyncNotifier<UserProfile?> {
  @override
  Future<UserProfile?> build() async {
    final user = ref.watch(currentUserProvider).valueOrNull;
    if (user == null) return null;
    final repo = ref.read(profileRepositoryProvider);
    if (repo == null) {
      return UserProfile(
        id: user.id,
        displayName: user.displayName,
      );
    }
    try {
      final profile = await repo.getProfile(user.id);
      // Never upsert here — auth events can carry empty metadata and would
      // overwrite the user's real display name with the fallback 'Food Lover'.
      return profile ?? UserProfile(id: user.id, displayName: user.displayName);
    } catch (_) {
      return UserProfile(id: user.id, displayName: user.displayName);
    }
  }

  Future<void> updateProfile({String? displayName, String? bio}) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final updated = current.copyWith(
      displayName: displayName ?? current.displayName,
      bio: bio ?? current.bio,
    );
    state = AsyncData(updated);
    try {
      await ref.read(profileRepositoryProvider)?.upsertProfile(updated);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> pickAndUploadAvatar() async {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    final repo = ref.read(profileRepositoryProvider);
    if (repo == null) return;

    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (file == null) return;

    final previous = state;
    state = const AsyncLoading();
    try {
      final bytes = await file.readAsBytes();
      final rawExt = file.name.split('.').last.toLowerCase();
      final ext = ['jpg', 'jpeg', 'png', 'webp'].contains(rawExt)
          ? rawExt
          : 'jpg';

      final url = await repo.uploadAvatar(user.id, bytes, ext);
      if (url != null) {
        final current = previous.valueOrNull ??
            UserProfile(id: user.id, displayName: user.displayName);
        final updated = current.copyWith(avatarUrl: url);
        await repo.upsertProfile(updated);
        state = AsyncData(updated);
      } else {
        state = previous;
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

final profileNotifierProvider =
    AsyncNotifierProvider<ProfileNotifier, UserProfile?>(ProfileNotifier.new);
