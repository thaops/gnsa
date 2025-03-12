import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/feature/presentation/flight_sign/binding/flight_sign_binding.dart';
import 'package:signature/signature.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlightSign extends ConsumerStatefulWidget {
  final String title;
  const FlightSign({Key? key, required this.title}) : super(key: key);

  @override
  _FlightSignState createState() => _FlightSignState();
}

class _FlightSignState extends ConsumerState<FlightSign> {


  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(flightSignControllerProvider);
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBarWidget(
        title: widget.title,
        isBack: false,
        iconRightFirst: Icons.close,
        onPressedFirst: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenSize.height * 0.85,
          width: screenSize.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: screenSize.height * 0.7,
                  width: screenSize.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColors.borderSignature, width: 1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                          height: screenSize.height * 0.7,
                          width: screenSize.width,
                          child: Signature(
                            controller: controller.signatureController,
                            backgroundColor: AppColors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20.w),
                        child: const Divider(),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            controller.signatureController.clear();
                          },
                          child: SizedBox(
                            height: screenSize.height,
                            width: screenSize.width,
                            child: const Center(
                              child: TextWidget(
                                text: 'Ký lại',
                                fontSize: 16,
                                textAlign: TextAlign.center,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  height: 60.h,
                  color: AppColors.primary,
                  onPressed: () async {
                    await controller.saveSignature(context);
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
