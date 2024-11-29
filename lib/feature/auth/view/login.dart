import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/controller/login_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              // Expanded(
              //   flex: 1,
              //   child: Container(
              //     width: Get.width,
              //     color: AppColors.primary,
              //     child: Image.asset(
              //       Img.background,
              //       fit: BoxFit.cover,
              //     ),
              //   ),
              // ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      50.verticalSpace,
                      const TextWidget(
                        text: 'Hệ thống GNSA!',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
