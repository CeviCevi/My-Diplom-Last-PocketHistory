import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/achive_service/achive_service.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/presentation/screen/user/acivment_screen/widget/acive_card.dart';

class AchievementsScreen extends StatelessWidget {
  AchievementsScreen({super.key});

  final List<AchievementModel> achievements = [
    AchievementModel(
      title: "Первый объект",
      description: "Вы добавили первый объект",
      icon: Icons.add_location_alt,
      unlocked: true,
    ),
    AchievementModel(
      title: "Исследователь",
      description: "Вы посетили 10 объектов",
      icon: Icons.explore,
      unlocked: true,
    ),
    AchievementModel(
      title: "Коллекционер",
      description: "Добавлено 50 объектов",
      icon: Icons.collections,
      unlocked: false,
    ),
    AchievementModel(
      title: "Путешественник",
      description: "Построен маршрут",
      icon: Icons.route,
      unlocked: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Достижения",
          style: AppStyle.main.copyWith(fontWeight: .bold, fontSize: 20),
        ),
        leading: IconButton(
          onPressed: () => RouterService.back(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        backgroundColor: AppColor.lightGrey,
        surfaceTintColor: AppColor.lightGrey,
        animateColor: false,
        shadowColor: AppColor.grey,
        elevation: 1,
      ),

      body: FutureBuilder(
        future: AchiveService().getUserAchiveListByUserId(
          CacheService.instance.getInt(AppKey.userInSystem) ?? 0,
        ),
        builder: (context, snapshot) {
          return snapshot.data?.isNotEmpty ?? false
              ? GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final a = snapshot.data![index];
                    return AciveCard(model: a);
                  },
                )
              : Column(
                  mainAxisAlignment: .center,
                  children: [Center(child: Text("data"))],
                );
        },
      ),
    );
  }
}

class AchievementModel {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;

  AchievementModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
  });
}
