import 'package:gnsa/feature/presentation/flight_detail/data/model/supplyform_model.dart';

class FlightPreviewModel {
  final String? supplyFormId;
  final FlightInfo? flightInfo;
  final List<SupplyFormDetail>? supplyFormDetails;

  FlightPreviewModel({
    this.supplyFormId,
    this.flightInfo,
    this.supplyFormDetails,
  });

  factory FlightPreviewModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FlightPreviewModel(
        supplyFormId: '',
        flightInfo: FlightInfo(),
        supplyFormDetails: [],
      );
    }

    return FlightPreviewModel(
      supplyFormId: json['SupplyFormId']?.toString() ?? '',
      flightInfo: FlightInfo.fromJson(json['FlightInfo'] as Map<String, dynamic>),
      supplyFormDetails: (json['SupplyFormDetails'] as List<dynamic>?)
              ?.map((e) => SupplyFormDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'SupplyFormId': supplyFormId,
        'FlightInfo': flightInfo?.toJson(),
        'SupplyFormDetails': supplyFormDetails?.map((e) => e.toJson()).toList(),
      };
}
