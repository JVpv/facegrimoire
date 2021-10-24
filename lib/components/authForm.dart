import 'dart:io';

import 'package:facegrimoire/components/authImagePicker.dart';
import 'package:facegrimoire/core/models/authFormData.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;
  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formData = AuthFormData();
    String email = "";
    String password = "";
    String confirmPassword = "";
    bool hidePassword = true;
    bool hideConfirmPassword = true;

    void _showError(String msg) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }

    void _submit() {
      final isValid = _formKey.currentState?.validate() ?? false;
      if (!isValid) return;

      if (_formData.photo == null && _formData.isSignup) {
        return _showError("Imagem não selecionada");
      }
      _formData.email = email;
      _formData.password = password;

      widget.onSubmit(_formData);
    }

    void _handleImagePick(File image) {
      _formData.photo = image;
    }

    return Card(
        color: secondary,
        child: StatefulBuilder(
          builder: (context, setState) => Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/images/fglogo.png"),
                ),
                Visibility(
                  child: AuthImagePicker(
                    onImagePicked: _handleImagePick,
                  ),
                  visible: _formData.isSignup,
                ),
                Visibility(
                  visible: _formData.isSignup,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(color: tertiary),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: tertiary),
                        border: InputBorder.none,
                      ),
                      initialValue: "",
                      cursorColor: tertiary,
                      validator: (_name) {
                        if (_name!.length < 5)
                          return "Please insert a name with at least 5 characters.";
                        _formData.name = _name;
                        return null;
                      },
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primary),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    style: TextStyle(color: tertiary),
                    decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(color: tertiary),
                      border: InputBorder.none,
                    ),
                    initialValue: email,
                    onChanged: (_email) => email = _email,
                    cursorColor: tertiary,
                    validator: (_email) {
                      email = _email ?? "";
                      if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email))
                        return "Por favor insita um e-mail válido.";
                      return null;
                    },
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: primary),
                ),
                Visibility(
                  visible: _formData.isSignup,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(color: tertiary),
                      decoration: InputDecoration(
                        labelText: "Confirm your e-mail",
                        labelStyle: TextStyle(color: tertiary),
                        border: InputBorder.none,
                      ),
                      cursorColor: tertiary,
                      validator: (_email) {
                        String confirmEmail = _email ?? "";
                        if (email != confirmEmail)
                          return "The e-mails do not match.";
                        return null;
                      },
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primary),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: TextFormField(
                    style: TextStyle(color: tertiary),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: tertiary),
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: hidePassword
                            ? Icon(
                                Icons.visibility,
                                color: tertiary,
                              )
                            : Icon(
                                Icons.visibility_off,
                                color: tertiary,
                              ),
                        onPressed: () =>
                            setState(() => hidePassword = !hidePassword),
                      ),
                    ),
                    cursorColor: tertiary,
                    obscureText: hidePassword,
                    onChanged: (_password) => password = _password,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20), color: primary),
                ),
                Visibility(
                  visible: _formData.isSignup,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      style: TextStyle(color: tertiary),
                      decoration: InputDecoration(
                        labelText: "Confirm your password",
                        labelStyle: TextStyle(color: tertiary),
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: hideConfirmPassword
                              ? Icon(
                                  Icons.visibility,
                                  color: tertiary,
                                )
                              : Icon(
                                  Icons.visibility_off,
                                  color: tertiary,
                                ),
                          onPressed: () => setState(
                              () => hideConfirmPassword = !hideConfirmPassword),
                        ),
                      ),
                      initialValue: email,
                      cursorColor: tertiary,
                      onChanged: (_pass) => confirmPassword = _pass,
                      validator: (_pass) {
                        if (password != confirmPassword)
                          return "The passwords don't match.";
                        return null;
                      },
                      obscureText: hideConfirmPassword,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primary),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _submit();
                  },
                  child: Text(
                    _formData.isLogin ? "Login" : "Sign up",
                    style: TextStyle(color: tertiary),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primary)),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: TextButton(
                      onPressed: () {
                        setState(() => _formData.toggleAuthMode());
                      },
                      child: Text(
                        _formData.isLogin
                            ? "I don't have an account"
                            : "I already have an account",
                        style: TextStyle(color: primary),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
