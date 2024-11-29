import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final double? paddingHorizontal;
  final int? maxLines;
  const TextWidget(
      {super.key,
      required this.text,
      this.fontSize = 24,
      this.fontWeight = FontWeight.w600,
      this.color = AppColors.black,
      this.textAlign = TextAlign.left,
      this.paddingHorizontal = 0,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingHorizontal ?? 0),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        style: TextStyle(
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
