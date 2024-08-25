class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phoneNumber;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
    };
  }

  bool get isSeller => role == 'Satıcı';
}
