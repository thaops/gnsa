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
  const Login({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);

    final size = MediaQuery.of(context).size;

    final width = size.width *  (ResponsiveHelper.isWeb(context) ? 0.3 : ResponsiveHelper.isTablet(context)? 0.5 : 0.8);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: controller.isLoading,
        child: SingleChildScrollView(
          child: SizedBox.fromSize(
            size: size,
            child: DecoratedBox(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Img.background),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Container(
                  width: width,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...['Hệ Thống', 'Giao Nhận Xuất Ăn'].map(
                        (text) => TextWidget(
                          text: text,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      CustomTextField(
                        controller: controller.nameController,
                        hintText: 'Tên đăng nhập',
                        
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: controller.passwordController,
                        hintText: 'Mật khẩu',
                        obscureText: true,
                        suffixIcon: Icons.visibility,
                      ),
                      SizedBox(height: 30.h),
                      CustomButton(
                        text: 'Đăng nhập',
                        color: AppColors.primary,
                        onPressed: () => controller.login(context),
                      ),
                      SizedBox(height: 30.h),
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
