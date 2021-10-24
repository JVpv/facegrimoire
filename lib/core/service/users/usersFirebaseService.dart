import 'dart:io';

import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/core/service/users/usersService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facegrimoire/core/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UsersFirebaseService implements UsersService {
  Stream<List<AppUser>> usersStream() {
    final store = FirebaseFirestore.instance;
    final snapshots = store
        .collection('users')
        .withConverter(fromFirestore: _fromFirestore, toFirestore: _toFirestore)
        .orderBy('name')
        .snapshots();

    return snapshots.map((query) {
      return query.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  Future<void> changeInfo(
      String name, String email, String birthday, String? token) async {
    final instance = FirebaseFirestore.instance;
    if (token == "") token = await FirebaseMessaging.instance.getToken();
    await instance.doc('users/' + AuthService().currentUser!.id).update({
      "name": name,
      "email": email,
      "birthday": birthday,
      "FCMToken": token
    });
    print("Changed!");
  }

  Future<List<AppUser>> get users {
    return usersStream().first;
  }

  Future<AppUser?> getUser(String email) async {
    final users = await usersStream().first;
    for (int i = 0; i < users.length; i++) {
      if (users[i].email == email) return users[i];
    }
  }

  Map<String, dynamic> _toFirestore(AppUser user, SetOptions? options) {
    return {
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
      'FCMToken': user.token,
    };
  }

  AppUser _fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc, SnapshotOptions? options) {
    return AppUser(
      id: doc.id,
      name: doc['name'],
      email: doc['email'],
      imageURL: doc['imageURL'],
      token: doc['FCMToken'],
    );
  }
}
