import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class ConstomCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  const ConstomCheckbox({super.key, required this.isChecked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.borderSignature,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Checkbox(
            activeColor: AppColors.primary,
            value: isChecked,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
            onChanged: (value) {},
          ),
          SizedBox(width: 12.w),
          TextWidget(text: 'In phiếu', fontSize: 14.sp),
        ],
      ),
    );
  }
}
