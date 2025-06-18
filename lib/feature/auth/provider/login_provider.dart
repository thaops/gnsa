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
  final String? errorName;
  final String? errorPassword;

  LoginState({
    required this.nameController,
    required this.passwordController,
    this.errorName,
    this.errorPassword,
  });

  LoginState copyWith({
    TextEditingController? nameController,
    TextEditingController? passwordController,
    String? errorName,
    String? errorPassword,
    bool? isFormValid,
  }) {
    return LoginState(
      nameController: nameController ?? this.nameController,
      passwordController: passwordController ?? this.passwordController,
      errorName: errorName ?? this.errorName,
      errorPassword: errorPassword ?? this.errorPassword,
    );
  }
}

class LoginController extends _$LoginController {
  final DioApi _dioApi = DioApi();

  @override
  FutureOr<LoginState> build() {
    return LoginState(
      nameController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    
    if(state.value!.nameController.text.isEmpty || state.value!.passwordController.text.isEmpty){
      state = AsyncValue.data(state.value!.copyWith(
        errorName: 'Vui lòng nhập tên đăng nhập',
        errorPassword: 'Vui lòng nhập mật khẩu',
      ));
      return;
    }
    state = const AsyncValue.loading();
    try {
      // final response = await _dioApi.post(
      //   ApiEndpoints.login,
      //   data: {
      //     'UserName': state.value!.nameController.text,
      //     'Password': state.value!.passwordController.text,
      //   },
      // );

      // if (response.data['StatusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
      //   CustomFlushbar.showError(context,
      //       message: 'Tên đăng nhập hoặc mật khẩu không đúng ${response.data['Message']}');
      //       return;
      // } 
      //   final token = response.data["Data"]['AccessToken'];
      //   await Services.create().then((services) => services.saveAccessToken(token));
      //   state.value!.nameController.clear();
      //   state.value!.passwordController.clear();
      //   state = AsyncValue.data(state.value!.copyWith(
      //     errorName: null,
      //     errorPassword: null,
      //   ));
      
          GoRouter.of(context).go(AppRouter.main);
        
      
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      if (context.mounted) {
        CustomFlushbar.showError(context, message: 'Đã xảy ra lỗi: $e');
      }
    }
  }
}