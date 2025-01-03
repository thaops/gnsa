import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_list/controller/flight_list_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:gnsa/feature/presentation/flight_list/widget/costom_flight_list.dart';

class FlightList extends StatefulWidget {
  const FlightList({super.key});

  @override
  _FlightListState createState() => _FlightListState();
}

class _FlightListState extends State<FlightList> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FlightListController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: const TextWidget(
          text: "Lịch bay",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
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
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: CustomFightList(
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
    );
  }
}
