import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/achive_model/achive_model.dart';
import 'package:history/domain/model/achive_model/user_achive_model.dart';

class AchiveService {
  Future<List<UserAchiveModel>> getUserAchiveListByUserId(int userId) async {
    return achiveList.where((element) => element.userId == userId).toList();
  }

  Future<AchiveModel?> getAchiveById(int achiveId) async {
    var data = appAchiveList.where((e) => e.id == achiveId).toList();
    return data.isNotEmpty ? data.first : null;
  }

  Future<bool> setUserAchiveById({
    required int userId,
    required int achiveId,
  }) async {
    var userAchive = achiveList
        .where((e) => e.achiveId == achiveId && e.userId == userId)
        .toList();

    if (userAchive.isEmpty) {
      achiveList.add(
        UserAchiveModel(
          id: DateTime.now().microsecondsSinceEpoch,
          userId: userId,
          date: DateTime.now().toIso8601String(),
          achiveId: achiveId,
        ),
      );
      return true;
    }

    return false;
  }
}
