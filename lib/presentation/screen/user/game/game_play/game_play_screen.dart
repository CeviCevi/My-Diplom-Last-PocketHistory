import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';
import 'package:history/presentation/widget/app/toast/empty_toast.dart';
import 'package:history/presentation/widget/app/toast/error_toast.dart';

class GamePlayScreen extends StatefulWidget {
  final ObjectModel model;

  const GamePlayScreen({super.key, required this.model});

  @override
  State<GamePlayScreen> createState() => _GamePlayScreenState();
}

class _GamePlayScreenState extends State<GamePlayScreen> {
  bool _isLoading = false;

  // Метод проверки геолокации
  Future<void> _checkLocation() async {
    setState(() => _isLoading = true);

    try {
      // 1. Проверка разрешений
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // 2. Получение текущей позиции
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Расчет расстояния в метрах
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.model.oX, // Координаты из модели
        widget.model.oY,
      );

      // 4. Проверка (погрешность 100 метров)
      if (distanceInMeters <= 100) {
        _showVictoryDialog(distanceInMeters.toInt());
      } else {
        _showErrorSnackBar(distanceInMeters.toInt());
      }
    } catch (e) {
      errorToast(context, message: "Ошибка доступа к GPS");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showVictoryDialog(int distance) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("ПОБЕДА!", textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
            const SizedBox(height: 10),
            Text("Вы на месте!", style: AppStyle.main),
            Text("Точность: $distance м", style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          Center(
            child: RedBorderButton(
              text: "УРА!",
              function: () {
                Navigator.pop(context); // Закрыть диалог
                Navigator.pop(context); // Вернуться в меню
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(int distance) {
    emptyToast(
      context,
      label: "Система",
      text: "Вы еще далеко! До цели примерно $distance метров",
      icon: Icons.location_city,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.red,
      body: Column(
        children: [
          // Шапка с названием места (1/3)
          Row(
            mainAxisAlignment: .spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  RouterService.back(context);
                  RouterService.back(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onDoubleTap: () => _showVictoryDialog(10),
                child: SizedBox(
                  height: size.height * 0.35,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.model.label,
                        textAlign: TextAlign.center,
                        style: AppStyle.main.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Найдите этот объект в реальности",
                        style: AppStyle.main.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: null,
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColor.red,
                ),
              ),
            ],
          ),

          // Контент
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Инструкция:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Доберитесь до точки на карте. Когда будете рядом, нажмите кнопку ниже, чтобы зафиксировать результат.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Spacer(),

                    if (_isLoading)
                      const CircularProgressIndicator(color: AppColor.red)
                    else
                      SizedBox(
                        width: double.infinity,
                        child: RedBorderButton(
                          text: "Я на месте",
                          function: _checkLocation,
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
}
