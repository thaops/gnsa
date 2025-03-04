import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_printer/controller/flight_printer_controller.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/constom_checkbox.dart';

class FlightPrinter extends StatelessWidget {
  const FlightPrinter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlightPrinterController());
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const TextWidget(
                  text: 'In phiếu',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                Center(
                  child: Container(
                    height: 30.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Obx(
                  () => GestureDetector(
                    onTap: () {
                      controller.isChecked.value = !controller.isChecked.value;
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: ConstomCheckbox(
                          isChecked: controller.isChecked.value),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16.h),
            CustomButton(
              width: ScreenSize.width * 0.4,
              color: AppColors.primary,
              text: "In phiếu",
              fontSize: 14,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
