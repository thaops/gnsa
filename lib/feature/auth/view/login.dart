import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/utils/responsive_helper.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/controller/login_controller.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    bool isTablet = ResponsiveHelper.isTablet(context);
    bool isWeb = ResponsiveHelper.isWeb(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Img.background),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: isWeb ? Get.width * 0.3 : isTablet ? Get.width * 0.5 : Get.width * 0.8,
                  padding: EdgeInsets.all(24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          controller.login();
                        },
                      ),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
