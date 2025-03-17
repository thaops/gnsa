import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';

const _kSignatureFileName = 'signature.png';

// AsyncNotifier để quản lý trạng thái chữ ký
class FlightSignNotifier extends AsyncNotifier<File?> {
  // Khởi tạo SignatureController trong Notifier
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Future<File?> build() async => null; // Trạng thái ban đầu là null

  Future<void> saveSignature({
    required BuildContext context,
    required List<String> supplyFormIds,
    bool isSupplierSign = true, // Đổi tên để rõ ràng hơn
  }) async {
    state = const AsyncValue.loading();
    try {
      final file = await _generateSignatureFile();

      final formData = _createFormData(file, supplyFormIds, isSupplierSign);
      final dioApi = ref.read(dioApiProvider);
      final response = await dioApi.post(
        ApiEndpoints.signedForm,
        data: formData,
      );

      if (response.data['StatusCode'] == HttpStatus.ok) {
        await CustomFlushbar.showSuccess(context,
            message: 'Lưu chữ ký thành công');
        state = AsyncValue.data(file);
        clearSignature();
      } else {
        throw Exception('API trả về mã lỗi: ${response.statusCode}');
      }
    } catch (e, stack) {
      await CustomFlushbar.showError(context,
          message: 'Lỗi khi lưu chữ ký: $e');
      state = AsyncValue.error(e, stack);
    }
  }

  void clearSignature() => signatureController.clear();

  Future<File> _generateSignatureFile() async {
    final signature = await signatureController.toPngBytes();
    if (signature == null) throw Exception('Empty signature');

    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$_kSignatureFileName');
    return await file.writeAsBytes(signature);
  }

  FormData _createFormData(
      File file, List<String> supplyFormIds, bool isSupplierSign) {
    return FormData.fromMap({
      'supplyFormIds': supplyFormIds,
      if (isSupplierSign)
        'SupplierSign':
            MultipartFile.fromFileSync(file.path, filename: _kSignatureFileName)
      else
        'ReceiverSign': MultipartFile.fromFileSync(file.path,
            filename: _kSignatureFileName),
    });
  }
}

final flightSignProvider = AsyncNotifierProvider<FlightSignNotifier, File?>(
  () => FlightSignNotifier(),
);
