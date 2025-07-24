// import 'package:flutter/material.dart';
// import 'package:gnsa/common/Services/services_base/base_status.dart';
// import 'package:gnsa/common/utils/custom_flushbar.dart';
// import 'package:riverpod_annotation/riverpod_annotation.dart';

// class ApiServiceRef {
//   final Ref ref;
//   ApiServiceRef(this.ref);

// Future<T> executeApiCall<T>(
//     {
//       required TaskEnum task,
//       required Future<T> Function() apiCall,
//       required Future<void> Function(T) onSuccess,
//     }) async {
//   try {
//     final result = await apiCall();

//     await onSuccess(result);
//     return result;
//   } catch (e, stackTrace) {
//     throw ApiEx
//   }
// }
// }