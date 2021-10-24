class UserMessage {
  final String id;
  final String text;
  final DateTime timeSent;
  final String messageType;
  final String? attachment;

  final String userId;
  final String userName;
  final String userImageURL;

  const UserMessage(
      {required this.id,
      required this.text,
      required this.timeSent,
      required this.messageType,
      required this.userId,
      required this.userName,
      required this.userImageURL,
      required this.attachment});
}
