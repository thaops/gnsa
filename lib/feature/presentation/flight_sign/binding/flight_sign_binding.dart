import 'package:get/get.dart';
import 'package:gnsa/feature/presentation/flight_sign/controller/flight_sign_controller.dart';

class FlightSignBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlightSignController());
  }
}
