import 'dart:async';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlightSupplyFormState {
  Future<void> updateSupplyNote(
      // ignore: non_constant_identifier_names
      {String? SupplyFormId, String? SupplyId, String? note, int? ConfirmedQuantity}) async {
    final dioApi = DioApi();
    try {
      await dioApi.patch(ApiEndpoints.updateSupplyFormNote,
      data: {
        'SupplyFormId': SupplyFormId,
        'SupplyId': SupplyId,
        'ConfirmedQuantity': ConfirmedQuantity,
        'Note': note,
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
final flightSupplyFormProvider = Provider((ref) => FlightSupplyFormState());
