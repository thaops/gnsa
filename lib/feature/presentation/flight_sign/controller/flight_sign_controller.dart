import 'dart:io';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gnsa/common/utils/custom_flushbar.dart';

class FlightSignController extends ChangeNotifier {
  File? imageFile; 

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  Future<void> saveSignature(BuildContext context) async {
    try {
      final signature = await signatureController.toPngBytes();
      if (signature != null) {
        final directory = await getApplicationDocumentsDirectory();
        String filePath = '${directory.path}/signature.png';
        File file = File(filePath);
        await file.writeAsBytes(signature);
        imageFile = file;
        await CustomFlushbar.showSuccess(context, message: 'Lưu chữ ký thành công');
      }
    } catch (e) {
      await CustomFlushbar.showError(context, message: 'Lỗi khi lưu chữ ký: $e');
    }
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }
}
