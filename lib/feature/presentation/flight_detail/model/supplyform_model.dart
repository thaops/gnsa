class SupplyFormModel {
  final String? supplyFormId;
  final FlightInfo? flightInfo;
  final List<SupplyFormDetail>? supplyFormDetails;
  final List<SupplyFormDetail>? additionalFormDetails;

  SupplyFormModel({
     this.supplyFormId,
     this.flightInfo,
     this.supplyFormDetails,
     this.additionalFormDetails,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormId': supplyFormId,
      'FlightInfo': flightInfo?.toJson(),
      'SupplyFormDetails': supplyFormDetails?.map((e) => e.toJson()).toList(),
      'AdditionalFormDetails': additionalFormDetails?.map((e) => e.toJson()).toList(),
    };
  }

  factory SupplyFormModel.fromJson(Map<String, dynamic> json) {
    return SupplyFormModel(
      supplyFormId: json['SupplyFormId'] ,
      flightInfo: FlightInfo.fromJson(json['FlightInfo']),
      supplyFormDetails: (json['SupplyFormDetails'] as List)
          .map((e) => SupplyFormDetail.fromJson(e))
          .toList(),
      additionalFormDetails: (json['AdditionalFormDetails'] as List)
          .map((e) => SupplyFormDetail.fromJson(e))
          .toList(),
    );
  }
}
class FlightInfo {
  final String flightNo;
  final String acfNo;
  final String routing;
  final DateTime departureDate;
  final DateTime arrivalDate;
  final String typeApl;
  final String groupNo;

  FlightInfo({
    required this.flightNo,
    required this.acfNo,
    required this.routing,
    required this.departureDate,
    required this.arrivalDate,
    required this.typeApl,
    required this.groupNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'FlightNo': flightNo,
      'AcfNo': acfNo,
      'Routing': routing,
      'DepartureDate': departureDate.toIso8601String(),
      'ArrivalDate': arrivalDate.toIso8601String(),
      'TypeApl': typeApl,
      'GroupNo': groupNo,
    };
  }

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      flightNo: json['FlightNo'],
      acfNo: json['AcfNo'],
      routing: json['Routing'],
      departureDate: DateTime.parse(json['DepartureDate']),
      arrivalDate: DateTime.parse(json['ArrivalDate']),
      typeApl: json['TypeApl'],
      groupNo: json['GroupNo'],
    );
  }
}
class SupplyFormDetail {
  final String supplyFormDetailId;
  final String supplyType;
  final String className;
  final String supplyCode;
  final List<SupplyItem> items;

  SupplyFormDetail({
    required this.supplyFormDetailId,
    required this.supplyType,
    required this.className,
    required this.supplyCode,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'SupplyType': supplyType,
      'ClassName': className,
      'SupplyCode': supplyCode,
      'Items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory SupplyFormDetail.fromJson(Map<String, dynamic> json) {
    return SupplyFormDetail(
      supplyFormDetailId: json['SupplyFormDetailId'],
      supplyType: json['SupplyType'],
      className: json['ClassName'],
      supplyCode: json['SupplyCode'],
      items: (json['Items'] as List)
          .map((e) => SupplyItem.fromJson(e))
          .toList(),
    );
  }
}
class SupplyItem {
  final String supplyFormDetailItemId;
  final String name;
  final int supplyQuantity;
  final int? additionalQuantity;
  final int confirmedQuantity;
  final String note;

  SupplyItem({
    required this.supplyFormDetailItemId,
    required this.name,
    required this.supplyQuantity,
    this.additionalQuantity,
    required this.confirmedQuantity,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailItemId': supplyFormDetailItemId,
      'Name': name,
      'SupplyQuantity': supplyQuantity,
      'AdditionalQuantity': additionalQuantity,
      'ConfirmedQuantity': confirmedQuantity,
      'Note': note,
    };
  }

  factory SupplyItem.fromJson(Map<String, dynamic> json) {
    return SupplyItem(
      supplyFormDetailItemId: json['SupplyFormDetailItemId'],
      name: json['Name'],
      supplyQuantity: json['SupplyQuantity'],
      additionalQuantity: json['AdditionalQuantity'],
      confirmedQuantity: json['ConfirmedQuantity'],
      note: json['Note'] ?? '',
    );
  }
}
