class CommentModel {
  final int id;
  final int objectId;
  final int creatorId;
  final String about;
  final String date;

  CommentModel({
    required this.id,
    required this.objectId,
    required this.creatorId,
    required this.about,
    required this.date,
  });
}
