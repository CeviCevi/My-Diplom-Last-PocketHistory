import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarkerRepository {
  final _supabase = Supabase.instance.client;

  // --- CREATE ---
  Future<void> addMarker(MarkerModel marker) async {
    try {
      await _supabase.from('markers').insert(marker.toJson());
    } catch (e) {
      throw Exception('Ошибка при добавлении маркера: $e');
    }
  }

  // --- READ ---
  // Получить все маркеры для конкретного объекта
  Future<List<MarkerModel>> getMarkersByObject(int objectId) async {
    try {
      final response = await _supabase
          .from('markers')
          .select()
          .eq('object_id', objectId);

      return (response as List)
          .map((json) => MarkerModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Ошибка при получении маркеров: $e');
    }
  }

  // --- UPDATE ---
  Future<void> updateMarker(MarkerModel marker) async {
    try {
      await _supabase
          .from('markers')
          .update(marker.toJson())
          .eq('id', marker.id);
    } catch (e) {
      throw Exception('Ошибка при обновлении маркера: $e');
    }
  }

  // --- DELETE ---
  Future<void> deleteMarker(int id) async {
    try {
      await _supabase.from('markers').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка при удалении маркера: $e');
    }
  }
}
