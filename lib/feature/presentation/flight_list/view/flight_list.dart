import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_overlay.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_list/controller/flight_list_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/costom_flight_list.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';

class FlightList extends StatelessWidget {
  const FlightList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightListController>();
    bool isTablet = ResponsiveHelper.isTablet(context);
    bool isWeb = ResponsiveHelper.isWeb(context);
    Timer? _timer;

    return Obx(() => LoadingOverlay(
        isLoading:controller.isScrolling.value ? false  : controller.isLoading.value,
        istwoloading: controller.isScrolling.value,
        child: Scaffold(
          appBar: const AppBarWidget(
            title: "Lịch bay",
            isBack: false,
          ),
          body: Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(
                horizontal: isWeb
                    ? Get.width * 0.3
                    : isTablet
                        ? Get.width * 0.1
                        : 26),
            child: Column(
              children: [
                CustomTextField(
                    hintText: "Tìm kiếm",
                    controller: controller.searchController,
                    prefixIcon: Icons.search,
                    borderWidth: 0,
                    backgroundColor: AppColors.backgroundTab,
                    borderRadius: 20,
                    borderColor: AppColors.backgroundTab,
                    onChanged: (value) {
                      if (_timer?.isActive ?? false) _timer?.cancel();
                      _timer = Timer(const Duration(seconds: 1), () {
                        controller.getFlights(search: value);
                      });
                    }),
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: controller.isSearch.value
                        ? controller.flightsModelSearch?.data.length ?? 0
                        : controller.flightsModel?.data.length ?? 0,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: CustomFightList(
                        data: controller.isSearch.value
                            ? controller.flightsModelSearch?.data[index] ??
                                FlightData()
                            : controller.flightsModel?.data[index] ??
                                FlightData(),
                        onTap: () {
                          controller.onTapFlightItem();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
