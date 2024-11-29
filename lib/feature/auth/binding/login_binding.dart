import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:gnsa/feature/auth/controller/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
