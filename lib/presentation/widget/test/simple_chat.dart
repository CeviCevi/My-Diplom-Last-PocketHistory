import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/domain/model/comment_model/comment_model.dart';
import 'package:history/presentation/screen/user/comment_screen/widget/comment_card.dart';
import 'package:history/presentation/widget/app/text_field/castle_text_field/castle_text_field.dart';

class ChatBottomSheet extends StatefulWidget {
  final int currentUserId;
  final int objectId;

  const ChatBottomSheet({
    super.key,
    required this.currentUserId,
    required this.objectId,
  });

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final CommentService _commentService = CommentService();
  final TextEditingController bottomController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void sendMessage() {
    final text = bottomController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _commentService.setComment(
        CommentModel(
          id: DateTime.now().microsecondsSinceEpoch,
          objectId: widget.objectId,
          creatorId: widget.currentUserId,
          about: text,
          date: DateTime.now().toIso8601String(),
        ),
      );
      bottomController.clear();
    });

    Future.delayed(const Duration(milliseconds: 50), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 3,
                    width: 40,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _commentService.getObjectComments(widget.objectId),
                builder: (context, snapshot) {
                  return snapshot.data?.isNotEmpty ?? false
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CommentCard(
                                comment: CommentModel(
                                  id: snapshot.data![index].id,
                                  objectId: snapshot.data![index].objectId,
                                  creatorId: snapshot.data![index].creatorId,
                                  about: snapshot.data![index].about,
                                  date: snapshot.data![index].date,
                                ),
                                currentUserId:
                                    CacheService.instance.getInt(
                                      AppKey.userInSystem,
                                    ) ??
                                    0,
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "Комментарии отсутствуют",
                            style: TextStyle(),
                          ),
                        );
                },
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColor.grey, width: 1.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      Expanded(
                        child: CastleTextField(
                          controller: bottomController,
                          hintText: "Напишите комментарий",
                          icon: null,
                          lookBorder: true,
                          border: Border.all(color: Colors.transparent),
                          padding: const EdgeInsets.all(0),
                          searchNewObj: () => sendMessage.call(),
                        ),
                      ),
                      IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(
                          Icons.send_rounded,
                          color: AppColor.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
