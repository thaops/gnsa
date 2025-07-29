class FlightSignArguments {
  final String title;
  final List<String> supplyFormIds;
  final bool isSupplierSign;
  final bool isSupplement;

  FlightSignArguments({
    required this.title,
    required this.supplyFormIds,
    required this.isSupplierSign,
    required this.isSupplement,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'supplyFormIds': supplyFormIds,
      'isSupplierSign': isSupplierSign,
      'isSupplement': isSupplement,
    };
  }

  factory FlightSignArguments.fromMap(Map<String, dynamic> map) {
    return FlightSignArguments(
      title: map['title'] as String? ?? '',
      supplyFormIds: List<String>.from(map['supplyFormIds'] ?? []),
      isSupplierSign: map['isSupplierSign'] as bool? ?? true,
      isSupplement: map['isSupplement'] as bool? ?? true,
    );
  }
}
