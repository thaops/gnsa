import 'package:flutter/material.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class ScreenSize {
  //mobile
  static double width = 375;
  static double height = 812;

  //web
  static const double widthIpad = 600;
  static const double heightIpad = 900;

  // Hàm để lấy design size phù hợp dựa trên thiết bị
  static Future<Size> getDesignSize() async {
    if (Platform.isIOS) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        // Kiểm tra nếu là iPad (model name chứa "iPad")
        if (iosInfo.model.toLowerCase().contains('ipad') ||
            iosInfo.name.toLowerCase().contains('ipad')) {
          return Size(widthIpad, heightIpad);
        }
      } catch (e) {
        // Nếu có lỗi, kiểm tra bằng kích thước màn hình
        final window = WidgetsBinding.instance.platformDispatcher.views.first;
        final size = window.physicalSize / window.devicePixelRatio;
        if (size.width >= 768) {
          return Size(widthIpad, heightIpad);
        }
      }
    }
    // Mặc định là mobile
    return Size(width, height);
  }

  // Hàm đồng bộ để lấy design size (sử dụng kích thước màn hình)
  static Size getDesignSizeSync(BuildContext? context) {
    if (context != null) {
      final mediaQuery = MediaQuery.of(context);
      final screenWidth = mediaQuery.size.width;
      // Nếu width >= 768, coi là tablet/iPad
      if (screenWidth >= 768) {
        return Size(widthIpad, heightIpad);
      }
    }
    // Mặc định là mobile
    return Size(width, height);
  }
}

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
}
