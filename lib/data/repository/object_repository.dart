import 'dart:developer';

import 'package:history/domain/model/object_model/object_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ObjectRepository {
  final _supabase = Supabase.instance.client;

  // --- READ (Получение данных) ---

  // Получить все одобренные объекты (status = 102)
  Future<List<ObjectModel>> getObjects() async {
    final response = await _supabase
        .from('objects')
        .select()
        .eq('status', 102); // Только одобренные
    return (response as List)
        .map((json) => ObjectModel.fromJson(json))
        .toList();
  }

  // Получить объекты на модерации (status = 101)
  Future<List<ObjectModel>> getOffers() async {
    final response = await _supabase
        .from('objects')
        .select()
        .eq('status', 101); // Только новые
    return (response as List)
        .map((json) => ObjectModel.fromJson(json))
        .toList();
  }

  // --- CREATE (Добавление нового предложения) ---
  Future<void> addOffer(ObjectModel object) async {
    try {
      // При создании ID обычно генерируется базой, поэтому удаляем его из JSON
      final data = object.toJson();
      data.remove('id');

      await _supabase.from('objects').insert(data);
    } catch (e) {
      throw Exception('Ошибка при создании объекта: $e');
    }
  }

  // --- UPDATE (Обновление / Модерация) ---

  // Универсальное обновление
  Future<void> updateObject(ObjectModel object) async {
    try {
      await _supabase
          .from('objects')
          .update(object.toJson())
          .eq('id', object.id);
    } catch (e) {
      throw Exception('Ошибка обновления: $e');
    }
  }

  // Одобрение объекта (смена статуса на 102)
  Future<void> approveObject(int id) async {
    await _supabase.from('objects').update({'status': 102}).eq('id', id);
  }

  // Прямое добавление объекта (например, админом или для синхронизации)
  Future<void> addObject(ObjectModel object) async {
    try {
      final data = object.toJson();

      // ВАЖНО: Если мы генерируем ID на клиенте (как ты делаешь в статических списках),
      // то мы НЕ удаляем его, чтобы ID в базе и в статике совпали.
      // Но в таблице Supabase тип ID должен быть 'int8' (не identity),
      // либо нужно позволять вставку своего ID.

      await _supabase.from('objects').insert(data);
    } catch (e) {
      print("Ошибка при фоновом добавлении объекта: $e");
    }
  }

  Future<List<ObjectModel>> getAllObjects() async {
    try {
      final response = await _supabase.from('objects').select();
      return (response as List)
          .map((json) => ObjectModel.fromJson(json))
          .toList();
    } catch (e) {
      log("Ошибка загрузки данных из Supabase: $e");
      return [];
    }
  }

  // --- DELETE (Удаление) ---
  Future<void> deleteObject(int id) async {
    try {
      await _supabase.from('objects').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка удаления: $e');
    }
  }
}
