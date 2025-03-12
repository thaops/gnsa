import 'package:flutter/material.dart';
import 'package:gnsa/common/Services/api_endpoints.dart' show ApiEndpoints;
import 'package:gnsa/common/Services/services.dart';
import 'package:gnsa/common/constants/http_status_codes.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';
import 'package:gnsa/common/utils/utils_deviece_udid.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginController extends ChangeNotifier {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final DioApi dioApi = DioApi();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  final deviceUdid = UtilsDeviceUdid();

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    if (nameController.text.isEmpty || passwordController.text.isEmpty) {
      await CustomFlushbar.showWarning(context, message: 'Vui lòng nhập đầy đủ thông tin');
      return;
    }
    try {
      _setLoading(true);
      final response = await dioApi.post(
        ApiEndpoints.login,
        data: {
          'UserName': nameController.text,
          'Password': passwordController.text,
        },
      );
      if (response.data['StatusCode'] != HttpStatusCodes.STATUS_CODE_OK) {
        _setLoading(false);
        await CustomFlushbar.showError(context, message: 'Tài khoản và mật khẩu không chính xác');
        return;
      }
      _setLoading(false);
      await CustomFlushbar.showSuccess(context, message: 'Đăng nhập thành công');
      final token = response.data["Data"]['AccessToken'];
      final services = await Services.create();
      await services.saveAccessToken(token);
      GoRouter.of(context).go(AppRouter.flightList);
    } catch (e) {
      await CustomFlushbar.showError(context, message: 'Tài khoản và mật khẩu không chính xác');
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
