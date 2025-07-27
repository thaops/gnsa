import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/utils/navigation_service.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/core/configs/theme/app_theme.dart';
import 'package:gnsa/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accessTokenAsync = ref.watch(accessTokenProvider);
    return accessTokenAsync.when(
      data: (data) {
        final router = AppRouter.getRouter(data);
        return ScreenUtilInit(
          designSize: Size(ScreenSize.width, ScreenSize.height),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => MaterialApp.router(
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            debugShowCheckedModeBanner: false,
            key: NavigationService.navigatorKey,
            theme: AppTheme.lightTheme,
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('Error')),
    );
  }
}
