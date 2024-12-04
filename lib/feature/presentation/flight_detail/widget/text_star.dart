import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStar extends StatelessWidget {
  final String title;
  final String value;
  const TextStar({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.star, color: AppColors.primary),
          SizedBox(width: 8.w),
          TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w300),
          SizedBox(width: 6.w),
          TextWidget(text: value, fontSize: 14, fontWeight: FontWeight.w500),
        ],
      ),
    );
  }
}
