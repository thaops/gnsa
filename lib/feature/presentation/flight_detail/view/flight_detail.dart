import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_ExpansionTile.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/custom_detail_flight.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlightDetail extends StatelessWidget {
  const FlightDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightDetailController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
        ),
        title: const TextWidget(
          text: 'Cung ứng vật tư',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.file_present_outlined,
                color: AppColors.primary),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                itemCount: 2,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CupertinoContextMenu(
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      color: AppColors.backgroundTab,
                      child: CustomExpansionTile(),
                    ),
                    actions: <CupertinoContextMenuAction>[
                      CupertinoContextMenuAction(
                        
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.edit, color: AppColors.primary),
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
                          print('Ký xác nhận');
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              elevation: 3,
              child: CustomButton(
                onPressed: () {},
                color: AppColors.primary,
                text: 'Ký xác nhận',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
