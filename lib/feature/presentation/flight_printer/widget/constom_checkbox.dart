import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class ConstomCheckbox extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onTap;
  final String title;

  const ConstomCheckbox({
    super.key,
    required this.isChecked,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Gắn trực tiếp onTap vào GestureDetector
      child: Container(
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
              onChanged: (_) => onTap(), // Kích hoạt onTap khi thay đổi Checkbox
            ),
            SizedBox(width: 12.w),
            TextWidget(text: title, fontSize: 14.sp),
          ],
        ),
      ),
    );
  }
}