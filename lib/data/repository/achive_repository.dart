import 'dart:developer';

import 'package:history/domain/model/achive_model/achive_model.dart';
import 'package:history/domain/model/achive_model/user_achive_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AchievementRepository {
  final _supabase = Supabase.instance.client;

  // --- СПРАВОЧНИК ДОСТИЖЕНИЙ ---

  // Получить список всех существующих достижений в игре
  Future<List<AchiveModel>> getAllAvailableAchievements() async {
    final response = await _supabase.from('achievements').select();
    return (response as List)
        .map((json) => AchiveModel.fromJson(json))
        .toList();
  }

  Future<List<UserAchiveModel>> getAllUserAchievements() async {
    try {
      final response = await _supabase.from('user_achievements').select();
      return (response as List)
          .map((json) => UserAchiveModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Ошибка загрузки списка выданных ачивок: $e");
      return [];
    }
  }
  // --- ДОСТИЖЕНИЯ ПОЛЬЗОВАТЕЛЯ ---

  // Получить все награды конкретного пользователя
  Future<List<UserAchiveModel>> getUserAchievements(int userId) async {
    final response = await _supabase
        .from('user_achievements')
        .select()
        .eq('user_id', userId);
    return (response as List)
        .map((json) => UserAchiveModel.fromJson(json))
        .toList();
  }

  // Выдать достижение пользователю
  Future<void> grantAchievement(int userId, int achiveId) async {
    try {
      // Проверяем, нет ли уже такого достижения у пользователя
      final existing = await _supabase
          .from('user_achievements')
          .select()
          .eq('user_id', userId)
          .eq('achive_id', achiveId)
          .maybeSingle();

      if (existing == null) {
        await _supabase.from('user_achievements').insert({
          'user_id': userId,
          'achive_id': achiveId,
        });
      }
    } catch (e) {
      throw Exception('Ошибка при выдаче достижения: $e');
    }
  }

  // Удалить достижение у пользователя (если нужно для тестов)
  Future<void> revokeAchievement(int id) async {
    await _supabase.from('user_achievements').delete().eq('id', id);
  }
}
