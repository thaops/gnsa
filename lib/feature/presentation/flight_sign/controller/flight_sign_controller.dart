import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';

class FlightSignController extends GetxController {

    File? imageFile; // Biến để lưu trữ file ảnh đã lưu

  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  // Hàm để lưu chữ ký vào file ảnh PNG
  Future<void> saveSignature() async {
    try {
      // Xuất chữ ký dưới dạng bytes (PNG)
      var signature = await signatureController.toPngBytes();
      if (signature != null) {
        // Lấy đường dẫn thư mục tạm của thiết bị
        final directory = await getApplicationDocumentsDirectory();
        String filePath = '${directory.path}/signature.png';

        // Tạo file ảnh
        File imageFile = File(filePath);

        // Lưu chữ ký vào file
        await imageFile.writeAsBytes(signature);
        imageFile = imageFile;

        // Hiển thị thông báo lưu thành công
        Get.snackbar('Thông báo', 'Chữ ký đã được lưu tại: $filePath');
      }
    } catch (e) {
      Get.snackbar('Thông báo', 'Lỗi khi lưu chữ ký: $e');
    }
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }
}