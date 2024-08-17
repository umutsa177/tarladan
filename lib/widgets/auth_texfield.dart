import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  const AuthTextfield({
    super.key,
    required this.icon,
    required this.labelText,
    required this.controller,
  });

  final TextEditingController controller;
  final Widget icon;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: icon,
          border: const OutlineInputBorder()),
    );
  }
}
