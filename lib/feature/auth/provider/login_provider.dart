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

    final handler = ref.read(asyncRequestHandlerProvider.notifier);
    final currentState = state.value;

    if (currentState == null) {
      if (context.mounted) {
        CustomFlushbar.showError(context, message: "Trạng thái đăng nhập lỗi");
      }
      return;
    }

    final username = currentState.nameController.text;
    final password = currentState.passwordController.text;
    
    print('═══════════════════════════════════════════════════════════');
    print('🔐 LOGIN ATTEMPT');
    print('Username: $username');
    print('Password: ${'*' * password.length}');
    print('═══════════════════════════════════════════════════════════');

    state = AsyncValue.loading();

    try {
      await handler.execute(
        state: state,
        apiCall: () async {
          print('🔄 Starting login API call...');
          return await _performLogin(currentState);
        },
        onSuccess: (response) async {
          print('✅ Login API call successful');
          final loginResponse = response as LoginResponseModel;
          
          // Kiểm tra statusCode từ API
          if (loginResponse.statusCode != HttpStatusCodes.STATUS_CODE_OK) {
            // Hiển thị message từ API khi statusCode != 200
            state = AsyncValue.data(currentState);
            if (context.mounted) {
              final errorMessage = loginResponse.message ?? 'Đăng nhập thất bại. Vui lòng thử lại.';
              print('❌ Login failed with statusCode: ${loginResponse.statusCode}');
              print('❌ Error message from API: $errorMessage');
              CustomFlushbar.showError(
                context,
                message: errorMessage,
              );
            }
            return;
          }
          
          await _handleLoginSuccess(loginResponse, context);
          // Reset state to data after success
          state = AsyncValue.data(currentState);
        },
        onError: (error, stackTrace) async {
          print('❌ Login API call failed: $error');
          print('Stack trace: $stackTrace');
          
          // Lấy message từ exception nếu có
          String errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
          if (error is Exception) {
            final errorStr = error.toString();
            // Lấy message từ exception (bỏ prefix "Exception: ")
            errorMessage = errorStr.replaceAll('Exception: ', '');
            // Nếu message rỗng hoặc quá ngắn, dùng message mặc định
            if (errorMessage.isEmpty || errorMessage.length < 3) {
              errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
            }
          }
          
          // Reset state to data on error to prevent UI freeze
          state = AsyncValue.data(currentState);
          if (context.mounted) {
            CustomFlushbar.showError(
              context,
              message: errorMessage,
            );
          }
        },
        rethrowError: false, // Không rethrow để tránh crash
      );
    } catch (e, st) {
      print('❌ Login exception caught: $e');
      print('Stack trace: $st');
      // Đảm bảo state được reset ngay cả khi có exception
      state = AsyncValue.data(currentState);
      if (context.mounted) {
        CustomFlushbar.showError(
          context,
          message: 'Đăng nhập thất bại. Vui lòng thử lại.',
        );
      }
    }
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
    // Không cần check statusCode ở đây nữa vì đã check ở onSuccess
    // Chỉ xử lý khi statusCode == 200
    
    print('💾 Saving access token...');
    final sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await Services(sharedPreferences).saveAccessToken(response.accessToken);
    _clearForm();

    print('✅ Login successful, navigating to main screen...');
    if (context.mounted) {
      GoRouter.of(context).push(AppRouter.main);
    }
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
