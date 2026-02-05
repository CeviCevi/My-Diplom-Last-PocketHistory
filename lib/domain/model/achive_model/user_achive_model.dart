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

  factory UserAchiveModel.fromJson(Map<String, dynamic> json) {
    return UserAchiveModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      achiveId: json['achive_id'] as int,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'user_id': userId, 'achive_id': achiveId};
  }
}
