import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_select_search.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_printer/widget/appbar_dialog.dart';

class PopupCreateFood extends StatelessWidget {
  const PopupCreateFood({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    return  Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarDialog(
              title: 'Thêm xe đẩy',
            ),
            SizedBox(height: AppSizes.spacingSmall.h),
            CustomSelectSearch(
              label1: 'Loại xe đẩy',
              selectList: [
                Item(id: '1', name: 'Breakfast'),
                Item(id: '2', name: 'Lunch'),
                Item(id: '3', name: 'Dinner'),
              ],
            ),

            TextWidget(
              text: 'Số lượng',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            CustomTextField(controller: controller, hintText: "0",),

            SizedBox(height: 16.h),
            CustomButton(
              text: 'Xác nhận',
              color: AppColors.primary,
              borderRadius: 4,
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}