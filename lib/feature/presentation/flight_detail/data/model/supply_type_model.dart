import 'package:equatable/equatable.dart';

class SupplyTypeModel extends Equatable {
  final String key;
  final String value;

  const SupplyTypeModel({
    required this.key,
    required this.value,
  });

  factory SupplyTypeModel.fromJson(Map<String, dynamic> json) {
    return SupplyTypeModel(
      key: json['Key'] ?? '',
      value: json['Value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Key': key,
      'Value': value,
    };
  }

  @override
  List<Object?> get props => [key, value];
}
