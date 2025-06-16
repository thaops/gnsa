// lib/feature/auth/controller/login_controller.dart
import 'package:flutter/material.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

class LoginState {
  final TextEditingController nameController;
  final TextEditingController passwordController;

  LoginState({
    required this.nameController,
    required this.passwordController,
  });

  LoginState copyWith({
    TextEditingController? nameController,
    TextEditingController? passwordController,
  }) {
    return LoginState(
      nameController: nameController ?? this.nameController,
      passwordController: passwordController ?? this.passwordController,
    );
  }
}

@riverpod
class LoginController extends _$LoginController {
  final DioApi _dioApi = DioApi();

  @override
  FutureOr<LoginState> build() {
    return LoginState(
      nameController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  void _clearInputs() {
    state.value!.nameController.clear();
    state.value!.passwordController.clear();
  }

  bool _validateInputs() =>
      state.value!.nameController.text.isNotEmpty &&
      state.value!.passwordController.text.isNotEmpty;

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_validateInputs()) {
      _showWarning(context, 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    try {
      final response = await _dioApi.post(
        ApiEndpoints.login,
        data: {
          'UserName': state.value!.nameController.text.trim(),
          'Password': state.value!.passwordController.text,
        },
      );

      await _handleLoginResponse(response, context);
      _clearInputs();
    } catch (e) {
      _handleError(context, e);
    }
  }

  Future<void> _handleLoginResponse(dynamic response, BuildContext context) async {
    if (response.data['StatusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
      _showError(context, 'Tài khoản và mật khẩu không chính xác');
      return;
    }

    final token = response.data["Data"]['AccessToken'];
    await Services.create().then((services) => services.saveAccessToken(token));
    GoRouter.of(context).go(AppRouter.flightList);
  }

  void _handleError(BuildContext context, dynamic error) {
    debugPrint('Login error: $error');
    _showError(context, 'Tài khoản và mật khẩu không chính xác');
  }

  void _showWarning(BuildContext context, String message) =>
      CustomFlushbar.showWarning(context, message: message);

  void _showError(BuildContext context, String message) =>
      CustomFlushbar.showError(context, message: message);

}