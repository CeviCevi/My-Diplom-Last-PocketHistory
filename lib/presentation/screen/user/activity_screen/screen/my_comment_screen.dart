import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/presentation/screen/user/activity_screen/widget/my_comment_item.dart';

class MyCommentScreen extends StatefulWidget {
  const MyCommentScreen({super.key});

  @override
  State<MyCommentScreen> createState() => _MyCommentScreenState();
}

class _MyCommentScreenState extends State<MyCommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: CommentService().getUserComments(
              CacheService.instance.getInt(AppKey.userInSystem) ?? 0,
            ),
            builder: (context, snapshot) {
              return snapshot.data?.isNotEmpty ?? false
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) => MyCommentCard(
                          comment: snapshot.data![index],
                          removeComment: () => setState(() {}),
                        ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.comment, color: AppColor.grey),
                          Center(
                            child: Text(
                              'Вы не оставляли комментарии',
                              style: TextStyle(
                                fontWeight: .w500,
                                fontSize: 16,
                                color: AppColor.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
