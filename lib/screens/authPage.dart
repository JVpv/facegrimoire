import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:facegrimoire/components/authForm.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:facegrimoire/core/models/authFormData.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;

  Future<void> _handleSubmit(AuthFormData formData) async {
    print("name: " + formData.name);
    print("email: " + formData.email);
    print("password: " + formData.password);
    try {
      setState(() => _isLoading = true);
      if (formData.isLogin) {
        //Login
        await AuthService()
            .login(formData.email, formData.password)
            .catchError((e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Ocorreu um erro, por favor tente novamente." + e.toString()),
            backgroundColor: Theme.of(context).errorColor,
          ));
        });
      } else {
        //Signup
        print("signup");
        String? token = await FirebaseMessaging.instance.getToken();
        print("Token: " + token.toString());
        await AuthService()
            .signup(formData.name, formData.email, formData.password, token!,
                formData.photo!)
            .catchError((e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Ocorreu um erro, por favor tente novamente." + e.toString()),
            backgroundColor: Theme.of(context).errorColor,
          ));
        }).then((value) => setState(() => _isLoading = false));
      }
    } catch (error) {}
    setState(() {
      _isLoading = false;
    });
    print(formData.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: AuthForm(
                  onSubmit: _handleSubmit,
                ),
              ),
            ),
            if (_isLoading)
              Container(
                child: Center(
                  child: SpinKitDancingSquare(
                    color: Colors.white,
                    size: 200,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
