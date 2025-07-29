import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gnsa/common/Services/services_base/async_request_handler.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';
import 'package:gnsa/feature/presentation/flight_sign/provider/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:signature/signature.dart';

part 'flight_sign_provider.g.dart';

@riverpod
class FlightSignNotifier extends _$FlightSignNotifier {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  Future<bool?> build() async => false;

Future<void> saveSignature({
  required List<String> supplyFormDetailIds,
  required bool isCrew,
  required String signedName,
  required bool isSupplement,
}) async {
  final asyncRequestHandler = ref.read(asyncRequestHandlerProvider.notifier);

  await asyncRequestHandler.execute(
    state: state,
    apiCall: () async {
      final file = await _generateSignatureFile();

      final response = await ref.read(flightSignUserCaseProvider).saveSignature(
        FlightSignReq(
          supplyFormDetailIds: supplyFormDetailIds,
          signedName: signedName,
          isCrew: isCrew,
          signedFile: file,
          isSupplement: isSupplement,
        ),
      );
      return response;
    },
    onSuccess: (response) {
      state = AsyncValue.data(response);
    },
  );
}

Future<File> _generateSignatureFile() async {
  final bytes = await signatureController.toPngBytes();
  if (bytes == null) throw Exception('Chữ ký rỗng');

  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/signature.png');
  return await file.writeAsBytes(bytes);
}

  void clearSignature() => signatureController.clear();
}
