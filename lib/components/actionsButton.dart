import 'package:facegrimoire/components/profileDialog.dart';
import 'package:flutter/material.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/extensions/color.dart';

class ActionsButton extends StatefulWidget {
  @override
  _ActionsButtonState createState() => _ActionsButtonState();
}

class _ActionsButtonState extends State<ActionsButton> {
  @override
  Widget build(BuildContext context) {
    composeDialog(BuildContext context, option) {
      return showDialog(
          context: context,
          builder: (context) {
            if (option == "Profile") {
              return ProfileDialog();
            } else {
              return Dialog(
                child: Card(
                  child: Center(
                    child: Text("Selected option: " + option),
                  ),
                ),
              );
            }
          });
    }

    handleClick(String value) async {
      switch (value) {
        case "Profile":
          return composeDialog(context, "Profile");
        case "Help":
          return composeDialog(context, "Help");
        case "Logout":
          AuthService().logout();
      }
    }

    return PopupMenuButton(
        onSelected: handleClick,
        itemBuilder: (BuildContext context) {
          return {'Profile', 'Logout'}.map((String choice) {
            return PopupMenuItem<String>(
                value: choice,
                child: ListTile(
                  leading: choice == 'Profile'
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(AuthService().currentUser!.imageURL),
                          radius: 15,
                        )
                      : choice == 'Help'
                          ? Icon(Icons.help, color: primary)
                          : Icon(Icons.logout, color: primary),
                  title: Text(
                    choice,
                    style: TextStyle(color: primary, fontSize: 24),
                  ),
                ));
          }).toList();
        });
  }
}
