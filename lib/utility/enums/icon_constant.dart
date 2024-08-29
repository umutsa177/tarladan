import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum IconConstant {
  userIcon('user_circle'),
  loadingBar('loading_bar');

  final String value;
  const IconConstant(this.value);

  String get toPng => 'assets/icons/$value.png';
  String get toJson => 'assets/lotties/$value.json';

  Image get toImage => Image.asset(toPng);
  LottieBuilder get toLottie => Lottie.asset(toJson);
}
