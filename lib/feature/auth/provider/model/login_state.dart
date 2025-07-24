import 'package:flutter/material.dart';

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
    String? errorName,
    String? errorPassword,
  }) {
    return LoginState(
      nameController: nameController,
      passwordController: passwordController,
      errorName: errorName ?? this.errorName,
      errorPassword: errorPassword ?? this.errorPassword,
    );
  }
}
