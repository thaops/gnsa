class SignSupplyfrom {
  final String? supplyFormDetailId;
  final List<SignDetail>? details;

  SignSupplyfrom({
    this.supplyFormDetailId,
    this.details,
  });

  factory SignSupplyfrom.fromJson(Map<String, dynamic> json) {
    return SignSupplyfrom(
      supplyFormDetailId: json['SupplyFormDetailId'] as String?,
      details: (json['Details'] as List<dynamic>?)
          ?.map((e) => SignDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SupplyFormDetailId': supplyFormDetailId,
      'Details': details?.map((e) => e.toJson()).toList(),
    };
  }
}

class SignDetail {
  final String? id;
  final String? imageUrl;
  final String? signedInfo;
  final bool? isCrew;
  final String? createdDate;

  SignDetail({
    this.id,
    this.imageUrl,
    this.signedInfo,
    this.isCrew,
    this.createdDate,
  });

  factory SignDetail.fromJson(Map<String, dynamic> json) {
    return SignDetail(
      id: json['Id'] as String?,
      imageUrl: json['ImageUrl'] as String?,
      signedInfo: json['SignedInfo'] as String?,
      isCrew: json['IsCrew'] as bool?,
      createdDate: json['CreatedDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'ImageUrl': imageUrl,
      'SignedInfo': signedInfo,
      'IsCrew': isCrew,
      'CreatedDate': createdDate,
    };
  }
}
