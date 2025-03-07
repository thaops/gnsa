import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart' show AppBarWidget;
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/router/app_router.dart';

class FlightSignature extends StatelessWidget {
  const FlightSignature({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const AppBarWidget(
        title: 'Xác nhận',
        
      ),
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          width: Get.width,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomSignature(
                title: 'TIẾP VIÊN XÁC NHẬN',
                onPressed: () {
                  Get.toNamed(AppRouter.flightSign,
                      arguments: "TIẾP VIÊN XÁC NHẬN");
                },
                onEditPressed: () {
                  Get.toNamed(AppRouter.flightSign,
                      arguments: "TIẾP VIÊN XÁC NHẬN");
                },
                imageUrl: 'https://chukydep.vn/Upload/post/chu-ky-ten-chi.jpg',
              ),
              CustomSignature(
                title: 'NHÂN VIÊN XÁC NHẬN',
                onPressed: () {
                  Get.toNamed(AppRouter.flightSign,
                      arguments: "NHÂN VIÊN XÁC NHẬN");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
