class FlightPreviewModel {
  final String? supplyFormId;
  final FlightInfo? flightInfo;
  final List<SupplyFormDetail>? supplyFormDetails;
  final int? totalSupply;
  final String? linkUrl;

  FlightPreviewModel({
    this.supplyFormId,
    this.flightInfo,
    this.supplyFormDetails,
    this.totalSupply,
    this.linkUrl,
  });

  factory FlightPreviewModel.fromJson(Map<String, dynamic> json) {
    return FlightPreviewModel(
      supplyFormId: json['SupplyFormId'] ?? '',
      flightInfo: FlightInfo.fromJson(json['FlightInfo'] ?? {}),
      supplyFormDetails: (json['SupplyFormDetails'] as List<dynamic>? ?? [])
          .map((e) => SupplyFormDetail.fromJson(e))
          .toList(),
      totalSupply: json['TotalSupply'] as int?,
      linkUrl: json['LinkUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'SupplyFormId': supplyFormId,
        'FlightInfo': flightInfo?.toJson(),
        'SupplyFormDetails':
            supplyFormDetails?.map((e) => e.toJson()).toList(),
        'TotalSupply': totalSupply,
        'LinkUrl': linkUrl,
      };
}

class FlightInfo {
  final String? flightNo;
  final String? acfNo;
  final String? routing;
  final String? departureDate;
  final String? arrivalDate;
  final String? typeApl;
  final String? groupNo;

  FlightInfo({
    this.flightNo,
    this.acfNo,
    this.routing,
    this.departureDate,
    this.arrivalDate,
    this.typeApl,
    this.groupNo,
  });

  factory FlightInfo.fromJson(Map<String, dynamic> json) {
    return FlightInfo(
      flightNo: json['FlightNo'] ?? '',
      acfNo: json['AcfNo'] ?? '',
      routing: json['Routing'] ?? '',
      departureDate: json['DepartureDate'] ?? '',
      arrivalDate: json['ArrivalDate'] ?? '',
      typeApl: json['TypeApl'] ?? '',
      groupNo: json['GroupNo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'FlightNo': flightNo,
        'AcfNo': acfNo,
        'Routing': routing,
        'DepartureDate': departureDate,
        'ArrivalDate': arrivalDate,
        'TypeApl': typeApl,
        'GroupNo': groupNo,
      };
}

class SupplyFormDetail {
  final String? supplyFormDetailId;
  final String? supplyType;
  final String? supplyCode;
  final List<DetailItem>? detailItems;

  SupplyFormDetail({
    this.supplyFormDetailId,
    this.supplyType,
    this.supplyCode,
    this.detailItems,
  });

  factory SupplyFormDetail.fromJson(Map<String, dynamic> json) {
    return SupplyFormDetail(
      supplyFormDetailId: json['SupplyFormDetailId'] ?? '',
      supplyType: json['SupplyType'] ?? '',
      supplyCode: json['SupplyCode'] ?? '',
      detailItems: (json['DetailItems'] as List<dynamic>? ?? [])
          .map((e) => DetailItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'SupplyFormDetailId': supplyFormDetailId,
        'SupplyType': supplyType,
        'SupplyCode': supplyCode,
        'DetailItems': detailItems?.map((e) => e.toJson()).toList(),
      };
}

class DetailItem {
  final String? itemName;
  final int? quantity;

  DetailItem({
    this.itemName,
    this.quantity,
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) {
    return DetailItem(
      itemName: json['ItemName'] ?? '',
      quantity: json['Quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'ItemName': itemName,
        'Quantity': quantity,
      };
}
