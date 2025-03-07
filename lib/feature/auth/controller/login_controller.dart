import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/Services/api_endpoints.dart' show ApiEndpoints;
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/common/utils/utils_deviece_udid.dart';
import 'package:gnsa/router/app_router.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  DioApi dioApi = DioApi();
  final isLoading = false.obs;
  final deviceUdid = UtilsDeviceUdid();
  Future<void> login() async {

    try {
   isLoading.value = true;
   print(ApiEndpoints.login);
    final response = await dioApi.post(ApiEndpoints.login,
     data: {
      'UserName': nameController.text,
      'Password': passwordController.text,
    });
    if (response.data['StatusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
      Get.snackbar('Thông báo', 'Đăng nhập thất bại');
      return;
    } 
    final token = response.data["Data"]['AccessToken'];
    final services = await Services.create();
    await services.saveAccessToken(token);
    Get.offNamed(AppRouter.flightList);
    } catch (e) {
      Get.snackbar('Thông báo', 'Đăng nhập thất bại');
    } finally {
      isLoading.value = false;
    }
}
}