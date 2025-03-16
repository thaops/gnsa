class SignSupplyfrom {
  final String? supplierName;
  final String? supplierSign;
  final String? supplierSignDate;
  final String? receiveName;
  final String? receiveSign;
  final String? receiverSignDate;

  SignSupplyfrom({
     this.supplierName,
     this.supplierSign,
     this.supplierSignDate,
     this.receiveName,
     this.receiveSign,
     this.receiverSignDate,
  });

  factory SignSupplyfrom.fromJson(Map<String, dynamic> json) {
    return SignSupplyfrom(
      supplierName: json['SupplierName'] ?? "",
      supplierSign: json['SupplierSign'] ?? "",
      supplierSignDate: json['SupplierSignDate'] ?? "",
      receiveName: json['ReceiveName'] ?? "",
      receiveSign: json['ReceiveSign'] ?? "",
      receiverSignDate: json['ReceiverSignDate'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplierName': supplierName,
      'SupplierSign': supplierSign,
      'SupplierSignDate': supplierSignDate,
      'ReceiveName': receiveName,
      'ReceiveSign': receiveSign,
      'ReceiverSignDate': receiverSignDate,
    };
  }
}