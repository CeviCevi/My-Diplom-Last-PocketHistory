import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/detail_object_screen/detail_object_screen.dart';
import 'package:history/presentation/screen/app/object/edit_object/edit_object.dart';

class ObjScr extends StatefulWidget {
  const ObjScr({super.key});

  @override
  State<ObjScr> createState() => _ObjScrState();
}

class _ObjScrState extends State<ObjScr> {
  late Future<List<ObjectModel>> _futureObjects;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Метод для инициализации и обновления данных
  void _loadData() {
    setState(() {
      _futureObjects = ObjectService().getOffer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ObjectModel>>(
      future: _futureObjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Ошибка загрузки: ${snapshot.error}"));
        }

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return _buildObjectItem(item);
            },
          );
        }

        return const Center(
          child: Text(
            "Объекты на модерации отсутствуют",
            style: TextStyle(color: Colors.grey),
          ),
        );
      },
    );
  }

  Widget _buildObjectItem(ObjectModel item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: GestureDetector(
        onTap: () => RouterService.routeFade(
          context,
          DetailObjectScreen(
            model: item,
            seeBackButton: true,
            isRelease: false,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Изображение
              _buildImage(item.imageBit),

              const SizedBox(width: 12),

              // 2. Инфо блок
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.typeName,
                      style: TextStyle(
                        color: Colors.blueGrey[700],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.address,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Колонки действий
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Кнопка ПРИНЯТЬ
                  _actionButton(
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                    onPressed: () async {
                      await ObjectService().addOfferToModels(item);
                      await ObjectService().deleteOffer(item);
                      _loadData(); // Обновляем список
                    },
                  ),
                  // Кнопка РЕДАКТИРОВАТЬ
                  _actionButton(
                    icon: Icons.edit_note_rounded,
                    color: Colors.orange,
                    onPressed: () {
                      var a = arImageList
                          .where((e) => e.objectId == item.id)
                          .toList();

                      RouterService.routeFade(
                        context,
                        EditObjectScreen(
                          initialObject: item,
                          initialArImage: a.isNotEmpty
                              ? a.first
                              : ArImageModel(
                                  id: 0,
                                  objectId: 0,
                                  image: AppPath.imageBg,
                                ),
                          initialMarkers: markerList
                              .where((element) => element.objectId == item.id)
                              .toList(),
                        ),
                      );
                    },
                  ),
                  // Кнопка УДАЛИТЬ
                  _actionButton(
                    icon: Icons.delete_outline_rounded,
                    color: Colors.red,
                    onPressed: () async {
                      await ObjectService().deleteOffer(item);
                      _loadData(); // Обновляем список
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для картинок
  Widget _buildImage(String? imageBit) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: imageBit != null && imageBit.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.memory(base64Decode(imageBit), fit: BoxFit.cover),
            )
          : const Icon(Icons.museum_outlined, color: Colors.grey),
    );
  }

  // Вспомогательный виджет для кнопок действий
  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 36,
      width: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(icon, color: color, size: 22),
        onPressed: onPressed,
      ),
    );
  }
}
