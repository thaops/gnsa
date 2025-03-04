import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class CustomInformationSign extends StatelessWidget {
  const CustomInformationSign({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.borderSignature,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn.gnsa.vn/gnsa-web/images/icon-information-sign.png',
            width: 80.w,
            height: 60.h,
          ),
          SizedBox(width: 12.w),
          Column(
            children: [
              TextWidget(
                text: 'Nguyen Van A',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 4.h),
              TextWidget(
                text: 'Tiếp viên - 29/09/2024 15:20',
                fontSize: 12.sp,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
