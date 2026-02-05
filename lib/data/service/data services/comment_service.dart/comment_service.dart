import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';

class CommentService {
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

  Future<void> setComment(CommentModel comment) async {
    commentList.add(comment);
  }

  Future<void> delete(CommentModel comment) async {
    commentList.remove(comment);
  }
}
