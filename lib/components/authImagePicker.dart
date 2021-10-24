import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:facegrimoire/extensions/color.dart';

class AuthImagePicker extends StatefulWidget {
  final void Function(File image) onImagePicked;

  const AuthImagePicker({Key? key, required this.onImagePicked})
      : super(key: key);
  @override
  AuthImagePickerState createState() => AuthImagePickerState();
}

class AuthImagePickerState extends State<AuthImagePicker> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 150,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePicked(_image!);
    }
  }

  var email = "";
  var password = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _image != null ? FileImage(_image!) : null,
        ),
        TextButton(
          onPressed: _pickImage,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image,
                color: primary,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "Adicionar foto",
                style: TextStyle(color: primary),
              )
            ],
          ),
        )
      ],
    );
  }
}
