import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/fish/obj_fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/user/game/lobby_screen/lobby_screen.dart';

class GameMenuScreen extends StatelessWidget {
  const GameMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.red, // Или твой основной фирменный цвет
      body: Column(
        children: [
          // 1/3 экрана для названия
          Container(
            height: size.height * 0.35,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text(
                  "Забег во\nвремени",
                  style: AppStyle.main.copyWith(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),

          // Белый контейнер с кнопками
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildMenuButton(
                      icon: Icons.add_rounded,
                      label: "Создать игру",
                      onTap: () => RouterService.routeFade(
                        context,
                        GameLobbyScreen(availableObjects: modelsList),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      icon: Icons.login_rounded,
                      label: "Присоединиться",
                      onTap: () {
                        // Логика входа
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      icon: Icons.access_time_rounded,
                      label: "Проходящие игры",
                      onTap: () {
                        // Список игр
                      },
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height / 5),
                    CupertinoButton(
                      onPressed: () => RouterService.back(context),
                      padding: const .all(0),
                      child: Text(
                        "В главное меню",
                        style: TextStyle(color: AppColor.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColor.white,
      elevation: 2,
      borderRadius: .circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.lightGrey, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColor.red, size: 28),
              const SizedBox(width: 16),
              Text(
                label,
                style: AppStyle.main.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              const Icon(Icons.chevron_right, color: AppColor.grey),
            ],
          ),
        ),
      ),
    );
  }
}
