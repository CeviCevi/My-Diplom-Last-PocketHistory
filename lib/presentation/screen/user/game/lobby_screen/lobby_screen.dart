import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/user/game/game_play/game_play_screen.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';

// Модель для участника
class PlayerStatus {
  final String name;
  bool isReady;
  final bool isHost;

  PlayerStatus({required this.name, this.isReady = false, this.isHost = false});
}

class GameLobbyScreen extends StatefulWidget {
  final List<ObjectModel> availableObjects;

  const GameLobbyScreen({super.key, required this.availableObjects});

  @override
  State<GameLobbyScreen> createState() => _GameLobbyScreenState();
}

class _GameLobbyScreenState extends State<GameLobbyScreen> {
  // Изначально список содержит только вас
  late List<PlayerStatus> players;
  ObjectModel? selectedObject;
  Timer? _readyTimer;

  @override
  void initState() {
    super.initState();
    players = [
      PlayerStatus(name: "Вы (Организатор)", isReady: true, isHost: true),
    ];

    // Эмуляция 1: Через 3 секунды заходит новый участник
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          players.add(PlayerStatus(name: "Никита Грищук", isReady: false));
        });
      }
    });
  }

  @override
  void dispose() {
    _readyTimer?.cancel();
    super.dispose();
  }

  // Эмуляция 2: Через 3 секунды после выбора локации игрок становится готов
  void _startEmulateReady() {
    _readyTimer?.cancel();
    _readyTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && players.length > 1) {
        setState(() {
          // Находим первого, кто не хост и еще не готов
          for (var p in players) {
            if (!p.isHost && !p.isReady) {
              p.isReady = true;
              break;
            }
          }
        });
      }
    });
  }

  void _selectRandomObject() {
    if (widget.availableObjects.isNotEmpty) {
      final random = Random();
      setState(() {
        selectedObject = widget
            .availableObjects[random.nextInt(widget.availableObjects.length)];
      });
      _startEmulateReady();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.red,
      body: Column(
        children: [
          // Верхняя часть (Шапка)
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () => RouterService.back(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Лобби",
                      style: AppStyle.main.copyWith(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Код комнаты: ${(CacheService.instance.getInt(AppKey.userInSystem)).hashCode}",
                      style: AppStyle.main.copyWith(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Белый контейнер
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Участники (${players.length})"),
                  const SizedBox(height: 10),

                  // Список игроков
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: players.length,
                      itemBuilder: (context, i) {
                        final player = players[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColor.lightGrey,
                            child: Icon(Icons.person, color: AppColor.red),
                          ),
                          title: Text(player.name, style: AppStyle.main),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (player.isHost)
                                const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                ),
                              Icon(
                                player.isReady
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: player.isReady
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const Divider(height: 30),
                  _title("Локация забега"),
                  const SizedBox(height: 15),

                  // Селектор объекта + Рандом
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<ObjectModel>(
                          value: selectedObject,
                          isExpanded: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColor.lightGrey,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          hint: const Text("Выберите место"),
                          items: widget.availableObjects.map((obj) {
                            return DropdownMenuItem(
                              value: obj,
                              child: Text(
                                obj.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() => selectedObject = val);
                            _startEmulateReady();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton.filled(
                        onPressed: _selectRandomObject,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColor.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fixedSize: const Size(50, 50),
                        ),
                        icon: const Icon(
                          Icons.casino_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Кнопка Старт
                  SizedBox(
                    width: double.infinity,
                    child: RedBorderButton(
                      text: "НАЧАТЬ",
                      function:
                          (selectedObject != null &&
                              players.every((p) => p.isReady))
                          ? () {
                              debugPrint(
                                "Игра начинается на локации: ${selectedObject!.label}",
                              );
                              RouterService.routeFade(
                                context,
                                GamePlayScreen(model: selectedObject!),
                              );
                            }
                          : null, // Кнопка заблокирована, если не все готовы или объект не выбран
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _title(String text) => Text(
    text,
    style: AppStyle.main.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
  );
}
