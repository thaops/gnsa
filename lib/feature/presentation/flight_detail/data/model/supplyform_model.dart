import 'package:equatable/equatable.dart';
import 'package:gnsa/feature/presentation/flight_detail/data/model/flight_preview_model.dart';

class SupplyFormModel extends Equatable {
  final String? supplyFormId;
  final FlightInfo? flightInfo;
  final List<SupplyFormDetail>? supplyFormDetails;
  final List<SupplyFormDetail>? additionalFormDetails;

  const SupplyFormModel({
    this.supplyFormId,
    this.flightInfo,
    this.supplyFormDetails,
    this.additionalFormDetails = const [],
  });

  factory SupplyFormModel.fromJson(Map<String, dynamic> json) {
    return SupplyFormModel(
      supplyFormId: json['SupplyFormId'] as String?,
      flightInfo: json['FlightInfo'] != null
          ? FlightInfo.fromJson(json['FlightInfo'])
          : null,
      supplyFormDetails: (json['SupplyFormDetails'] as List<dynamic>?)
              ?.map((e) => SupplyFormDetail.fromJson(e))
              .toList() ??
          [],
      additionalFormDetails: (json['AdditionalFormDetails'] as List<dynamic>?)
              ?.map((e) => SupplyFormDetail.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormId': supplyFormId,
      'FlightInfo': flightInfo?.toJson(),
      'SupplyFormDetails': supplyFormDetails?.map((e) => e.toJson()).toList(),
      'AdditionalFormDetails':
          additionalFormDetails?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props =>
      [supplyFormId, flightInfo, supplyFormDetails, additionalFormDetails];
}

class SupplyFormDetail extends Equatable {
  final String supplyFormDetailId;
  final String supplyType;
  final String supplyName;
  final String status;
  final String supplyCode;
  final List<DetailItemGroup> detailItems;

  const SupplyFormDetail({
    required this.supplyFormDetailId,
    required this.supplyType,
    required this.supplyName,
    required this.status,
    required this.supplyCode,
    required this.detailItems,
  });

  factory SupplyFormDetail.fromJson(Map<String, dynamic> json) {
    return SupplyFormDetail(
      supplyFormDetailId: json['SupplyFormDetailId'] ?? '',
      supplyType: json['SupplyType'] ?? '',
      supplyName: json['SupplyName'] ?? '',
      status: json['Status'] ?? '',
      supplyCode: json['SupplyCode'] ?? '',
      detailItems: (json['DetailItems'] as List<dynamic>?)
              ?.map((e) => DetailItemGroup.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'SupplyType': supplyType,
      'SupplyName': supplyName,
      'Status': status,
      'SupplyCode': supplyCode,
      'DetailItems': detailItems.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        supplyFormDetailId,
        supplyType,
        supplyName,
        status,
        supplyCode,
        detailItems
      ];
}

class DetailItemGroup extends Equatable {
  final String className;
  final List<SupplyItem> items;

  const DetailItemGroup({
    required this.className,
    required this.items,
  });

  factory DetailItemGroup.fromJson(Map<String, dynamic> json) {
    return DetailItemGroup(
      className: json['ClassName'] ?? '',
      items: (json['Items'] as List<dynamic>?)
              ?.map((e) => SupplyItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ClassName': className,
      'Items': items.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [className, items];
}

class SupplyItem extends Equatable {
  final String detailItemId;
  final String itemId;
  final String name;
  final int supplyQuantity;
  final int additionalQuantity;
  final int confirmedQuantity;
  final String note;

  const SupplyItem({
    required this.detailItemId,
    required this.itemId,
    required this.name,
    required this.supplyQuantity,
    required this.additionalQuantity,
    required this.confirmedQuantity,
    required this.note,
  });

  factory SupplyItem.fromJson(Map<String, dynamic> json) {
    return SupplyItem(
      detailItemId: json['DetailItemId'] ?? '',
      itemId: json['ItemId'] ?? '',
      name: json['Name'] ?? '',
      supplyQuantity: json['SupplyQuantity'] ?? 0,
      additionalQuantity: json['AdditionalQuantity'] ?? 0,
      confirmedQuantity: json['ConfirmedQuantity'] ?? 0,
      note: json['Note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DetailItemId': detailItemId,
      'ItemId': itemId,
      'Name': name,
      'SupplyQuantity': supplyQuantity,
      'AdditionalQuantity': additionalQuantity,
      'ConfirmedQuantity': confirmedQuantity,
      'Note': note,
    };
  }

  @override
  List<Object?> get props => [
        detailItemId,
        itemId,
        name,
        supplyQuantity,
        additionalQuantity,
        confirmedQuantity,
        note,
      ];
}
