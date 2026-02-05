import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/data/service/text_service/date_formatter_service.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen/detail_object_screen.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/style/style.dart';
import 'package:history/presentation/widget/app/toast/modern_toast.dart';

class MyCommentCard extends StatelessWidget {
  final CommentModel comment;
  final Function? removeComment;

  const MyCommentCard({super.key, required this.comment, this.removeComment});

  void _showDetails(BuildContext context, String text, ObjectModel model) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [textFieldShadow],
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Индикатор свайпа
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColor.grey.withAlpha(120),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Заголовок
                Text(
                  text,
                  style: textFieldStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 12),

                /// Комментарий
                Text("Комментарий:", style: textHintStyle),
                const SizedBox(height: 6),
                Text(comment.about, style: textFieldStyle),

                const SizedBox(height: 12),

                /// Дата
                Row(
                  children: [
                    Text(
                      "Дата: ${DateFormatterService.getGreatDate(comment.date)}",
                      style: textHintStyle.copyWith(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Кнопки
                Row(
                  children: [
                    /// Удалить
                    TextButton(
                      onPressed: () async {
                        RouterService.back(context);
                        await CommentService().delete(comment);
                        removeComment?.call();
                        modernToast(context);
                      },
                      child: Text(
                        "Удалить",
                        style: textFieldStyle.copyWith(
                          color: AppColor.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// Показать объект
                    TextButton(
                      onPressed: () {
                        RouterService.routeFade(
                          context,
                          DetailObjectScreen(model: model, seeBackButton: true),
                        );
                      },
                      child: Text(
                        "Показать объект",
                        style: textFieldStyle.copyWith(
                          color: AppColor.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String getStatusByString(int status) {
    var line;
    if (status == 101) line = "В модерации";
    if (status == 102) line = "Одобренно";
    if (status == 102) line = "Заблокировано";
    return line;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ObjectService().getObjectById(comment.objectId),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Center(
            child: Container(
              height: 100,
              width: 100,
              color: Colors.transparent,
            ),
          );
        }
        return GestureDetector(
          onTap: () => _showDetails(
            context,
            snapshot.data?.label ?? "Название",
            snapshot.data!,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [textFieldShadow],
              border: Border.all(
                color: AppColor.grey.withAlpha(180),
                width: 1.2,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Название объекта
                Text(
                  snapshot.data?.label ?? "Название",
                  style: textFieldStyle.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 6),

                /// Короткий текст комментария
                Text(
                  comment.about,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textFieldStyle,
                ),

                const SizedBox(height: 8),

                /// Дата
                Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        DateFormatterService.getGreatDate(comment.date),
                        style: textHintStyle.copyWith(fontSize: 12),
                      ),
                    ),

                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Статус: ",
                            style: textHintStyle.copyWith(fontSize: 12),
                          ),
                          Text(
                            getStatusByString(comment.status),
                            style: textHintStyle.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
