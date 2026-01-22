import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/data/service/text_service/date_formatter_service.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final int currentUserId;

  const CommentCard({
    super.key,
    required this.comment,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = comment.creatorId == currentUserId;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.white,
        border: Border.all(
          color: isMine ? AppColor.red : Colors.grey.shade300,
          width: isMine ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Имя пользователя и время
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FutureBuilder(
                future: UserService().getUserById(comment.creatorId),
                builder: (c, s) => Text(
                  s.data?.name ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMine ? AppColor.red : Colors.black87,
                  ),
                ),
              ),
              Text(
                DateFormatterService.getGreatDate(comment.date),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Текст комментария
          Text(comment.about, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
