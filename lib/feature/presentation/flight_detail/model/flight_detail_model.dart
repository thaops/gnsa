class FlightDetailModel {
  final String? flightNo;
  final String? routing;
  final String? flightType;
  final DateTime? flightDate;
  final DateTime? actualTimeDepart;
  final DateTime? actualTimeArrival;

  FlightDetailModel({
    this.flightNo,
    this.routing,
    this.flightType,
    this.flightDate,
    this.actualTimeDepart,
    this.actualTimeArrival, 
  });

  factory FlightDetailModel.fromJson(Map<String, dynamic> json) {
    return FlightDetailModel(
      flightNo: json['FlightNo'] ?? '',
      routing: json['Routing'] ?? '',
      flightType: json['FlightType'] ?? '',
      flightDate: DateTime.parse(json['FlightDate']),
      actualTimeDepart: DateTime.parse(json['ActualTimeDepart']),
      actualTimeArrival: DateTime.parse(json['ActualTimeArrival']),
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
