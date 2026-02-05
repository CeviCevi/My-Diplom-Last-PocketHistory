import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/auth/auth_screen.dart';

class ArDbScree extends StatefulWidget {
  const ArDbScree({super.key});

  @override
  State<ArDbScree> createState() => _ArDbScreeState();
}

class _ArDbScreeState extends State<ArDbScree> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ArImageService().getImageList(),
      builder: (context, snapshot) {
        if (snapshot.data?.isNotEmpty ?? false) {
          return Column(
            children: [
              CupertinoButton(
                child: Text("click"),
                onPressed: () =>
                    RouterService.routeCloseAll(context, RegisterScreen()),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const .all(0),
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) => CupertinoButton(
                    onPressed: () {},
                    padding: const .all(0),
                    child: Container(
                      width: .infinity,
                      height: .300,
                      margin: .symmetric(horizontal: 20, vertical: 5),
                      //padding: .symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: .circular(8),
                        color: AppColor.grey,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: Offset(0, 2),
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Flexible(
                            child: Image.memory(
                              base64Decode(snapshot.data![index].image),
                            ),
                          ),

                          CupertinoButton(
                            onPressed: () async {
                              setState(() {
                                ArImageService().delete(snapshot.data![index]);
                              });
                            },
                            padding: .only(left: 0),
                            child: Container(
                              width: .infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColor.red,
                                borderRadius: .vertical(bottom: .circular(6)),
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
