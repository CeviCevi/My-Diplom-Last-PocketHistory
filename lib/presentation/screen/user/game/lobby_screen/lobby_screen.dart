import 'dart:math';

import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';

// Временная модель для участника
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
  // Список участников со статусами
  final List<PlayerStatus> players = [
    PlayerStatus(name: "Вы (Организатор)", isReady: true, isHost: true),
    PlayerStatus(name: "Алексей", isReady: true),
    PlayerStatus(name: "Мария", isReady: false),
    PlayerStatus(name: "Дмитрий", isReady: true),
  ];

  ObjectModel? selectedObject;

  void _selectRandomObject() {
    if (widget.availableObjects.isNotEmpty) {
      final random = Random();
      setState(() {
        selectedObject = widget
            .availableObjects[random.nextInt(widget.availableObjects.length)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.red,
      body: Column(
        children: [
          // Верхняя часть (1/3)
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              IconButton(
                onPressed: () => RouterService.back(context),
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColor.white,
                ),
              ),
              Container(
                height: size.height * 0.25,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Лобби",
                      style: AppStyle.main.copyWith(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Код комнаты: 5829",
                      style: AppStyle.main.copyWith(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColor.red,
                ),
              ),
            ],
          ),

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

                  // Список игроков с галочками/крестиками
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
                          onChanged: (val) =>
                              setState(() => selectedObject = val),
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

                  // Кнопка Старт (проверяет и выбор объекта, и готовность всех)
                  SizedBox(
                    width: double.infinity,
                    child: RedBorderButton(
                      text: "НАЧАТЬ",
                      function: (selectedObject != null)
                          ? () {
                              // Проверка: все ли готовы (кроме хоста)
                              bool allReady = players.every((p) => p.isReady);
                              if (allReady) {
                                print("Запуск игры!");
                              } else {
                                // Можно вывести тост "Не все игроки готовы"
                              }
                            }
                          : null,
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
