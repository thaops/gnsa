import 'package:flutter/material.dart';

class ScreenSize {
  //mobile
  static double width = 411.42857142857144;
  static double height = 875.4285714285714;

  //web
  static double widthWeb = 1920;
  static double heightWeb = 1080;
}

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
