class CardItemModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;

  CardItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory CardItemModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return CardItemModel(
        id: '',
        name: '',
        description: '',
        imageUrl: '',
      );
    }

    return CardItemModel(
      id: json['Id']?.toString() ?? '',
      name: json['Name']?.toString() ?? '',
      description: json['Description']?.toString() ?? '',
      imageUrl: json['ImageUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Name': name,
      'Description': description,
      'ImageUrl': imageUrl,
    };
  }
}
