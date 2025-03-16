import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnsa/common/Services/api_endpoints.dart';
import 'package:gnsa/common/repositoty/dio_api.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';

// ignore: subtype_of_sealed_class
class FlightSignatureController
    extends StateNotifier<AsyncValue<SignSupplyfrom>> {
  FlightSignatureController() : super(const AsyncValue.loading());
  Future<void> getSingSupplyfrom(String supplyfromId) async {
    try {
      state = const AsyncValue.loading();
      final dioApi = DioApi();
      final response = await dioApi
          .get(ApiEndpoints.getSignedSupplyForm(supplyFormId: supplyfromId));
      final data = SignSupplyfrom.fromJson(response.data['Data']);
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      print(e);
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final flightSignatureProvider = StateNotifierProvider<FlightSignatureController,
    AsyncValue<SignSupplyfrom>>(
  (ref) => FlightSignatureController(),
);
