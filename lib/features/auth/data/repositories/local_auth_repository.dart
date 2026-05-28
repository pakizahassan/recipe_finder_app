import 'dart:async';

import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _user;

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  AppUser? currentUser() => _user;

  @override
  Future<void> signIn({required String email, required String password}) async {
    _user = AppUser(id: 'local-user', email: email, displayName: 'Pakiza');
    _controller.add(_user);
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }

  @override
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _user = AppUser(id: 'local-user', email: email, displayName: name);
    _controller.add(_user);
  }
}
