import 'package:flutter/rendering.dart';
import 'package:history/domain/model/user_model/user_model.dart'; // путь к вашей модели
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepository {
  final _supabase = Supabase.instance.client;

  // --- CREATE (Регистрация/Создание) ---
  Future<void> createUser(UserModel user) async {
    try {
      await _supabase.from('users').insert(user.toJson());
    } catch (e) {
      debugPrint('Ошибка при создании пользователя: $e');
    }
  }

  // --- READ (Получение данных) ---

  // Получить всех пользователей
  Future<List<UserModel>> getAllUsers() async {
    final response = await _supabase.from('users').select();
    return (response as List).map((json) => UserModel.fromJson(json)).toList();
  }

  // Получить одного по ID
  Future<UserModel?> getUserById(int id) async {
    final data = await _supabase
        .from('users')
        .select()
        .eq('id', id)
        .maybeSingle();
    return data != null ? UserModel.fromJson(data) : null;
  }

  // Получить по Email (например, для входа)
  Future<UserModel?> getUserByEmail(String email) async {
    final data = await _supabase
        .from('users')
        .select()
        .eq('email', email)
        .maybeSingle();
    return data != null ? UserModel.fromJson(data) : null;
  }

  // --- UPDATE (Обновление) ---
  Future<void> updateUser(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toJson()).eq('id', user.id);
    } catch (e) {
      debugPrint('Ошибка при обновлении профиля: $e');
    }
  }

  // --- DELETE (Удаление) ---
  Future<void> deleteUser(int id) async {
    try {
      await _supabase.from('users').delete().eq('id', id);
    } catch (e) {
      debugPrint('Ошибка при удалении пользователя: $e');
    }
  }
}
