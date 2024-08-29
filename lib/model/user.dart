import 'package:tarladan/utility/constants/string_constant.dart';

class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String phoneNumber;
  final String password;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    required this.password,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      password: data['password'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  bool get isSeller => role == StringConstant.seller;
}
