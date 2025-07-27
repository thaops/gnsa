import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';
import 'package:gnsa/feature/presentation/flight_sign/provider/flight_sign_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:signature/signature.dart';

class FlightSign extends HookConsumerWidget {
  // final String title;
  // final List<String> supplyFormDetailIds;
  // final bool isCrew;
  final FlightSignArguments arguments;

  const FlightSign({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(flightSignNotifierProvider.notifier);
    final state = ref.watch(flightSignNotifierProvider);
    final nameController = useTextEditingController();

    return Scaffold(
      appBar: AppBarWidget(
        title: arguments.title,
        isBack: false,
        sizeTitle: 14.sp,
        iconRightFirst: Icons.close,
        onPressedFirst: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            child: Column(
              children: [
                _buildSignatureArea(controller, nameController),
                SizedBox(height: AppSizes.paddingLarge.h),
                _buildSaveButton(context, controller, state, nameController),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignatureArea(
      FlightSignNotifier controller, TextEditingController nameController) {
    return Container(
      height: 0.65.sh,
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingMedium.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: nameController,
                  hintText: 'Nhập họ tên',
                  fontSize: 16,
                  textInputAction: TextInputAction.done,
                  borderColor: AppColors.grey.withAlpha(50),
                ),
                SizedBox(height: AppSizes.spacingSmall.h),
                const Divider(),
              ],
            ),
          ),
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
    AsyncValue<bool?> state,
    TextEditingController nameController,
  ) {
    return CustomButton(
      height: 60.h,
      color: AppColors.primary,
      onPressed: state.isLoading
          ? null
          : () async {
              if (controller.signatureController.isEmpty) {
                await CustomFlushbar.showError(context,
                    message: 'Vui lòng cung cấp chữ ký');
                return;
              }
              if (nameController.text.isEmpty) {
                await CustomFlushbar.showError(context,
                    message: 'Vui lòng nhập họ tên');
                return;
              }
                await controller.saveSignature(
                  supplyFormDetailIds: arguments.supplyFormIds,
                  isCrew: arguments.isSupplierSign,
                  signedName: nameController.text,
                );
              if (state.hasValue && !state.hasError) {
                Navigator.pop(context, true);
              }
            },
      text: 'Lưu',
    );
  }
}


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:signature/signature.dart';
// import 'package:gnsa/common/widgets/custom_text_field.dart';
// import 'package:gnsa/common/widgets/custom_button.dart';
// import 'package:gnsa/common/utils/custom_flushbar.dart';
// import 'package:gnsa/common/widgets/app_bar_widget.dart';
// import 'package:gnsa/core/configs/theme/app_colors.dart';
// import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
// import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
// import 'package:gnsa/feature/presentation/flight_sign/provider/flight_sign_provider.dart';

// class FlightSign extends HookConsumerWidget {
//   final FlightSignArguments arguments;
//   const FlightSign({super.key, required this.arguments});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final controller = ref.watch(flightSignNotifierProvider.notifier);
//     final state = ref.watch(flightSignNotifierProvider);
//     final nameController = useTextEditingController();

//     return Scaffold(
//       appBar: AppBarWidget(
//         title: arguments.title,
//         isBack: false,
//         sizeTitle: 14.sp,
//         iconRightFirst: Icons.close,
//         onPressedFirst: () => Navigator.pop(context),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
//         child: Column(
//           children: [
//             Expanded(
//               child: Signature(
//                 controller: controller.signatureController,
//                 backgroundColor: AppColors.white,
//               ),
//             ),
//             SizedBox(height: AppSizes.spacingMedium.h),
//             CustomTextField(
//               controller: nameController,
//               hintText: 'Nhập họ tên',
//               fontSize: 16,
//               textInputAction: TextInputAction.done,
//               borderColor: AppColors.grey.withAlpha(50),
//             ),
//             const Divider(),
//             CustomButton(
//               height: 60.h,
//               color: AppColors.primary,
//               onPressed: state is AsyncLoading ? null : () async {
//                 if (controller.signatureController.isEmpty) {
//                   await CustomFlushbar.showError(context, message: 'Vui lòng ký');
//                   return;
//                 }
//                 if (nameController.text.isEmpty) {
//                   await CustomFlushbar.showError(context, message: 'Vui lòng nhập họ tên');
//                   return;
//                 }
//                 await controller.saveSignature(
//                   context: context,
//                   supplyFormDetailIds: arguments.supplyFormIds,
//                   isCrew: arguments.isSupplierSign,
//                   signedName: nameController.text,
//                 );
//                 if (state is AsyncData) Navigator.pop(context, true);
//               },
//               text: 'Lưu',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
