import 'dart:async';

import 'package:recipe_finder_app/entities/app_user.dart';
import 'package:recipe_finder_app/repositories/auth_repository.dart';

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
