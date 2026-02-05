import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/domain/model/ar_image_model/ar_image_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/presentation/screen/app/object/edit_object/edit_object.dart';

class ObjectDbScreen extends StatefulWidget {
  const ObjectDbScreen({super.key});

  @override
  State<ObjectDbScreen> createState() => _ObjectDbScreenState();
}

class _ObjectDbScreenState extends State<ObjectDbScreen> {
  // Выносим Future, чтобы список не дергался при обновлении
  late Future<List<ObjectModel>> _futureObjects;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _futureObjects = ObjectService().getObjects();
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

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return _buildItem(item);
            },
          );
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.house, size: 40, color: Colors.grey),
              Text(
                "Объекты отсутствуют",
                style: TextStyle(
                  color: AppColor.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(ObjectModel item) {
    return Container(
      width: double.infinity,
      height: 90, // Немного увеличил высоту для удобства
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),
          // Инфо блок
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: TextStyle(
                    color: AppColor.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item.address,
                  style: TextStyle(color: AppColor.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  "ID: ${item.id}",
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 11),
                ),
              ],
            ),
          ),

          // КНОПКА РЕДАКТИРОВАНИЯ
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              var a = arImageList.where((e) => e.objectId == item.id).toList();
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
            child: Container(
              width: 45,
              height: double.infinity,
              color: Colors.orange.withOpacity(0.1),
              child: const Icon(Icons.edit, color: Colors.orange, size: 20),
            ),
          ),

          // КНОПКА УДАЛЕНИЯ
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => _showDeleteDialog(context, item),
            child: Container(
              width: 45,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.red,
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(12),
                ),
              ),
              child: Icon(Icons.delete, color: AppColor.lightGrey, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  // Функция вызова окна подтверждения
  void _showDeleteDialog(BuildContext context, ObjectModel item) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text("Подтверждение"),
        content: Text(
          "Вы действительно хотите безвозвратно удалить объект «${item.label}»?",
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true, // Делает текст красным
            onPressed: () async {
              Navigator.pop(context); // Закрываем диалог
              await ObjectService().delete(item); // Удаляем
              _loadData(); // Обновляем список
            },
            child: const Text("Удалить"),
          ),
        ],
      ),
    );
  }
}
