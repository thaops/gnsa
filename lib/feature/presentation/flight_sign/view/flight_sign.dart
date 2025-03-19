import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_sign/controller/flight_sign_controller.dart';
import 'package:signature/signature.dart';

class FlightSign extends HookConsumerWidget {
  final String title;
  final List<String> supplyFormIds;
  final bool isSupplierSign;

  const FlightSign({
    super.key,
    required this.title,
    required this.supplyFormIds,
    required this.isSupplierSign,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy controller và trạng thái từ provider
    final controller = ref.watch(flightSignProvider.notifier);
    final state = ref.watch(flightSignProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: title,
        isBack: false,
        iconRightFirst: Icons.close,
        onPressedFirst: () => Navigator.pop(context),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              _buildSignatureArea(controller),
              const Spacer(),
              _buildSaveButton(context, controller, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureArea(FlightSignNotifier controller) {
    return Container(
      height: 0.65.sh, // Dùng ScreenUtil để responsive
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderSignature, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 8,
            child: Signature(
              controller: controller.signatureController,
              backgroundColor: AppColors.white,
            ),
          ),
          const Divider(),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: controller.clearSignature,
              child: const Center(
                child: TextWidget(
                  text: 'Ký lại',
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    BuildContext context,
    FlightSignNotifier controller,
    AsyncValue<File?> state,
  ) {
    return CustomButton(
      height: 60.h,
      color: AppColors.primary,
      onPressed: state.isLoading
          ? null
          : () async {
              await controller.saveSignature(
                context: context,
                supplyFormIds: supplyFormIds,
                isSupplierSign: isSupplierSign, 
              );
              if (state.hasValue && !state.hasError) {
                Navigator.pop(context,true); 
              }
            },
      text: 'Lưu',
    );
  }
}