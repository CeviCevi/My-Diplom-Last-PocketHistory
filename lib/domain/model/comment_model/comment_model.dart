class CommentModel {
  final int id;
  final int objectId;
  final int creatorId;
  final String about;
  final String date;
  final int status;

  CommentModel({
    required this.id,
    required this.objectId,
    required this.creatorId,
    required this.about,
    required this.date,
    required this.status,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] as int,
      objectId: json['object_id'] as int,
      creatorId: json['creator_id'] as int,
      about: json['about'] as String,
      date: json['date'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'object_id': objectId,
      'creator_id': creatorId,
      'about': about,
      'status': status,
      //'date': date,
    };
  }

  CommentModel copyWith({
    int? id,
    int? objectId,
    int? creatorId,
    String? about,
    String? date,
    int? status,
  }) {
    return CommentModel(
      id: id ?? this.id,
      objectId: objectId ?? this.objectId,
      creatorId: creatorId ?? this.creatorId,
      about: about ?? this.about,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}
