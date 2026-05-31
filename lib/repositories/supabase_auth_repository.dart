import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:recipe_finder_app/entities/app_user.dart';
import 'package:recipe_finder_app/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient client;

  SupabaseAuthRepository(this.client);

  @override
  Stream<AppUser?> authStateChanges() {
    return client.auth.onAuthStateChange.map((event) {
      final eventUser = event.session?.user;
      // Auth events sometimes carry empty userMetadata. Fall back to the
      // locally cached currentUser which always has the full metadata.
      final resolved = (eventUser?.userMetadata?.containsKey('display_name') == true)
          ? eventUser
          : client.auth.currentUser;
      return _mapUser(resolved ?? eventUser);
    });
  }

  @override
  AppUser? currentUser() => _mapUser(client.auth.currentUser);

  @override
  Future<void> signIn({required String email, required String password}) {
    return client.auth.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() => client.auth.signOut();

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return client.auth.signUp(
      email: email,
      password: password,
      data: {'display_name': name},
    );
  }

  AppUser? _mapUser(User? user) {
    if (user == null) return null;
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String? ?? 'Food Lover',
    );
  }
}
