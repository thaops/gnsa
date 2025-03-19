import 'package:flutter/material.dart';

class ScreenSize {
  //mobile
  static double width = 360;
  static double height = 640;

  //web
  static double widthWeb = 1920;
  static double heightWeb = 1080;
}

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
