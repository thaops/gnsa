class SignSupplyfrom {
  final String? supplyFormDetailId;
  final CrewInfo? crew;
  final CrewInfo? employee;

  SignSupplyfrom({
    this.supplyFormDetailId,
    this.crew,
    this.employee,
  });

  factory SignSupplyfrom.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return SignSupplyfrom(
        supplyFormDetailId: '',
        crew: CrewInfo.empty(),
        employee: CrewInfo.empty(),
      );
    }

    return SignSupplyfrom(
      supplyFormDetailId: json['SupplyFormDetailId']?.toString() ?? '',
      crew: CrewInfo.fromJson(json['Crew']),
      employee: CrewInfo.fromJson(json['Employee']),
    );
  }

  Map<String, dynamic> toJson() => {
        'SupplyFormDetailId': supplyFormDetailId,
        'Crew': crew?.toJson(),
        'Employee': employee?.toJson(),
      };
}

class CrewInfo {
  final String id;
  final String? imageUrl;
  final String? signedInfo;
  final bool isCrew;
  final DateTime createdDate;

  CrewInfo({
    required this.id,
    this.imageUrl,
    this.signedInfo,
    required this.isCrew,
    required this.createdDate,
  });

  factory CrewInfo.fromJson(Map<String, dynamic>? json) {
    if (json == null) return CrewInfo.empty();

    return CrewInfo(
      id: json['Id']?.toString() ?? '',
      imageUrl: json['ImageUrl']?.toString(),
      signedInfo: json['SignedInfo']?.toString() ?? '',
      isCrew: json['IsCrew'] == true,
      createdDate: _parseDate(json['CreatedDate'] ?? ''),
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue is String && dateValue.isNotEmpty) {
      try {
        return DateTime.parse(dateValue);
      } catch (_) {
        return DateTime(1970); // default fallback
      }
    }
    return DateTime(1970); // fallback nếu null hoặc không hợp lệ
  }

  Map<String, dynamic> toJson() => {
        'Id': id,
        'ImageUrl': imageUrl,
        'SignedInfo': signedInfo,
        'IsCrew': isCrew,
        'CreatedDate': createdDate.toIso8601String(),
      };

  factory CrewInfo.empty() => CrewInfo(
        id: '',
        imageUrl: null,
        signedInfo: '',
        isCrew: false,
        createdDate: DateTime(1970),
      );
}
