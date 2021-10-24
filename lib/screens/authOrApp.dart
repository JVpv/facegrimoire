import 'package:facegrimoire/components/authForm.dart';
import 'package:facegrimoire/core/models/authFormData.dart';
import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/screens/authPage.dart';
import 'package:facegrimoire/screens/startScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthOrApp extends StatelessWidget {
  const AuthOrApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _init() async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      print("Loaded!");
    }

    Future<void> _handleSubmit(AuthFormData data) async {
      print("Yeehaw");
    }

    return FutureBuilder(
      future: _init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: Container(
              child: SpinKitDancingSquare(
                color: Colors.white,
                size: 200,
              ),
            ),
          );
        } else {
          return StreamBuilder<AppUser?>(
            stream: AuthService().userChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SpinKitDancingSquare(
                  color: Colors.white,
                  size: 200,
                );
              } else {
                print(snapshot.hasData);
                return snapshot.hasData ? StartScreen() : AuthPage();
              }
            },
          );
        }
      },
    );
  }
}
