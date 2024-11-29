import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gnsa/router/app_router.dart';

class LoginController extends GetxController {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> login() async {
    Get.offNamed(AppRouter.flightList);
  }
}
