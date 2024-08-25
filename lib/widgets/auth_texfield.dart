import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  const AuthTextfield({
    super.key,
    required this.icon,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final Widget icon;
  final String labelText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: icon,
          border: const OutlineInputBorder()),
    );
  }
}
