class MarkerModel {
  final int id;
  final int objectId;
  final String title;
  final String description;
  final double xPercent;
  final double yPercent;

  MarkerModel({
    required this.id,
    required this.objectId,
    required this.title,
    required this.description,
    required this.xPercent,
    required this.yPercent,
  });

  factory MarkerModel.fromJson(Map<String, dynamic> json) {
    return MarkerModel(
      id: json['id'] as int,
      objectId: json['object_id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      xPercent: (json['x_percent'] as num).toDouble(),
      yPercent: (json['y_percent'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'object_id': objectId,
      'title': title,
      'description': description,
      'x_percent': xPercent,
      'y_percent': yPercent,
    };
  }
}
