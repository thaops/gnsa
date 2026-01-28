import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:gnsa/core/services/services.dart';
import 'package:gnsa/common/utils/navigation_service.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/core/configs/theme/app_theme.dart';
import 'package:gnsa/router/app_router.dart';
import 'dart:io';

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

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Size? _designSize;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDesignSize();
  }

  Future<void> _initializeDesignSize() async {
    Size designSize;

    // Kiểm tra iPad bằng DeviceInfoPlugin cho iOS
    if (Platform.isIOS) {
      try {
        final deviceInfo = DeviceInfoPlugin();
        final iosInfo = await deviceInfo.iosInfo;
        // Kiểm tra nếu là iPad (model name hoặc name chứa "iPad")
        final isIpad = iosInfo.model.toLowerCase().contains('ipad') ||
            iosInfo.name.toLowerCase().contains('ipad') ||
            iosInfo.utsname.machine.toLowerCase().contains('ipad');

        if (isIpad) {
          designSize = Size(ScreenSize.widthIpad, ScreenSize.heightIpad);
          print("iPad detected: ${iosInfo.model} - ${iosInfo.name}");
        } else {
          // Kiểm tra bằng kích thước màn hình nếu không phát hiện được qua model
          final view = WidgetsBinding.instance.platformDispatcher.views.first;
          final screenSize = view.physicalSize / view.devicePixelRatio;
          designSize = screenSize.width >= 768
              ? Size(ScreenSize.widthIpad, ScreenSize.heightIpad)
              : Size(ScreenSize.width, ScreenSize.height);
        }
      } catch (e) {
        print("Error detecting iPad: $e");
        // Fallback: kiểm tra bằng kích thước màn hình
        final view = WidgetsBinding.instance.platformDispatcher.views.first;
        final screenSize = view.physicalSize / view.devicePixelRatio;
        designSize = screenSize.width >= 768
            ? Size(ScreenSize.widthIpad, ScreenSize.heightIpad)
            : Size(ScreenSize.width, ScreenSize.height);
      }
    } else {
      // Cho Android và các platform khác, kiểm tra bằng kích thước màn hình
      final view = WidgetsBinding.instance.platformDispatcher.views.first;
      final screenSize = view.physicalSize / view.devicePixelRatio;
      designSize = screenSize.width >= 768
          ? Size(ScreenSize.widthIpad, ScreenSize.heightIpad)
          : Size(ScreenSize.width, ScreenSize.height);
    }

    print("designSize: $designSize");

    if (mounted) {
      setState(() {
        _designSize = designSize;
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final accessTokenAsync = ref.watch(accessTokenProvider);

    if (!_isInitialized || _designSize == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return accessTokenAsync.when(
      data: (data) {
        final router = AppRouter.getRouter(data);

        return ScreenUtilInit(
          designSize: _designSize!,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              // Khóa scale chữ theo hệ thống (textScaleFactor)
              data: mediaQuery.copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: MaterialApp.router(
                routerDelegate: router.routerDelegate,
                routeInformationParser: router.routeInformationParser,
                routeInformationProvider: router.routeInformationProvider,
                debugShowCheckedModeBanner: false,
                key: NavigationService.navigatorKey,
                theme: AppTheme.lightTheme,
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const Center(child: Text('Error')),
    );
  }
}
