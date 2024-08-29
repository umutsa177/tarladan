import 'package:json/json.dart';
import 'package:tarladan/utility/constants/string_constant.dart';

@JsonCodable()
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

  bool get isSeller => role == StringConstant.seller;
}
