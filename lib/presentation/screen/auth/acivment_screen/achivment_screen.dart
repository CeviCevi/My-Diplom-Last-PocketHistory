import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/cache_service/router_service.dart';

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
        title: Text(
          "Выберите точку",
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

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final a = achievements[index];
          return _achievementCard(a);
        },
      ),
    );
  }

  Widget _achievementCard(AchievementModel a) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: a.unlocked
            ? const LinearGradient(
                colors: [Color(0xFFfbc02d), Color(0xFFffa000)],
              )
            : LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade600],
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(a.icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              a.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              a.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withAlpha(220),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            if (!a.unlocked)
              const Icon(Icons.lock, color: Colors.white70, size: 18),
          ],
        ),
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
