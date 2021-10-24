import 'dart:io';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';

class AuthFirebaseService implements AuthService {
  static AppUser? _currentUser;
  static final _userStream = Stream<AppUser?>.multi((controller) async {
    //_controller = controller;
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser =
          user == null ? null : _toIntranetUser(user, null, null, null);
      controller.add(_currentUser);
    }
  });

  AppUser? get currentUser {
    return _currentUser;
  }

  Stream<AppUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(String name, String email, String password, String token,
      File? image) async {
    String additionalInfo = name;
    print('DisplayName: ' + additionalInfo);
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) return;

    final imageName = '${credential.user!.uid}.jpg';

    //Upload foto do usuário
    final photoURL = await _uploadUserImage(image, imageName);

    //Atualização informações do usuário
    credential.user?.updateDisplayName(additionalInfo);
    credential.user?.updatePhotoURL(photoURL);

    //Salvando o usuário no banco de dados
    _currentUser =
        _toIntranetUser(credential.user!, additionalInfo, photoURL, token);
    await saveIntranetUser(_currentUser!);
  }

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await FirebaseMessaging.instance.deleteToken();
    _currentUser = null;
    FirebaseAuth.instance.signOut();
  }

  static Future<void> saveIntranetUser(AppUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageURL': user.imageURL,
      'FCMToken': user.token,
    });
  }

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('user_images').child(imageName);
    await imageRef.putFile(image).whenComplete(() {
      print(imageRef.getDownloadURL());
    });
    return await imageRef.getDownloadURL();
  }

  static AppUser _toIntranetUser(
      User user, String? additionalInfo, String? imageURL, String? token) {
    //print("Display: " + additionalInfo ?? user.displayName ?? "nada");
    return AppUser(
        id: user.uid,
        name: additionalInfo?.split('|')[0] ??
            user.displayName?.split('|')[0] ??
            user.email!.split('@')[0],
        email: user.email!,
        imageURL: imageURL ??
            user.photoURL ??
            'https://i.kym-cdn.com/entries/icons/original/000/026/638/cat.jpg',
        token: token ?? "");
  }
}
