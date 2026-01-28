import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gnsa/core/services/services.dart';
import 'package:gnsa/dio_api/utils/device_service.dart';
import 'package:gnsa/dio_api/dio_api.dart';
import 'package:gnsa/dio_api/network/dio_client.dart';
import 'package:gnsa/common/widgets/AsyncRequestHandler/async_request_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

final servicesProvider = FutureProvider<Services>((ref) async {
  return await Services.create();
});

final deviceServiceProvider = Provider<DeviceService>((ref) {
  return DeviceService();
});

final dioApiProvider = Provider<DioApi>((ref) {
  return DioApi();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final asyncRequestHandlerProvider =
    StateNotifierProvider<AsyncRequestHandler, void>((ref) {
  return AsyncRequestHandler();
});
