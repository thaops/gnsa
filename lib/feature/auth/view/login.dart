import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/auth/provider/login_provider.dart';
import 'package:gnsa/feature/auth/provider/model/login_state.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginControllerProvider);

    return WillPopScope(
      onWillPop: () async => !loginState.isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            _LoginContent(
              state: loginState.value!,
              ref: ref,
            ),
            if (loginState.isLoading)
              ModalBarrier(
                color: Colors.black.withOpacity(0.5),
                dismissible: false,
              ),
            if (loginState.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryV2),
                ),
              ),
          ],
        ),
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
        physics: const ClampingScrollPhysics(),
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

void _validateForm(
  BuildContext context,
  WidgetRef ref,
  TextEditingController usernameController,
  TextEditingController passwordController,
  void Function(String?) setUsernameError,
  void Function(String?) setPasswordError,
) {
  final username = usernameController.text;
  final password = passwordController.text;

  bool isValid = true;

  if (username.isEmpty) {
    setUsernameError('Vui lòng nhập tên đăng nhập');
    isValid = false;
  } else if (username.contains('@')) {
    setUsernameError('Email không hợp lệ');
    isValid = false;
  } else {
    setUsernameError(null);
  }

  if (password.length < 3) {
    setPasswordError('Mật khẩu phải có ít nhất 3 ký tự');
    isValid = false;
  } else {
    setPasswordError(null);
  }

  if (isValid) {
    ref.read(loginControllerProvider.notifier).login(context);
  }
}

class _LoginForm extends HookWidget {
  final LoginState state;
  final WidgetRef ref;

  const _LoginForm({required this.state, required this.ref});

  @override
  Widget build(BuildContext context) {
    final usernameError = useState<String?>(null);
    final passwordError = useState<String?>(null);
    final usernameFocus = useFocusNode();
    final passwordFocus = useFocusNode();

    return Column(
      children: [
        _UsernameField(
          controller: state.nameController,
          ref: ref,
          errorText: usernameError.value,
          setError: (value) => usernameError.value = value,
          focusNode: usernameFocus,
          nextFocusNode: passwordFocus,
        ),
        SizedBox(height: AppSizes.paddingXMedium),
        _PasswordField(
          controller: state.passwordController,
          ref: ref,
          errorText: passwordError.value,
          setError: (value) => passwordError.value = value,
          focusNode: passwordFocus,
        ),
        SizedBox(height: AppSizes.paddingLarge),
        _LoginButton(
          validateForm: () => _validateForm(
            context,
            ref,
            state.nameController,
            state.passwordController,
            (value) => usernameError.value = value,
            (value) => passwordError.value = value,
          ),
        ),
      ],
    );
  }
}

class _UsernameField extends HookWidget {
  final TextEditingController controller;
  final WidgetRef ref;
  final String? errorText;
  final void Function(String?) setError;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  const _UsernameField({
    required this.controller,
    required this.ref,
    required this.errorText,
    required this.setError,
    this.focusNode,
    this.nextFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: 'Tên đăng nhập',
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      borderColor: AppColors.primaryV2,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      focusNode: focusNode,
      onChanged: (value) {
        setError(null);
      },
      onSubmit: () {
        nextFocusNode?.requestFocus();
      },
    );
  }
}

class _PasswordField extends HookWidget {
  final TextEditingController controller;
  final WidgetRef ref;
  final String? errorText;
  final void Function(String?) setError;
  final FocusNode? focusNode;

  const _PasswordField({
    required this.controller,
    required this.ref,
    required this.errorText,
    required this.setError,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final obscureText = useState(true);

    return CustomTextField(
      controller: controller,
      hintText: 'Mật khẩu',
      obscureText: obscureText.value,
      suffixIcon: obscureText.value ? Icons.visibility : Icons.visibility_off,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      focusNode: focusNode,
      onSubmit: () {
        ref.read(loginControllerProvider.notifier).login(context);
      },
      onChanged: (value) {
        setError(null);
      },
      onSuffixTap: () {
        obscureText.value = !obscureText.value;
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final void Function() validateForm;

  const _LoginButton({
    required this.validateForm,
  });

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Đăng nhập',
      color: AppColors.primaryV2,
      height: AppSizes.buttonHeightLarge,
      textColor: AppColors.textButton,
      onPressed: () {
        validateForm();
      },
    );
  }
}
