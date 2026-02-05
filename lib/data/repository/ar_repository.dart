import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArImageRepository {
  final _supabase = Supabase.instance.client;

  // --- CREATE ---
  // Добавить новое AR-изображение для объекта
  Future<void> addArImage(ArImageModel arImage) async {
    try {
      await _supabase.from('ar_images').insert(arImage.toJson());
    } catch (e) {
      throw Exception('Ошибка при сохранении AR-изображения: $e');
    }
  }

  // --- READ ---
  // Получить список всех AR-изображений для конкретного объекта
  Future<List<ArImageModel>> getArImagesByObject(int objectId) async {
    try {
      final response = await _supabase
          .from('ar_images')
          .select()
          .eq('object_id', objectId);

      return (response as List)
          .map((json) => ArImageModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении AR-данных: $e');
    }
  }

  // Получить вообще все AR-изображения (например, для админки)
  Future<List<ArImageModel>> getAllArImages() async {
    final response = await _supabase.from('ar_images').select();
    return (response as List)
        .map((json) => ArImageModel.fromJson(json))
        .toList();
  }

  // --- DELETE ---
  Future<void> deleteArImage(int id) async {
    try {
      await _supabase.from('ar_images').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка при удалении AR-изображения: $e');
    }
  }
}
