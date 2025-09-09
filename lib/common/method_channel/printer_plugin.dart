import 'package:flutter/services.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';

class UrovoPrinter {
  static const MethodChannel _channel = MethodChannel('urovo_printer');

  /// Print GN SA supply form data
  Future<String> printGnsa(SupplyFormModel datajson) async {
    try {
      final result = await _channel.invokeMethod('printGnsa', {
        'data': datajson.toJson(),
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to print text: '${e.message}'.");
    }
    return "";
  }

  /// Print plain text
  Future<String> printText(String text) async {
    try {
      final result = await _channel.invokeMethod('printText', {
        'text': text,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to print text: '${e.message}'.");
    }
    return "";
  }

  /// Print image from asset path
  Future<String> printImage(String assetPath) async {
    try {
      final result = await _channel.invokeMethod('printImage', {
        'assetPath': assetPath,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to print image: '${e.message}'.");
    }
    return "";
  }

  /// Print preview data
  Future<String> printPreview(Map<String, dynamic> data) async {
    try {
      final result = await _channel.invokeMethod('printPreview', {
        'data': data,
      });
      return result;
    } on PlatformException catch (e) {
      print("Failed to print preview: '${e.message}'.");
    }
    return "";
  }

  /// Check printer status
  Future<String> checkPrinterStatus() async {
    try {
      final result = await _channel.invokeMethod('checkPrinterStatus');
      return result;
    } on PlatformException catch (e) {
      print("Failed to check printer status: '${e.message}'.");
    }
    return "Unknown";
  }
}
