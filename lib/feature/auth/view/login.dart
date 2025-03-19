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
import 'package:gnsa/feature/auth/controller/login_controller.dart';
import 'package:gnsa/feature/auth/provider/login_provider.dart.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(loginControllerProvider);
    final size = MediaQuery.sizeOf(context);
    final formWidth = size.width * _getResponsiveWidth(context);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: controller.isLoading,
        child: SingleChildScrollView(
          child: SizedBox.fromSize(
            size: size,
            child: _buildBackground(
              child: Center(
                child: _buildLoginForm(
                  width: formWidth,
                  controller: controller,
                  context: context,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getResponsiveWidth(BuildContext context) => switch (context) {
        _ when ResponsiveHelper.isWeb(context) => 0.3,
        _ when ResponsiveHelper.isTablet(context) => 0.5,
        _ => 0.8,
      };

  Widget _buildBackground({required Widget child}) => DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Img.background),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );

  Widget _buildLoginForm({
    required double width,
    required LoginController controller,
    required BuildContext context,
  }) =>
      Container(
        width: width,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ..._buildTitleTexts(),
            SizedBox(height: 24.h),
            _buildUsernameField(controller),
            SizedBox(height: 20.h),
            _buildPasswordField(controller),
            SizedBox(height: 30.h),
            _buildLoginButton(controller, context),
            SizedBox(height: 30.h),
          ],
        ),
      );

  List<Widget> _buildTitleTexts() => [
        'Hệ Thống',
        'Giao Nhận Xuất Ăn',
      ].map((text) => TextWidget(
            text: text,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          )).toList();

  Widget _buildUsernameField(LoginController controller) => CustomTextField(
        controller: controller.nameController,
        hintText: 'Tên đăng nhập',
        keyboardType: TextInputType.text,
      );

  Widget _buildPasswordField(LoginController controller) => CustomTextField(
        controller: controller.passwordController,
        hintText: 'Mật khẩu',
        obscureText: true,
        suffixIcon: Icons.visibility,
      );

  Widget _buildLoginButton(LoginController controller, BuildContext context) =>
      CustomButton(
        text: 'Đăng nhập',
        color: AppColors.primary,
        onPressed: () => controller.login(context),
      );
}