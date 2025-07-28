import 'package:flutter/material.dart';

class ScreenSize {
  //mobile
  static double width = 375;
  static double height = 812;

  //web
  static double widthIpad = 1280;
  static double heightIpad = 800;
}

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
