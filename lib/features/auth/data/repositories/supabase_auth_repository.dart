import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient client;

  SupabaseAuthRepository(this.client);

  @override
  Stream<AppUser?> authStateChanges() {
    return client.auth.onAuthStateChange.map((event) => _mapUser(event.session?.user));
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
