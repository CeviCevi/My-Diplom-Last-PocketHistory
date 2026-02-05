import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';

class CommentDbScreen extends StatefulWidget {
  const CommentDbScreen({super.key});

  @override
  State<CommentDbScreen> createState() => _CommentDbScreenState();
}

class _CommentDbScreenState extends State<CommentDbScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CommentService().getCommentList(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) => CupertinoButton(
                    onPressed: () {},
                    padding: const .all(0),
                    child: Container(
                      width: .infinity,
                      height: 80,
                      margin: .symmetric(horizontal: 20, vertical: 5),
                      //padding: .symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: .circular(8),
                        color: AppColor.white,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: Offset(0, 2),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: .spaceBetween,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                snapshot.data![index].about,
                                style: TextStyle(
                                  color: AppColor.grey,
                                  fontWeight: .w400,
                                ),
                              ),
                              Text(
                                "Создатель: ${snapshot.data![index].creatorId}}",
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: .w500,
                                ),
                              ),
                              Text(
                                "id: ${snapshot.data![index].id}",
                                textAlign: .right,
                                overflow: .ellipsis,
                                softWrap: false,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColor.black,
                                  fontWeight: .w500,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),

                          CupertinoButton(
                            onPressed: () async {
                              setState(() {
                                CommentService().delete(snapshot.data![index]);
                              });
                            },
                            padding: .only(left: 10),
                            child: Container(
                              width: 50,
                              height: .infinity,
                              decoration: BoxDecoration(
                                color: AppColor.red,
                                borderRadius: .horizontal(right: .circular(6)),
                              ),
                              child: Icon(
                                Icons.delete,
                                color: AppColor.lightGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (snapshot.data?.isEmpty ?? true) {
          return Center(
            child: Column(
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                Icon(Icons.comment),
                Text(
                  "Комментарии отсутствуют",
                  style: TextStyle(color: AppColor.grey, fontWeight: .w500),
                ),
              ],
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
