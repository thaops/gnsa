import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gnsa/router/app_router.dart';

class FlightListController extends GetxController {
  final searchController = TextEditingController();

  void onTapFlightItem() {
    Get.toNamed(AppRouter.flightDetail);
  }
}
