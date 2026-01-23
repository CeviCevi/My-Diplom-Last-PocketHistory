class UserAchiveModel {
  final int id;
  final int achiveId;
  final int userId;
  final String date;

  const UserAchiveModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.achiveId,
  });
}
