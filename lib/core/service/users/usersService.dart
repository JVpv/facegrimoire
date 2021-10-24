import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/core/service/users/usersFirebaseService.dart';

abstract class UsersService {
  Future<List<AppUser>> get users;
  Future<AppUser?> getUser(String email);

  Future<void> changeInfo(
      String name, String email, String birthday, String? token);

  Stream<List<AppUser>> usersStream();

/*
  Future<void> update(
      String name,
      String dateOfBirth,
      String email,
      String password,
      String userType,
      File image
      );
      */
  factory UsersService() {
    //return AuthMockService();
    return UsersFirebaseService();
  }
}
