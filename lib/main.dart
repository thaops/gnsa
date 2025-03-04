import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/core/configs/theme/app_theme.dart';
import 'package:gnsa/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width > ScreenSize.widthWeb ? ScreenSize.widthWeb : width, height > ScreenSize.heightWeb ? ScreenSize.heightWeb : height),
      minTextAdapt: true,
      
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        initialRoute: AppRouter.login,
        getPages: AppRouter.routes,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
