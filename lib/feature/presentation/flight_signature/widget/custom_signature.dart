import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSignature extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Function()? onEditPressed;
  final String? imageUrl;
  const CustomSignature(
      {super.key,
      required this.title,
      required this.onPressed,
      this.imageUrl,
      this.onEditPressed});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.bold),
        SizedBox(height: 12.h),
        Container(
            width: double.infinity,
            height: screenSize.height * 0.35,
            padding: EdgeInsets.symmetric(
              horizontal: imageUrl == null ? 40.w : 0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderSignature, width: 1),
            ),
            child: imageUrl == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        Img.imageIcon,
                        width: 60.w,
                        height: 60.h,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 12.h),
                      const TextWidget(
                          text: 'Chữ ký tiếp viên',
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      SizedBox(height: 8.h),
                      const TextWidget(
                          text:
                              'Vui lòng ký tên vào để xác nhận đã nhận vật tư',
                          fontSize: 12,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.w300,
                          maxLines: 2),
                     SizedBox(height: 8.h),

                      CustomButton(
                          width: screenSize.width * 0.4,
                          fontSize: 12,
                          color: AppColors.primary,
                          text: 'Ký xác nhận',
                          onPressed: onPressed),
                    ],
                  )
                : Stack(
                    children: [
                      Center(
                          child: Image.network(imageUrl!,
                              fit: BoxFit.cover, width: screenSize.width)),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 44.w,
                          height: 44.h,
                          decoration: BoxDecoration(
                              color: AppColors.borderSignature,
                              borderRadius: BorderRadius.circular(50.r)),
                          child: IconButton(
                              onPressed: onEditPressed,
                              icon: Icon(Icons.edit, size: 24.sp)),
                        ),
                      )
                    ],
                  )),
      ],
    );
  }
}
