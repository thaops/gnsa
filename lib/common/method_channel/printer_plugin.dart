import 'package:flutter/services.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';

class UrovoPrinter {
  static const MethodChannel _channel = MethodChannel('urovo_printer');

  Future<String> printGnsa(FlightDetailModel datajson) async {
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
  
}
