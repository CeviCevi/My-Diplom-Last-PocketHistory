import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen/detail_object_screen.dart';
import 'package:history/presentation/screen/user/activity_screen/widget/my_object_item.dart';
import 'package:history/presentation/widget/app/button/two_positioned_button.dart';

class MyObjectScreen extends StatefulWidget {
  const MyObjectScreen({super.key});

  @override
  State<MyObjectScreen> createState() => _MyObjectScreenState();
}

class _MyObjectScreenState extends State<MyObjectScreen> {
  final ObjectService service = ObjectService();
  final int myId = CacheService.instance.getInt(AppKey.userInSystem) ?? 0;

  bool isLeft = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TwoPositionButton(
            leftLabel: "Доступные",
            rightLabel: "На проверке",
            onChanged: (value) => setState(() => isLeft = !isLeft),
          ),

          FutureBuilder(
            future: isLeft
                ? service.getMyObject(myId)
                : service.getMyOffer(myId),
            builder: (context, snapshot) {
              return snapshot.data?.isNotEmpty ?? false
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) =>
                            MiniObjectCard(
                              model: snapshot.data![index],
                              isRelease: isLeft,
                              onTap: () => RouterService.routeFade(
                                context,
                                DetailObjectScreen(
                                  isRelease: isLeft,
                                  model: snapshot.data![index],
                                  seeBackButton: true,
                                  lookComments: false,
                                  lookAr: true,
                                ),
                              ),
                            ),
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        children: [
                          Icon(Icons.map_rounded, color: AppColor.grey),
                          Center(
                            child: Text(
                              'Нет ${isLeft ? "проверенных" : "предложенных"} объектов',
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
