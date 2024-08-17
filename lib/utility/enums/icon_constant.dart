import 'package:flutter/material.dart';

enum IconConstant {
  appIcon('user_circle');

  final String value;
  const IconConstant(this.value);

  String get toPng => 'assets/icons/$value.png';
  Image get toImage => Image.asset(toPng);
}
