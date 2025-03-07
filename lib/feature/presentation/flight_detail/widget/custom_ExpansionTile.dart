import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/child_expansion.dart';

class CustomExpansionTile extends StatefulWidget {
  final Color? backgroundColor;
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final String trailingCount;
  final String confirmationText;
  final int outerListCount;
  final int innerListCount;

  const CustomExpansionTile({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.trailingCount,
    required this.confirmationText,
    this.outerListCount = 1,
    this.innerListCount = 1,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  final FlightDetailController controller = Get.put(FlightDetailController());

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.9,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.backgroundTab,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ExpansionTile(
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Icon(widget.leadingIcon, color: AppColors.iconFlight),
        title: TextWidget(
          text: widget.title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitle: TextWidget(
          text: widget.subtitle,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextWidget(
              text: widget.trailingCount,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 10.h),
            Container(
              height: 16.h,
              width: 80.w,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColors.textSuccess,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: AppColors.white, size: 12.sp),
                  SizedBox(width: 3.w),
                  TextWidget(
                    text: widget.confirmationText,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
       
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.outerListCount,
            itemBuilder: (context, outerIndex) => ExpansionTile(
              backgroundColor: AppColors.backgroundTab,
                iconColor: AppColors.primary,
                collapsedIconColor: AppColors.primary,
                title: const TextWidget(
                  text: 'HÀNG KHO NGOẠI QUAN',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.innerListCount,
                    itemBuilder: (context, innerIndex) => ChildExpansion(
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
