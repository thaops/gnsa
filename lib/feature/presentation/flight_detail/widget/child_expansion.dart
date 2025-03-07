import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';

class ChildExpansion extends StatelessWidget {
  const ChildExpansion({
    super.key,
    required this.controller,
  });

  final FlightDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget(
                    text: 'Nước tinh khiết Aquafina 1,5L',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 6.h),
                  TextWidget(
                    text: 'Cung ứng: 10',
                    fontSize: 14,
                    color: AppColors.iconFlight,
                    fontWeight: FontWeight.w300,
                  ),
                ],
              ),
              Obx(
                () => controller.isEdit.value
                    ? Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.isEdit.value =
                                  !controller.isEdit.value;
                            },
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.iconFlight,
                            ),
                          ),
                          Icon(
                            Icons.check,
                            color: AppColors.iconFlight,
                          ),
                        ],
                      )
                    : IconButton(
                        onPressed: () {
                          controller.isEdit.value = !controller.isEdit.value;
                        },
                        icon: Icon(
                          Icons.edit_note_sharp,
                          color: AppColors.iconFlight,
                        ),
                      ),
              ),
            ],
          ),
          Obx(
            () => controller.isEdit.value
                ? Container(
                    margin: EdgeInsets.only(top: 8.h),
                    width: Get.width,
                    child: CustomTextField(
                      borderColor: Colors.transparent,
                      backgroundColor: AppColors.backgroundTab,
                      hintText: 'Ghi chú',
                      controller: controller.noteController.value,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
