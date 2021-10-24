import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/core/service/users/usersService.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:facegrimoire/core/models/user.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileDialog extends StatefulWidget {
  const ProfileDialog({Key? key}) : super(key: key);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  bool alteringProfile = false;
  AppUser currentUser = AuthService().currentUser!;
  bool loading = false;

  _validateAlterProfile() async {
    setState(() {
      loading = true;
    });
    if (name != user!.name || email != user!.email) {
      await UsersService().changeInfo(name, email, birthday, "");
      print("Changed!");
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Você precisará fazer login novamente para que as alterações sejam validadas no aplicativo."),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } else {
      print("Not changed!");
      setState(() {
        loading = false;
      });
    }
  }

  String name = "";
  String email = "";
  String birthday = "";
  AppUser? user;

  Widget _editProfile() {
    return Container(
      child: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (value) => name = value,
            ),
            TextFormField(
              initialValue: email,
              decoration: InputDecoration(labelText: "E-mail"),
              onChanged: (value) => email = value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profile() {
    return StreamBuilder<List<AppUser?>>(
        stream: UsersService().usersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SpinKitDancingSquare(
              color: primary,
              size: 200,
            );
          } else {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data![i]!.email == currentUser.email) {
                user = snapshot.data![i]!;
              }
            }
            if (user == null) {
              user = currentUser;
            }
            name = user!.name;
            email = user!.email;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user!.imageURL),
                        radius: 40,
                      ),
                      onTap: () => showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: EdgeInsets.zero,
                              child: new Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user!.imageURL),
                                    radius: 120,
                                  ),
                                ],
                              ),
                              backgroundColor: Colors.black,
                            );
                          }),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          LimitedBox(
                            maxHeight: 100,
                            maxWidth: 170,
                            child: Text(
                              user!.name,
                              maxLines: 10,
                              softWrap: true,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: secondary, fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.mail,
                              color: primary,
                            ),
                            Text(
                              user!.email,
                              style: TextStyle(color: secondary, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            alteringProfile ? "Alterar perfil" : "Seu perfil",
            style: TextStyle(color: primary, fontSize: 26),
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  if (alteringProfile) {
                    _validateAlterProfile();
                  }
                  alteringProfile = !alteringProfile;
                });
              },
              icon: Icon(
                alteringProfile ? Icons.check : Icons.edit,
                color: primary,
              ))
        ],
      ),
      content: loading
          ? SpinKitDancingSquare(
              color: primary,
              size: 200,
            )
          : alteringProfile
              ? _editProfile()
              : _profile(),
    );
  }
}
