class MyAppUser {
  final String uid;
  final String email;
  final String username;
  final String? profilePictureUrl;

  MyAppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.profilePictureUrl,
  });
}
