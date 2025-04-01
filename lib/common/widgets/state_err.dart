import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:lottie/lottie.dart';

class StateErr extends StatelessWidget {
  final String? message;
  const StateErr({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(Img.err, height: 150.h, width: 150.h),
          TextWidget(
              text: message ?? 'Dữ Liệu Rỗng',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.black.withOpacity(0.5)),
        ],
      ),
    );
  }
}
