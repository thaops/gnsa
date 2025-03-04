import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/feature/presentation/flight_printer/view/flight_printer.dart';
import 'package:gnsa/router/app_router.dart';

class FlightDetailController extends GetxController {
  final isEdit = false.obs;
  final isExpanded = false.obs;
  final noteController = TextEditingController().obs;

  final title = ['Tên chuyến bay :', 'Thời gian bay :', 'Thời gian bay :'];
  final value = ['SGN - DAD - SGN', '12:00 - 14:00', '12:00 - 14:00'];

  void onTapSign() {
    Get.toNamed(AppRouter.flightSignature);
  }

  void onTapPrinter() {
    Get.dialog(const FlightPrinter());
  }
}
