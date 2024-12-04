import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';

class FlightDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlightDetailController());
  }
}
