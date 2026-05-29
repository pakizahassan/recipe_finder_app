import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:recipe_finder_app/config/supabase_config.dart';
import 'package:recipe_finder_app/repositories/local_auth_repository.dart';
import 'package:recipe_finder_app/repositories/supabase_auth_repository.dart';
import 'package:recipe_finder_app/entities/app_user.dart';
import 'package:recipe_finder_app/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (!SupabaseConfig.isConfigured) return LocalAuthRepository();
  return SupabaseAuthRepository(Supabase.instance.client);
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges().startWith(repository.currentUser());
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository repository;

  AuthController(this.repository) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.signIn(email: email, password: password),
    );
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => repository.signUp(name: name, email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(repository.signOut);
  }
}

extension StreamStartWith<T> on Stream<T> {
  Stream<T> startWith(T value) async* {
    yield value;
    yield* this;
  }
}
