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
          ? List<SupplyForm>.from(json['supplyForms'].map((form) => SupplyForm.fromJson(form)))
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
      flightDate: json['FlightDate'] != null ? DateTime.parse(json['FlightDate']) : null,
      actualTimeDepart: json['ActualTimeDepart'] != null ? DateTime.parse(json['ActualTimeDepart']) : null,
      actualTimeArrival: json['ActualTimeArrival'] != null ? DateTime.parse(json['ActualTimeArrival']) : null,
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

  SupplyForm({
    this.supplyFormId,
    this.supplyFormCode,
    this.category,
    this.className,
    this.totalSupply,
    this.status,
  });

  factory SupplyForm.fromJson(Map<String, dynamic> json) {
    return SupplyForm(
      supplyFormId: json['SupplyFormId'] as String?,
      supplyFormCode: json['SupplyFormCode'] as String?,
      category: json['Category'] as String?,
      className: json['Class'] as String?,
      totalSupply: json['TotalSupply'] as int?,
      status: json['Status'] as String?,
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
    };
  }
}
