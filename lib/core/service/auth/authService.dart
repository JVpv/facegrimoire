import 'dart:io';

import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/core/service/auth/authFirebaseService.dart';

abstract class AuthService {
  AppUser? get currentUser;

  Stream<AppUser?> get userChanges;

  Future<void> signup(
      String name, String email, String password, String token, File image);

  Future<void> login(String name, String password);

  Future<void> logout();

  factory AuthService() {
    return AuthFirebaseService();
  }
}
