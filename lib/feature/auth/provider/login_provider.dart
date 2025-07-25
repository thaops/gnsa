import 'package:flutter/material.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/Services/services_base/api_service_ref.dart';
import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/feature/auth/data/model/login_response_model.dart';
import 'package:gnsa/feature/auth/provider/model/login_state.dart';
import 'package:gnsa/feature/auth/provider/providers.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_provider.g.dart';

@riverpod
class LoginController extends _$LoginController {
  // Khởi tạo state ban đầu
  @override
  FutureOr<LoginState> build() {
    return LoginState(
      nameController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  Future<void> login(BuildContext context) async {
    if (!context.mounted) return;

    FocusScope.of(context).unfocus();
    if (!await _validateForm()) return;

    final handler = ref.read(asyncRequestHandlerProvider.notifier);
    final currentState = state.value;

    if (currentState == null) {
      if (context.mounted) {
        CustomFlushbar.showError(context, message: "Trạng thái đăng nhập lỗi");
      }
      return;
    }

    await handler.execute(
      state: state,
      apiCall: () async {
        return await _performLogin(currentState);
      },
      onSuccess: (response) async {
        await _handleLoginSuccess(response as LoginResponseModel, context);
      },
    );
  }

  Future<LoginResponseModel> _performLogin(LoginState state) async {
    final loginUseCase = ref.read(loginUseCaseProvider);
    return await loginUseCase.execute(
      state.nameController.text,
      state.passwordController.text,
    );
  }

  Future<void> _handleLoginSuccess(
      LoginResponseModel response, BuildContext context) async {
    if (response.statusCode != HttpStatusCodes.STATUS_CODE_OK) {
      throw Exception(response.message ?? 'Đăng nhập thất bại');
    }

    final sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await Services(sharedPreferences).saveAccessToken(response.accessToken);
    _clearForm();

    if (context.mounted) {
      GoRouter.of(context).push(AppRouter.main);
    }
  }


  Future<bool> _validateForm() async {
    final currentState = state.value;
    if (currentState == null) return false;

    var isValid = true;
    var newState = currentState.copyWith(errorName: null, errorPassword: null);

    if (currentState.nameController.text.isEmpty) {
      newState = newState.copyWith(errorName: 'Vui lòng nhập tên đăng nhập');
      isValid = false;
    }

    if (currentState.passwordController.text.isEmpty) {
      newState = newState.copyWith(errorPassword: 'Vui lòng nhập mật khẩu');
      isValid = false;
    }

    if (!isValid) {
      state = AsyncData(newState);
    }

    return isValid;
  }

  void _clearForm() {
    final currentState = state.value;
    if (currentState == null) return;

    currentState.nameController.clear();
    currentState.passwordController.clear();
    state = AsyncData(currentState.copyWith(
      errorName: null,
      errorPassword: null,
    ));
  }
}
