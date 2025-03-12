import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/loading_overlay.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/provider/login_provider.dart.dart';

class Login extends ConsumerWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    bool isTablet = ResponsiveHelper.isTablet(context);
    bool isWeb = ResponsiveHelper.isWeb(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: LoadingOverlay(
        isLoading: controller.isLoading,
        child: SingleChildScrollView(
          child: SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Img.background),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: isWeb
                      ? screenWidth * 0.3
                      : isTablet
                          ? screenWidth * 0.5
                          : screenWidth * 0.8,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var text in ['Hệ Thống', 'Giao Nhận Xuất Ăn'])
                        TextWidget(
                          text: text,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      24.verticalSpace,
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: 'Tên đăng nhập',
                      ),
                      20.verticalSpace,
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Mật khẩu',
                        obscureText: true,
                        suffixIcon: Icons.visibility,
                      ),
                      30.verticalSpace,
                      CustomButton(
                        text: 'Đăng nhập',
                        color: AppColors.primary,
                        onPressed: () {
                          controller.login(context);
                        },
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
