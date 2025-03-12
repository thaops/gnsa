// lib/feature/auth/provider/login_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/feature/auth/controller/login_controller.dart';

final loginControllerProvider = ChangeNotifierProvider<LoginController>((ref) {
  return LoginController();
});
