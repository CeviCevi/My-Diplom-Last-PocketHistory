import 'package:history/domain/model/comment_model/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentRepository {
  final _supabase = Supabase.instance.client;

  // --- CREATE ---
  // Добавление нового комментария (по умолчанию статус 101 - модерация)
  Future<void> addComment(CommentModel comment) async {
    try {
      await _supabase.from('comments').insert(comment.toJson());
    } catch (e) {
      throw Exception('Ошибка при отправке комментария: $e');
    }
  }

  // --- READ ---

  // Получить ВСЕ комментарии (например, для админ-панели)
  Future<List<CommentModel>> getFullCommentList() async {
    final response = await _supabase.from('comments').select();
    return (response as List)
        .map((json) => CommentModel.fromJson(json))
        .toList();
  }

  // Получить одобренные комментарии для конкретного объекта (status 102)
  Future<List<CommentModel>> getObjectComments(int objectId) async {
    final response = await _supabase
        .from('comments')
        .select()
        .eq('object_id', objectId)
        .eq('status', 102);
    return (response as List)
        .map((json) => CommentModel.fromJson(json))
        .toList();
  }

  // --- UPDATE (Модерация) ---

  // Одобрить комментарий (установить статус 102)
  Future<void> approveComment(int id) async {
    await _supabase.from('comments').update({'status': 102}).eq('id', id);
  }

  // Забанить комментарий (установить статус 103)
  Future<void> banComment(int id) async {
    await _supabase.from('comments').update({'status': 103}).eq('id', id);
  }

  // --- DELETE ---
  Future<void> deleteComment(int id) async {
    try {
      await _supabase.from('comments').delete().eq('id', id);
    } catch (e) {
      throw Exception('Ошибка при удалении комментария: $e');
    }
  }
}
