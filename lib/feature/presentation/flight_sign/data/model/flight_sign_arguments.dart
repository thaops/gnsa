class FlightSignArguments {
  final String title;
  final List<String> supplyFormIds;
  final bool isSupplierSign;
  final bool isSupplement;
  final String signedName;

  FlightSignArguments({
    required this.title,
    required this.supplyFormIds,
    required this.isSupplierSign,
    required this.isSupplement,
    required this.signedName,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'supplyFormIds': supplyFormIds,
      'isSupplierSign': isSupplierSign,
      'isSupplement': isSupplement,
      'signedName': signedName,
    };
  }

  factory FlightSignArguments.fromMap(Map<String, dynamic> map) {
    return FlightSignArguments(
      title: map['title'] as String? ?? '',
      supplyFormIds: List<String>.from(map['supplyFormIds'] ?? []),
      isSupplierSign: map['isSupplierSign'] as bool? ?? true,
      isSupplement: map['isSupplement'] as bool? ?? true,
      signedName: map['signedName'] as String? ?? '',
    );
  }
}
