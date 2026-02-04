import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/fish/db/db_fish.dart';
import 'package:history/const/fish/obj_fish.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/domain/model/achive_model/achive_model.dart';
import 'package:history/domain/model/marker_model/marker_info_model.dart';
import 'package:history/domain/model/object_model/object_model.dart';
import 'package:history/domain/model/user_model/user_model.dart';

enum DbTable { users, objects, markers, appAchievements }

class AdminDatabaseScreen extends StatefulWidget {
  const AdminDatabaseScreen({super.key});

  @override
  State<AdminDatabaseScreen> createState() => _AdminDatabaseScreenState();
}

class _AdminDatabaseScreenState extends State<AdminDatabaseScreen> {
  DbTable selectedTable = DbTable.users;

  // --- ЛОГИКА РЕДАКТИРОВАНИЯ ---

  void _editItem(dynamic item) {
    // Map для хранения контроллеров: Ключ (имя поля) -> Контроллер
    final Map<String, TextEditingController> controllers = {};

    // 1. Динамически определяем, какие поля нам нужны
    if (item is UserModel) {
      controllers['Имя'] = TextEditingController(text: item.name);
      controllers['Фамилия'] = TextEditingController(text: item.surname);
      controllers['Email'] = TextEditingController(text: item.email);
      controllers['Пароль'] = TextEditingController(text: item.password);
    } else if (item is ObjectModel) {
      controllers['Название'] = TextEditingController(text: item.label);
      controllers['Адрес'] = TextEditingController(text: item.address);
      controllers['Широта (oX)'] = TextEditingController(
        text: item.oX.toString(),
      );
      controllers['Долгота (oY)'] = TextEditingController(
        text: item.oY.toString(),
      );
      controllers['О проекте'] = TextEditingController(text: item.about);
      controllers['Тип'] = TextEditingController(text: item.typeName);
    } else if (item is MarkerModel) {
      controllers['Заголовок'] = TextEditingController(text: item.title);
      controllers['Описание'] = TextEditingController(text: item.description);
      controllers['X (%)'] = TextEditingController(
        text: item.xPercent.toString(),
      );
      controllers['Y (%)'] = TextEditingController(
        text: item.yPercent.toString(),
      );
    } else if (item is AchiveModel) {
      controllers['Заголовок'] = TextEditingController(text: item.title);
      controllers['Текст'] = TextEditingController(text: item.text);
      controllers['Имя иконки'] = TextEditingController(text: item.iconName);
    }

    // 2. Вызываем адаптивную форму
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Редактирование записи",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Генерируем TextField для каждого элемента карты
              ...controllers.entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TextField(
                        controller: entry.value,
                        maxLines:
                            entry.key == 'О проекте' || entry.key == 'Описание'
                            ? 3
                            : 1,
                        decoration: InputDecoration(
                          labelText: entry.key,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: AppColor.lightGrey.withOpacity(0.3),
                        ),
                      ),
                    ),
                  )
                  .toList(),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.red,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _saveChanges(item, controllers),
                  child: const Text(
                    "СОХРАНИТЬ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveChanges(dynamic item, Map<String, TextEditingController> ctrls) {
    setState(() {
      if (item is UserModel) {
        int i = userList.indexOf(item);
        userList[i] = item.copyWith(
          name: ctrls['Имя']!.text,
          surname: ctrls['Фамилия']!.text,
          email: ctrls['Email']!.text,
          password: ctrls['Пароль']!.text,
        );
      } else if (item is ObjectModel) {
        int i = modelsList.indexOf(item);
        modelsList[i] = item.copyWith(
          label: ctrls['Название']!.text,
          address: ctrls['Адрес']!.text,
          oX: double.tryParse(ctrls['Широта (oX)']!.text) ?? item.oX,
          oY: double.tryParse(ctrls['Долгота (oY)']!.text) ?? item.oY,
          about: ctrls['О проекте']!.text,
          typeName: ctrls['Тип']!.text,
        );
      }
      // Добавь логику для остальных моделей аналогично через copyWith или конструктор
    });
    Navigator.pop(context);
  }

  // --- ИНТЕРФЕЙС СПИСКА ---

  void _deleteItem(int index) {
    setState(() {
      if (selectedTable == DbTable.users) userList.removeAt(index);
      if (selectedTable == DbTable.objects) modelsList.removeAt(index);
      if (selectedTable == DbTable.markers) markerList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Табы выбора таблицы
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            children: DbTable.values
                .map(
                  (table) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selectedColor: AppColor.red.withOpacity(0.2),
                      label: Text(
                        _tableName(table),
                        style: GoogleFonts.manrope(fontSize: 12),
                      ),
                      selected: selectedTable == table,
                      onSelected: (v) => setState(() => selectedTable = table),
                    ),
                  ),
                )
                .toList(),
          ),
        ),

        // Список данных
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    switch (selectedTable) {
      case DbTable.users:
        return _buildList(
          userList,
          (i) => "${userList[i].name} ${userList[i].surname}",
          (i) => userList[i].email,
        );
      case DbTable.objects:
        return _buildList(
          modelsList,
          (i) => modelsList[i].label,
          (i) => modelsList[i].address,
        );
      case DbTable.markers:
        return _buildList(
          markerList,
          (i) => markerList[i].title,
          (i) => markerList[i].description,
        );
      default:
        return const Center(child: Text("Данные подгружаются..."));
    }
  }

  Widget _buildList(List list, String Function(int) t, String Function(int) s) {
    if (list.isEmpty) return const Center(child: Text("Пусто"));
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: list.length,
      itemBuilder: (context, i) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: ListTile(
          title: Text(
            t(i),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(s(i), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _editItem(list[i]),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColor.red),
                onPressed: () => _deleteItem(i),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _tableName(DbTable t) {
    switch (t) {
      case DbTable.users:
        return "Юзеры";
      case DbTable.objects:
        return "Объекты";
      case DbTable.markers:
        return "Маркеры";
      case DbTable.appAchievements:
        return "Ачивки";
      default:
        return t.toString().split('.').last;
    }
  }
}
