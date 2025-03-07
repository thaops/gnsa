import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/router/app_router.dart';

class FlightDetail extends StatelessWidget {
  const FlightDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightDetailController>();
    bool isTablet = ResponsiveHelper.isTablet(context);
    bool isWeb = ResponsiveHelper.isWeb(context);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Cung ứng vật tư',
        iconRightfirst: Icons.file_present_outlined,
        colorfirst: AppColors.primary,
        functionfirst: () {
          controller.onTapPrinter();
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: isWeb
                ? Get.width * 0.3
                : isTablet
                    ? Get.width * 0.1
                    : 16,
            vertical: 16),
        child: Column(
          children: [
            CustomDetailFlight(
              flightDetail: 'Chi tiết chuyến bay:',
              title: controller.title,
              value: controller.value,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget(
                    text: 'DANH SÁCH',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  TextWidget(
                    text: 'Xem hết',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CupertinoContextMenu(
                    actions: <CupertinoContextMenuAction>[
                      CupertinoContextMenuAction(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.edit, color: AppColors.primary),
                            10.horizontalSpace,
                            const TextWidget(
                              text: 'Ký xác nhận',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                        onPressed: () {
                          Get.toNamed(AppRouter.flightSignature);
                        },
                      ),
                    ],
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColors.backgroundTab,
                      child: InkWell(
                        onTap: () {
                          controller.isExpanded.value =
                              !controller.isExpanded.value;
                          controller.update();
                        },
                        child: CustomExpansionTile(
                          backgroundColor: controller.isExpanded.value
                              ? AppColors.primary.withOpacity(0.5)
                              : AppColors.backgroundTab,
                          title: 'Suất ăn - Hạng PE & Y',
                          subtitle: 'Mã code: 1234',
                          leadingIcon: Icons.airplane_ticket,
                          trailingCount: '15',
                          confirmationText: 'Đã Xác nhận',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CustomButton(
              horizontalPadding: 16,
              onPressed: () {},
              color: AppColors.primary,
              text: 'Ký xác nhận',
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
