import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/repositoty/device_udid.dart';
import 'package:gnsa/common/services/services.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/utils/utils_deviece_udid.dart';
import 'package:gnsa/core/configs/theme/app_theme.dart';
import 'package:gnsa/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final services = await Services.create();
  final utilsDeviceUdid = UtilsDeviceUdid();
  final deviceUdid = await DeviceUdid.createDeviceUdid();
  await deviceUdid.saveUdid(await utilsDeviceUdid.getDeviceUid());
  final accessToken = await services.getAccessToken();
  runApp(
    ProviderScope(
      child: MyApp(accessToken: accessToken),
    ),
  );
}

class MyApp extends ConsumerWidget {
  final String accessToken;
  const MyApp({Key? key, required this.accessToken}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final router = AppRouter.getRouter(accessToken);

    return ScreenUtilInit(
      designSize: Size(
        width > ScreenSize.widthWeb ? ScreenSize.widthWeb : width,
        height > ScreenSize.heightWeb ? ScreenSize.heightWeb : height,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp.router(
        routerDelegate: router.routerDelegate,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
