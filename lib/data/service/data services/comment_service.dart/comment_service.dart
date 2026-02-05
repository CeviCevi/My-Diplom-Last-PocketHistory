import 'dart:developer';

import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/data/repository/comment_repository.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';

class CommentService {
  final CommentRepository _repository = CommentRepository();

  // --- ИНИЦИАЛИЗАЦИЯ (Загрузка при старте) ---
  Future<void> initComments() async {
    try {
      // Подтягиваем все комментарии для статики
      final allComments = await _repository.getFullCommentList();
      commentList.clear();
      commentList.addAll(allComments);
      log("Комментарии синхронизированы: ${commentList.length}");
    } catch (e) {
      log("Ошибка загрузки комментариев: $e");
    }
  }

  // --- ЧТЕНИЕ (Из статики) ---
  Future<List<CommentModel>> getCommentList() async {
    return commentList;
  }

  Future<List<CommentModel>> getUserComments(int userId) async {
    return commentList.where((element) => element.creatorId == userId).toList();
  }

  Future<List<CommentModel>> getObjectComments(
    int objectId, {
    int? userId,
  }) async {
    return commentList
        .where(
          (e) =>
              e.objectId == objectId &&
              (e.status == 102 || ((userId ?? 0) == e.creatorId)),
        )
        .toList();
  }

  // --- ЗАПИСЬ (Оптимистичный UI) ---

  // Добавление нового комментария
  Future<void> setComment(CommentModel comment) async {
    commentList.add(comment);

    _repository.addComment(comment).catchError((e) {
      log("Ошибка фоновой отправки комментария: $e");
    });
  }

  // Удаление комментария
  Future<void> delete(CommentModel comment) async {
    commentList.remove(comment);

    _repository.deleteComment(comment.id).catchError((e) {
      log("Ошибка фонового удаления комментария: $e");
    });
  }

  // Модерация: Одобрить
  Future<void> approve(CommentModel comment) async {
    final index = commentList.indexWhere((e) => e.id == comment.id);
    if (index != -1) {
      commentList[index] = comment.copyWith(status: 102);

      _repository.approveComment(comment.id).catchError((e) => log(e));
    }
  }

  // Модерация: Бан
  Future<void> ban(CommentModel comment) async {
    final index = commentList.indexWhere((e) => e.id == comment.id);
    if (index != -1) {
      commentList[index] = comment.copyWith(status: 103);

      _repository.banComment(comment.id).catchError((e) => log(e));
    }
  }
}
