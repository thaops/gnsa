import 'package:flutter/material.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginController extends ChangeNotifier {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final DioApi _dioApi = DioApi();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearInputs() {
    nameController.clear();
    passwordController.clear();
  }

  Future<void> login(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!_validateInputs()) {
      _showWarning(context, 'Vui lòng nhập đầy đủ thông tin');
      return;
    }

    try {
      _setLoading(true);
      final response = await _dioApi.post(
        ApiEndpoints.login,
        data: {
          'UserName': nameController.text.trim(),
          'Password': passwordController.text,
        },
      );

      await _handleLoginResponse(response, context);
      _clearInputs();
    } catch (e) {
      _handleError(context, e);
    } finally {
      _setLoading(false);
    }
  }

  bool _validateInputs() =>
      nameController.text.isNotEmpty && passwordController.text.isNotEmpty;

  Future<void> _handleLoginResponse(dynamic response, BuildContext context) async {
    if (response.data['StatusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
      _showError(context, 'Tài khoản và mật khẩu không chính xác');
      return;
    }

    final token = response.data["Data"]['AccessToken'];
    await Services.create().then((services) => services.saveAccessToken(token));
    _showSuccess(context, 'Đăng nhập thành công');
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

  void _showSuccess(BuildContext context, String message) =>
      CustomFlushbar.showSuccess(context, message: message);

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}