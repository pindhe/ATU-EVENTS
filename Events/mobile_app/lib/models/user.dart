class User {
  final String id;
  final String username;
  final String email;
  final String role; // 'normal_user', 'teacher', 'admin'
  final String? firstName;
  final String? lastName;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      username: json['username'],
      email: json['email'],
      role: json['role'] ?? 'normal_user',
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}
