import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/provider/login_provider.dart';
import 'package:http/http.dart' as ref;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);

    ref.listen(loginControllerProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stack) {
          CustomFlushbar.showError(context,
              message: 'Đăng nhập thất bại: $error');
        },
      );
    });

    return Scaffold(
      body: Stack(
        children: [
          loginState.when(
            data: (state) => _LoginContent(state: state, ref: ref),
            loading: () => Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryV2),
                ),
              ),
            ),
            error: (error, stack) =>
                _LoginContent(state: loginState.value!, ref: ref),
          ),
        ],
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  final LoginState state;
  final WidgetRef ref;

  const _LoginContent({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _LoginHeader(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                _LoginForm(state: state, ref: ref),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(Img.logo),
        SizedBox(height: AppSizes.paddingLarge),
        Column(
          children: [
            TextWidget(
              text: 'Xin chào!',
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryV2,
            ),
            SizedBox(height: AppSizes.paddingSmall),
            TextWidget(
              text: 'Đăng nhập tài khoản của bạn tại đây',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryV2,
            ),
          ],
        ),
      ],
    );
  }
}

class _LoginForm extends StatelessWidget {
  final LoginState state;
  final WidgetRef ref;
  

  const _LoginForm({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UsernameField(
          controller: state.nameController,
          ref: ref,
        ),
        SizedBox(height: AppSizes.paddingXMedium),
        _PasswordField(
          controller: state.passwordController,
          ref: ref,
        ),
        SizedBox(height: AppSizes.paddingLarge),
        _LoginButton(ref: ref),
      ],
    );
  }
}

// ignore: must_be_immutable
class _UsernameField extends HookWidget {
  final TextEditingController controller;
  final WidgetRef ref;
   _UsernameField({
    required this.controller,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final errorTextState = useState<String?>("Vui lòng nhập tên đăng nhập");
    return CustomTextField(
      controller: controller,
      hintText: 'Tên đăng nhập',
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      borderColor: AppColors.primaryV2,
      errorText: errorTextState.value,
      textInputAction: TextInputAction.next,
      onChanged: (value) {
        errorTextState.value = value.isEmpty
            ? 'Vui lòng nhập tên đăng nhập'
            : value.contains('@')
                ? 'Email không hợp lệ'
                : null;
      },
      onSubmit: () {
        FocusScope.of(context).nextFocus();
      },
    );
  }
}

// ignore: must_be_immutable
class _PasswordField extends HookWidget {
  final TextEditingController controller;
  final WidgetRef ref;
   _PasswordField({
    required this.controller,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);
    final errorTextState = useState<String?>("Vui lòng nhập mật khẩu");

    return CustomTextField(
      controller: controller,
      hintText: 'Mật khẩu',
      obscureText: obscureText.value,
      suffixIcon: obscureText.value ? Icons.visibility : Icons.visibility_off,
      errorText: errorTextState.value,
      textInputAction: TextInputAction.done,
      onSubmit: () {
        FocusScope.of(context).unfocus();
        ref.read(loginControllerProvider.notifier).login(context);
      },
      onChanged: (value) {
        errorTextState.value = value.length < 6 ? 'Ít nhất 6 ký tự' : null;
      },
      onSuffixTap: () {
        obscureText.value = !obscureText.value;
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final WidgetRef ref;

  const _LoginButton({required this.ref});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Đăng nhập',
      color: AppColors.primaryV2,
      height: AppSizes.buttonHeightLarge,
      textColor: AppColors.textButton,
      onPressed: () {
        FocusScope.of(context).unfocus();
        ref.read(loginControllerProvider.notifier).login(context);
      },
    );
  }
}
