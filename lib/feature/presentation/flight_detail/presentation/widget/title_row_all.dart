import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class TitleRowAll extends StatelessWidget {
  const TitleRowAll({
    required this.title,
    required this.subtitle,
    this.onClickSeenAll,
    super.key,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onClickSeenAll;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: AppSizes.paddingMedium.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(text: title, fontSize: 14, fontWeight: FontWeight.w500),
            InkWell(
              onTap: onClickSeenAll,
              child: TextWidget(
                text: subtitle,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
}