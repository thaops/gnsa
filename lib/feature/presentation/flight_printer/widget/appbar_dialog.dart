import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppbarDialog extends StatelessWidget {
  final String title;
  const AppbarDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: title,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(
          height: 30.h,
          width: 30.w,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: const Icon(Icons.close, color: Colors.white, size: 14),
              padding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }
}