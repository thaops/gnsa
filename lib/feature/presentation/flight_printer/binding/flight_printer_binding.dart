import 'package:get/get.dart';
import 'package:gnsa/feature/presentation/flight_printer/controller/flight_printer_controller.dart';

class FlightPrinterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlightPrinterController());
  }
}
