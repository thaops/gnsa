import 'package:flutter/material.dart';
import 'package:gnsa/common/utils/screen_size.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:signature/signature.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_sign/controller/flight_sign_controller.dart';
class FlightSign extends StatefulWidget {
  @override
  _FlightSignState createState() => _FlightSignState();
}

class _FlightSignState extends State<FlightSign> {
  final FlightSignController controller = Get.put(FlightSignController());

  @override
  Widget build(BuildContext context) {
    final title = Get.arguments as String;
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        backgroundColor: AppColors.white,
        title:
            TextWidget(text: title, fontSize: 16, fontWeight: FontWeight.bold),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.close, color: AppColors.primary)),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.9,
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: Get.height * 0.7,
                  width: Get.width,
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.borderSignature, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                          height: Get.height * 0.7,
                          width: Get.width,
                          child: Signature(
                            controller: controller.signatureController,
                            backgroundColor: AppColors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(),
                      ),
                      Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              controller.signatureController.clear();
                            },
                            child: SizedBox(
                              height: Get.height,
                              width: Get.width,
                              child: const Center(
                                child: TextWidget(
                                    text: 'Ký lại',
                                    fontSize: 16,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  height: 60.h,
                  color: AppColors.primary,
                  onPressed: () async {
                    await controller.saveSignature();
                  },
                  text: 'Lưu',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
