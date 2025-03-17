class Profile {
  Profile({
    required this.id,
    required this.username,
    required this.updated_at,
    // required this.role
  });

  /// User ID of the profile
  final String id;

  /// Username of the profile
  final String username;

  /// Date and time when the profile was created
  final DateTime updated_at;

  // final String role;

  Profile.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        username = map['username'],
        updated_at = DateTime.parse(map['updated_at']);
        // role = map['role'];
}