import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:gnsa/core/config/config.dart';
import 'package:gnsa/core/services/services.dart';
import 'package:gnsa/dio_api/utils/device_service.dart';
import 'package:gnsa/dio_api/utils/device_udid.dart';

class DioClient {
  late final Dio dio;
  final DeviceService _deviceService = DeviceService();

  DioClient() {
    dio = Dio(BaseOptions(
      baseUrl: Config.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) => status != null && status < 500,
    ));

    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final services = await Services.create();
          final accessToken = await services.getAccessToken();

          final deviceUdid = await DeviceUdid.createDeviceUdid();
          final deviceInfo = await _deviceService.getDeviceInfo();

          options.headers.addAll({
            'accept': '*/*',
            'Content-Type': 'application/json',
            'X_API_ID': 'VN_CREW_2017',
            'X_API_KEY': 'KE4Sc6zqaaHHlpkzStfdpwcmnkvposK6',
            'X_REQUEST_API_VERSION': '5.0',
            'X_REQUEST_UDID': deviceInfo.udid,
            'X_REQUEST_PLATFORM': deviceInfo.platform,
            'X_REQUEST_DEVICE_NAME': deviceInfo.deviceName,
            'X_REQUEST_DEVICE_TYPE': deviceInfo.deviceType,
            'X_REQUEST_OS_VERSION': deviceInfo.osVersion,
            'X_APP_ID': deviceInfo.appId,
            'X_APP_BUILD': deviceInfo.appBuild,
            'X_APP_VERSION': deviceInfo.appVersion,
            'X_PUSH_TOKEN': deviceInfo.pushToken,
            'X_DEVICE_UDID': await deviceUdid.getUdid(),
          });

          if (accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          handler.next(options);
        },
      ),
    );
  }
}
