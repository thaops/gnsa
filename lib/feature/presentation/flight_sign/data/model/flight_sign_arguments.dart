class FlightSignArguments {
  final String title;
  final List<String> supplyFormIds;
  final bool isSupplierSign;

  FlightSignArguments({
    required this.title,
    required this.supplyFormIds,
    required this.isSupplierSign,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'supplyFormIds': supplyFormIds,
      'isSupplierSign': isSupplierSign,
    };
  }

  factory FlightSignArguments.fromMap(Map<String, dynamic> map) {
    return FlightSignArguments(
      title: map['title'] as String? ?? '',
      supplyFormIds: List<String>.from(map['supplyFormIds'] ?? []),
      isSupplierSign: map['isSupplierSign'] as bool? ?? true,
    );
  }
}
