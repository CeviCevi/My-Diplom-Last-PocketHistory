import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/repository/achive_repository.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/domain/model/achive_model/achive_model.dart';
import 'package:history/domain/model/achive_model/user_achive_model.dart';

class AchiveService {
  final AchievementRepository _repository = AchievementRepository();

  // --- ИНИЦИАЛИЗАЦИЯ ---
  Future<void> initAchievements() async {
    try {
      // 1. Загружаем справочник всех достижений
      final allAvailable = await _repository.getAllAvailableAchievements();
      appAchiveList.clear();
      appAchiveList.addAll(allAvailable);

      // 2. Загружаем выданные достижения
      final allGranted = await _repository.getAllUserAchievements();
      achiveList.clear();
      achiveList.addAll(allGranted);

      print("Достижения синхронизированы");
    } catch (e) {
      print("Ошибка инициализации достижений: $e");
    }
  }

  // --- ЧТЕНИЕ ---
  Future<List<UserAchiveModel>> getUserAchiveListByUserId(int userId) async {
    return achiveList.where((element) => element.userId == userId).toList();
  }

  Future<AchiveModel?> getAchiveById(int achiveId) async {
    var data = appAchiveList.where((e) => e.id == achiveId).toList();
    return data.isNotEmpty ? data.first : null;
  }

  // --- ВЫДАЧА ДОСТИЖЕНИЯ (Optimistic UI) ---
  Future<bool> setUserAchiveById({
    required int userId,
    required int achiveId,
  }) async {
    // Проверяем локально, нет ли уже такой ачивки
    userId = CacheService.instance.getInt(AppKey.userInSystem) ?? userId;
    var existing = achiveList.where(
      (e) => e.achiveId == achiveId && e.userId == userId,
    );

    if (existing.isEmpty) {
      final newAchive = UserAchiveModel(
        id: DateTime.now().microsecondsSinceEpoch,
        userId: userId,
        date: DateTime.now().toIso8601String(),
        achiveId: achiveId,
      );

      // 1. Мгновенно в статику
      achiveList.add(newAchive);

      // 2. В фоне на сервер (без await)
      _repository.grantAchievement(userId, achiveId).catchError((e) {
        print("Ошибка фоновой выдачи ачивки: $e");
      });

      return true;
    }

    return false;
  }
}
