
class FlightsModel {
  List<FlightData>? data;

  FlightsModel({
     this.data,
  });

  factory FlightsModel.fromJson(Map<String, dynamic> json) {
    return FlightsModel(
      data: (json['Data'] as List<dynamic>?)
          ?.map((item) => FlightData.fromJson(item))
          .toList() ?? [],  // Kiểm tra null và tạo danh sách rỗng nếu null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Data': data?.map((flight) => flight.toJson()).toList(),
    };
  }

  static FlightsModel empty() {
    return FlightsModel(
      data: [],
    );
  }

  FlightsModel copyWith({List<FlightData>? data}) {
    return FlightsModel(
      data: data ?? this.data,
    );
  }
}

class FlightData {
  final String? id;
  final String? flightNo;
  final DateTime? flightDate;
  final DateTime? actualTimeDepart;
  final DateTime? actualTimeArrival;
  final String? routing;
  final String? depart;
  final String? arrival;
  final String? status;
  final String? airlineCode;

  FlightData({
    this.id,
    this.flightNo,
    this.flightDate,
    this.actualTimeDepart,
    this.actualTimeArrival,
    this.routing,
    this.depart,
    this.arrival,
    this.status,
    this.airlineCode,
  });

  factory FlightData.fromJson(Map<String, dynamic> json) {
    return FlightData(
      id: json['Id'] ?? '',
      flightNo: json['FlightNo'] ?? '',
      flightDate: json['FlightDate'] != null ? DateTime.parse(json['FlightDate']) : null,
      actualTimeDepart: json['ActualTimeDepart'] != null ? DateTime.parse(json['ActualTimeDepart']) : null,
      actualTimeArrival: json['ActualTimeArrival'] != null ? DateTime.parse(json['ActualTimeArrival']) : null,
      routing: json['Routing'] ?? '',
      depart: json['Depart'] ?? '',
      arrival: json['Arrival'] ?? '',
      status: json['Status'] ?? '',
      airlineCode: json['AirlineCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id ?? '',
      'FlightNo': flightNo ?? '',
      'FlightDate': flightDate?.toIso8601String(),
      'ActualTimeDepart': actualTimeDepart?.toIso8601String(),
      'ActualTimeArrival': actualTimeArrival?.toIso8601String(),
      'Routing': routing ?? '',
      'Depart': depart ?? '',
      'Arrival': arrival ?? '',
      'Status': status ?? '',
      'AirlineCode': airlineCode ?? '',
    };
  }
}