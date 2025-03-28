import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final Color? color;
  final Color? textColor;
  final bool isOutlined;
  final double? width;
  final double? height;
  final double? horizontalPadding;
  final double? verticalPadding;
  final int? fontSize;
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.color,
    this.textColor,
    this.isOutlined = false,
    this.width,
    this.height,
    this.horizontalPadding,
    this.verticalPadding,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed?.call();
      },
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 25,
            vertical: verticalPadding ?? 10),
        decoration: BoxDecoration(
          color: isOutlined ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(12.r),
          border:
              Border.all(color: isOutlined ? Colors.black : AppColors.primary),
        ),
        child: TextWidget(
          text: text,
          fontSize: fontSize?.toDouble() ?? 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}
