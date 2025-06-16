import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/provider/login_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
final controllerState = ref.watch(loginControllerProvider);
    return Scaffold(
      body: controllerState.when(
        data: (state) => SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                child: _buildLoginForm(
                  state: state,
                  context: context,
                  ref: ref,
                ),
              ),
            ),
          ),
        ),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => const Text('Error'),
      )
    );
  }


  Widget _buildLoginForm({
    required LoginState state,
    required BuildContext context,
    required WidgetRef ref,
  }) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(Img.logo),
          const Column(
            children: [
              TextWidget(
                text: 'Xin chào!',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryV2,
              ),
              TextWidget(
                text: 'Đăng nhập tài khoản của bạn tại đây',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryV2,
              ),
            ],
          ),
          SizedBox(height: AppSizes.paddingMedium),
          _buildUsernameField(state),
          SizedBox(height: AppSizes.paddingMedium),
          _buildPasswordField(state),
          SizedBox(height: AppSizes.paddingMedium),
          _buildLoginButton(ref, context),
          SizedBox(height: AppSizes.paddingMedium),
        ],
      );



  Widget _buildUsernameField(LoginState state) => CustomTextField(
        controller: state.nameController,
        hintText: 'Tên đăng nhập',
        keyboardType: TextInputType.text,
      );

  Widget _buildPasswordField(LoginState state) => CustomTextField(
        controller: state.passwordController,
        hintText: 'Mật khẩu',
        obscureText: true,
        suffixIcon: Icons.visibility,
      );

  Widget _buildLoginButton(WidgetRef ref, BuildContext context) =>
      CustomButton(
        text: 'Đăng nhập',
        color: AppColors.primary,
        onPressed: () => ref.read(loginControllerProvider.notifier).login(context),
      );
}
