class SupplyForm {
  final String? supplyFormId;
  final String? supplyFormCode;
  final String? supplyType;
  final int? totalSupply;

  SupplyForm({
    this.supplyFormId,
    this.supplyFormCode,
    this.supplyType,
    this.totalSupply,
  });

  factory SupplyForm.fromJson(Map<String, dynamic> json) {
    return SupplyForm(
      supplyFormId: json['SupplyFormId'] ?? '',
      supplyFormCode: json['SupplyFormCode'] ?? '',
      supplyType: json['SupplyType'] ?? '',
      totalSupply: json['TotalSupply'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormId': supplyFormId,
      'SupplyFormCode': supplyFormCode,
      'SupplyType': supplyType,
      'TotalSupply': totalSupply,
    };
  }
}
