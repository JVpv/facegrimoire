import 'package:facegrimoire/core/models/postFormData.dart';
import 'package:facegrimoire/core/service/auth/authService.dart';
import 'package:facegrimoire/extensions/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class PostCreationForm extends StatefulWidget {
  final void Function(PostFormData) onSubmit;
  const PostCreationForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _PostCreationFormState createState() => _PostCreationFormState();
}

class _PostCreationFormState extends State<PostCreationForm> {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formData = PostFormData();
    final currentUser = AuthService().currentUser;
    _formData.authorName = currentUser!.name;
    _formData.authorProfilePicture = currentUser.imageURL;
    String title = "";
    String content = "";
    List types = [
      "Abjuration",
      "Conjuration",
      "Divination",
      "Evocation",
      "Enchantment",
      "Illusion",
      "Transmutation",
      "Necromancy",
    ];
    var type;
    return Container(
      child: Form(child: StatefulBuilder(
        builder: (BuildContext context, StateSetter dropDownState) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      "Related school: ",
                      style: TextStyle(fontSize: 16, color: primary),
                    ),
                    margin: EdgeInsets.only(right: 24.0),
                  ),
                  DropdownButton(
                    hint: Text("School"),
                    value: type ?? "Abjuration",
                    onChanged: (newValue) {
                      dropDownState(() {
                        type = newValue;
                        _formData.type = type;
                      });
                    },
                    items: types.map((valueItem) {
                      return DropdownMenuItem(
                          value: valueItem, child: Text(valueItem));
                    }).toList(),
                    key: ValueKey('userType'),
                  ),
                ],
              ),
            ],
          );
        },
      )),
    );
  }
}
