import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/repositoty/device_udid.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/utils/utils_deviece_udid.dart';
import 'package:gnsa/core/configs/theme/app_theme.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:gnsa/common/Services/services.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final services = await Services.create(); 
  final getudid = UtilsDeviceUdid();
  final deviceUdid = await DeviceUdid.createDeviceUdid();
  await deviceUdid.saveUdid(await getudid.getDeviceUid());
  final accessToken = await services.getAccessToken();
  runApp(MyApp(accessToken: accessToken));
}

class MyApp extends StatelessWidget {
  final String accessToken;
  const MyApp({super.key, required this.accessToken});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ScreenUtilInit(
      designSize: Size(width > ScreenSize.widthWeb ? ScreenSize.widthWeb : width, height > ScreenSize.heightWeb ? ScreenSize.heightWeb : height),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => GetMaterialApp(
        initialRoute: accessToken.isNotEmpty ? AppRouter.flightList : AppRouter.login,
        getPages: AppRouter.routes,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
