import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/user/game/game_play/game_play_screen.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/toast/success_toast.dart';

class PlayerStatus {
  final String name;
  bool isReady;
  final bool isHost;

  PlayerStatus({required this.name, this.isReady = false, this.isHost = false});
}

class JoinGameScreen extends StatefulWidget {
  final List<ObjectModel> availableObjects;

  const JoinGameScreen({super.key, required this.availableObjects});

  @override
  State<JoinGameScreen> createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  bool isMeReady = false;
  ObjectModel? selectedByBot;
  Timer? _startTimer;

  // Эмуляция списка участников
  List<PlayerStatus> players = [
    PlayerStatus(
      name: "Никита Грищук (Организатор)",
      isReady: true,
      isHost: true,
    ),
    PlayerStatus(name: "Вы", isReady: false),
  ];

  @override
  void initState() {
    super.initState();

    // 1. Эмуляция: через 2 секунды заходит еще один игрок
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          players.add(PlayerStatus(name: "Влад Кебец", isReady: true));
        });
      }
    });

    // 2. Эмуляция: Через 3 секунды бот выбирает место
    Timer(const Duration(seconds: 3), () {
      if (mounted && widget.availableObjects.isNotEmpty) {
        setState(() {
          selectedByBot =
              widget.availableObjects[Random().nextInt(
                widget.availableObjects.length,
              )];
        });
        _checkAndStartGame();
      }
    });
  }

  @override
  void dispose() {
    _startTimer?.cancel();
    super.dispose();
  }

  // Проверка условий для старта экрана соревнований
  void _checkAndStartGame() {
    if (isMeReady && selectedByBot != null) {
      _showSnackBar("Игра начнется через 3 секунды!");
      _startTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          RouterService.routeFade(
            context,
            GamePlayScreen(model: selectedByBot!),
          );
        }
      });
    }
  }

  void _toggleReady() {
    setState(() {
      isMeReady = !isMeReady;
      players[1].isReady = isMeReady; // Обновляем статус в списке участников
    });
    _checkAndStartGame();
  }

  void _showSnackBar(String message) {
    successToast(context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.red,
      body: Column(
        children: [
          SafeArea(
            child: Row(
              children: [
                IconButton(
                  onPressed: () => RouterService.back(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Комната ${DateTime.now().minute.hashCode}",
                  style: AppStyle.main.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Секция локации
                    _buildLocationCard(),

                    const SizedBox(height: 25),
                    Text(
                      "Участники",
                      style: AppStyle.main.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Список участников
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: players.length,
                        itemBuilder: (context, i) {
                          final p = players[i];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AppColor.lightGrey,
                              child: Icon(
                                Icons.person,
                                color: p.name == "Вы"
                                    ? AppColor.red
                                    : Colors.grey,
                              ),
                            ),
                            title: Text(p.name, style: AppStyle.main),
                            trailing: Icon(
                              p.isReady ? Icons.check_circle : Icons.cancel,
                              color: p.isReady ? Colors.green : Colors.red,
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(height: 40),

                    // Кнопка готовности
                    SizedBox(
                      width: double.infinity,
                      child: RedBorderButton(
                        text: isMeReady ? "Я НЕ ГОТОВ" : "Я ГОТОВ",
                        function: _toggleReady,
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

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppColor.lightGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.map_outlined, color: AppColor.red, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Выбранный объект:",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  selectedByBot?.label ?? "Ожидание выбора хоста...",
                  style: AppStyle.main.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          if (selectedByBot == null)
            const SizedBox(
              width: 15,
              height: 15,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.red,
              ),
            ),
        ],
      ),
    );
  }
}
