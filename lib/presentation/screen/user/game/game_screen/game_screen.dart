import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/fish/obj_fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/user/game/active_games/active_games.dart';
import 'package:history/presentation/screen/user/game/join_game/join_game_screen.dart';
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
                      onTap: () => _showJoinCodeDialog(context),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuButton(
                      icon: Icons.access_time_rounded,
                      label: "Проходящие игры",
                      onTap: () =>
                          RouterService.routeFade(context, ActiveGamesScreen()),
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

  void _showJoinCodeDialog(BuildContext context) {
    final TextEditingController codeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Введите код комнаты",
          style: AppStyle.main.copyWith(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Попросите код у организатора игры",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 5,
              ),
              decoration: InputDecoration(
                counterText: "",
                filled: true,
                fillColor: AppColor.lightGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                hintText: "1234",
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена", style: TextStyle(color: Colors.grey)),
          ),
          // Используем твой RedBorderButton или обычный ElevatedButton
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              if (codeController.text.length > 4) {
                Navigator.pop(context); // Закрываем диалог

                // Переходим в лобби
                RouterService.routeFade(
                  context,
                  JoinGameScreen(availableObjects: modelsList),
                );
              }
            },
            child: const Text("Войти", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
