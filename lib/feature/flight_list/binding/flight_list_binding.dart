import 'package:get/get.dart';
import 'package:gnsa/feature/flight_list/controller/flight_list_controller.dart';

class FlightListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlightListController());
  }
}
