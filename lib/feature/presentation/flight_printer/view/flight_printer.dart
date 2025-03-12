import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, WidgetRef;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/constom_checkbox.dart';
import 'package:go_router/go_router.dart';

import '../binding/flight_printer_binding.dart';

class FlightPrinter extends ConsumerWidget {
  const FlightPrinter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(flightPrinterControllerProvider.notifier); // Lấy controller để gọi hàm
    final listChecked = ref.watch(flightPrinterControllerProvider); // Lấy danh sách trạng thái từ provider

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
                          GoRouter.of(context).pop();
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
              itemCount: listChecked.length, 
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.toggleChecked(index); 
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: ConstomCheckbox(
                      onTap: () {
                        controller.toggleChecked(index);
                      },
                      isChecked: listChecked[index], // Sử dụng trạng thái từ Riverpod
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
              onPressed: () {
                    controller.addItem();
              },
            )
          ],
        ),
      ),
    );
  }
}
