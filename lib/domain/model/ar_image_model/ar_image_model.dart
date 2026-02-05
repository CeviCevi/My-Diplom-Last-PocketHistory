class ArImageModel {
  final int id;
  final int objectId;
  final String image;

  const ArImageModel({
    required this.id,
    required this.objectId,
    required this.image,
  });

  // Метод copyWith для создания копии с измененными полями
  ArImageModel copyWith({int? id, int? objectId, String? image}) {
    return ArImageModel(
      id: id ?? this.id,
      objectId: objectId ?? this.objectId,
      image: image ?? this.image,
    );
  }

  factory ArImageModel.fromJson(Map<String, dynamic> json) {
    return ArImageModel(
      id: json['id'] as int,
      objectId: json['object_id'] as int,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Теперь ID включен для корректных update-запросов
      'object_id': objectId,
      'image': image,
    };
  }
}
