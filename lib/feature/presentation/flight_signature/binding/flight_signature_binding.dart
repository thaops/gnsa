import 'package:get/get.dart';
import '../controller/flight_signature_controller.dart';

class FlightSignatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlightSignatureController());
  }
}
