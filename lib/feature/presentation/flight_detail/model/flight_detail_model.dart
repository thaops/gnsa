class FlightDetailModel {
  Flight? flight;
  List<SupplyForm>? supplyForms;

  FlightDetailModel({
    this.flight,
    this.supplyForms,
  });

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) {
    return FlightDetailModel(
      flight: json['flight'] != null ? Flight.fromJson(json['flight']) : null,
      supplyForms: json['supplyForms'] != null
          ? List<SupplyForm>.from(
              json['supplyForms'].map((form) => SupplyForm.fromJson(form)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flight': flight?.toJson(),
      'supplyForms': supplyForms?.map((form) => form.toJson()).toList(),
    };
  }
}

class Flight {
  String? flightNo;
  String? routing;
  String? flightType;
  DateTime? flightDate;
  DateTime? actualTimeDepart;
  DateTime? actualTimeArrival;

  Flight({
    this.flightNo,
    this.routing,
    this.flightType,
    this.flightDate,
    this.actualTimeDepart,
    this.actualTimeArrival,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNo: json['FlightNo'] as String?,
      routing: json['Routing'] as String?,
      flightType: json['FlightType'] as String?,
      flightDate: json['FlightDate'] != null
          ? DateTime.parse(json['FlightDate'])
          : null,
      actualTimeDepart: json['ActualTimeDepart'] != null
          ? DateTime.parse(json['ActualTimeDepart'])
          : null,
      actualTimeArrival: json['ActualTimeArrival'] != null
          ? DateTime.parse(json['ActualTimeArrival'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FlightNo': flightNo,
      'Routing': routing,
      'FlightType': flightType,
      'FlightDate': flightDate?.toIso8601String(),
      'ActualTimeDepart': actualTimeDepart?.toIso8601String(),
      'ActualTimeArrival': actualTimeArrival?.toIso8601String(),
    };
  }
}

class SupplyForm {
  String? supplyFormId;
  String? supplyFormCode;
  String? category;
  String? className;
  int? totalSupply;
  String? status;
  List<SupplyGroup>? supplies;

  SupplyForm({
    this.supplyFormId,
    this.supplyFormCode,
    this.category,
    this.className,
    this.totalSupply,
    this.status,
    this.supplies,
  });

  factory SupplyForm.fromJson(Map<String, dynamic> json) {
    return SupplyForm(
      supplyFormId: json['SupplyFormId'] as String?,
      supplyFormCode: json['SupplyFormCode'] as String?,
      category: json['Category'] as String?,
      className: json['Class'] as String?,
      totalSupply: json['TotalSupply'] as int?,
      status: json['Status'] as String?,
      supplies: json['Supplies'] != null
          ? List<SupplyGroup>.from(
              json['Supplies'].map((supply) => SupplyGroup.fromJson(supply)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormId': supplyFormId,
      'SupplyFormCode': supplyFormCode,
      'Category': category,
      'Class': className,
      'TotalSupply': totalSupply,
      'Status': status,
      'Supplies': supplies?.map((supply) => supply.toJson()).toList(),
    };
  }
}

class SupplyGroup {
  String? supplys;
  List<SupplyItem>? items;

  SupplyGroup({
    this.supplys,
    this.items,
  });

  factory SupplyGroup.fromJson(Map<String, dynamic> json) {
    return SupplyGroup(
      supplys: json['Supplys'] as String?,
      items: json['Items'] != null
          ? List<SupplyItem>.from(
              json['Items'].map((item) => SupplyItem.fromJson(item)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Supplys': supplys,
      'Items': items?.map((item) => item.toJson()).toList(),
    };
  }
}

class SupplyItem {
  String? supplyFormId;
  String? categoryName;
  String? supplyName;
  int? suppliedQuantity;
  int? confirmedQuantity;
  String? note;

  SupplyItem({
    this.supplyFormId,
    this.categoryName,
    this.supplyName,
    this.suppliedQuantity,
    this.confirmedQuantity,
    this.note,
  });

  factory SupplyItem.fromJson(Map<String, dynamic> json) {
    return SupplyItem(
      supplyFormId: json['SupplyFormId'] as String?,
      categoryName: json['CategoryName'] as String?,
      supplyName: json['SupplyName'] as String?,
      suppliedQuantity: json['SuppliedQuantity'] as int?,
      confirmedQuantity: json['ConfirmedQuantity'] as int?,
      note: json['Note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormId': supplyFormId,
      'CategoryName': categoryName,
      'SupplyName': supplyName,
      'SuppliedQuantity': suppliedQuantity,
      'ConfirmedQuantity': confirmedQuantity,
      'Note': note,
    };
  }
}