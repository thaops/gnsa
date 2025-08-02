
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class SignatureSection extends StatelessWidget {
  final bool isSupplierSign;
  final CrewInfo crewInfo;
  final bool isCrew;
  final List<String> supplyfromId;
  final VoidCallback onRefresh;
  final bool isSupplement;
  final Uint8List? signatureBytes;
  final String? signedName;

  const SignatureSection({
    super.key,
    required this.isSupplierSign,
    required this.crewInfo,
    required this.isCrew,
    required this.supplyfromId,
    required this.onRefresh,
    required this.isSupplement,
    required this.signatureBytes,
    required this.signedName,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomSignature(
        signatureBytes: signatureBytes,
        signedName: signedName,
        crewInfo: crewInfo,
        isCrew: isCrew,
        onPressed: () => _navigateToSignature(context),
        onEditPressed: () => _navigateToSignature(context),
      ),
    );
  }

  Future<void> _navigateToSignature(BuildContext context) async {
    final result = await context.push(
      AppRouter.flightSign,
      extra: FlightSignArguments(
        title: isCrew ? 'TIẾP VIÊN XÁC NHẬN' : 'NHÂN VIÊN XÁC NHẬN',
        supplyFormIds: supplyfromId,
        isSupplierSign: isSupplierSign,
        isSupplement: isSupplement,
        signedName: crewInfo.signedInfo ?? '',
      ),
    );

    if (result == true) {
      Future.microtask(onRefresh);
    }
  }
}