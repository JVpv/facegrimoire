import 'dart:io';

import 'package:facegrimoire/core/models/userMessage.dart';

class PostFormData {
  String authorName = "";
  String authorProfilePicture = "";
  List<String> attachments = [];
  String title = "";
  String content = "";
  String type = "";
  DateTime timeSent = DateTime.now();
  List<UserMessage> comments = [];
}
