import 'dart:io';

class FlightSignReq {
  final List<String> supplyFormDetailIds;
  final String signName;
  final bool isCrew;
  final File signedFile;

  FlightSignReq({
    required this.supplyFormDetailIds,
    required this.signName,
    required this.isCrew,
    required this.signedFile,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailIds': supplyFormDetailIds,
      'SignName': signName,
      'IsCrew': isCrew,
      'SignedFile': signedFile,
    };
  }
}
