import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlightDetailController extends GetxController {
  final isEdit = false.obs;
  final noteController = TextEditingController().obs;

  final title = ['Tên chuyến bay :', 'Thời gian bay :', 'Thời gian bay :'];
  final value = ['SGN - DAD - SGN', '12:00 - 14:00', '12:00 - 14:00'];

//   void onTapSign() {
//     Get.toNamed(AppRouter.sign);
//   }
 }
