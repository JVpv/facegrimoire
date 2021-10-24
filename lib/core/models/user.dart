class AppUser {
  final String id;
  final String name;
  final String email;
  final String imageURL;
  final String token;

  const AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.imageURL,
      required this.token});
}
