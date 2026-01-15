import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';
import 'package:history/const/style/app_style.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => Padding(
                padding: .symmetric(horizontal: 20, vertical: 10),
                child: Material(
                  color: AppColor.white,
                  borderRadius: .circular(8),
                  elevation: 2,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: .circular(8),
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(borderRadius: .circular(8)),
                      child: Padding(
                        padding: const .all(5),
                        child: Row(
                          mainAxisAlignment: .start,
                          crossAxisAlignment: .center,
                          children: [
                            Container(
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: .circular(8),
                                //border: .all(),
                                boxShadow: [
                                  AppShadow.boxMainShadow.copyWith(
                                    offset: Offset(0, 0),
                                    blurRadius: 1,
                                  ),
                                ],
                                image: DecorationImage(
                                  fit: .cover,
                                  image: NetworkImage(
                                    "https://images.pexels.com/photos/13982312/pexels-photo-13982312.jpeg",
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                //SmainAxisAlignment: .spaceAround,
                                crossAxisAlignment: .start,
                                children: [
                                  SizedBox(height: 10),
                                  Text(
                                    "Какойто замок $index",
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                    softWrap: false,
                                    style: AppStyle.main.copyWith(
                                      fontWeight: .bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    "Какойто адрес",
                                    style: AppStyle.main.copyWith(
                                      letterSpacing: .5,
                                      fontSize: 12,
                                      color: AppColor.grey,
                                    ),
                                  ),
                                  Spacer(),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const .symmetric(
                                          horizontal: 10,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          border: .all(color: Colors.red),
                                          borderRadius: .circular(8),
                                        ),
                                        child: Row(
                                          spacing: 10,
                                          crossAxisAlignment: .center,
                                          children: [
                                            Icon(
                                              Icons.flag_outlined,
                                              size: 15,
                                              color: AppColor.red,
                                            ),
                                            Text(
                                              "Какойто тип",
                                              style: AppStyle.main.copyWith(
                                                fontWeight: .bold,
                                                fontSize: 12,
                                                color: AppColor.red,
                                              ),
                                              textAlign: .center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
