import 'package:flutter/material.dart';

enum FontWeightConstant {
  bold(FontWeight.w700),
  medium(FontWeight.w500);

  final FontWeight value;
  const FontWeightConstant(this.value);
}
