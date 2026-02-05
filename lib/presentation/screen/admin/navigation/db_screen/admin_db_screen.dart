import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/screen/admin/navigation/db_screen/widget/comment_db_screen.dart';
import 'package:history/presentation/screen/admin/navigation/db_screen/widget/object_db_screen.dart';
import 'package:history/presentation/screen/admin/navigation/db_screen/widget/user_data_screen.dart';

class AdminDbScreen extends StatefulWidget {
  const AdminDbScreen({super.key});

  @override
  State<AdminDbScreen> createState() => _AdminDbScreenState();
}

class _AdminDbScreenState extends State<AdminDbScreen> {
  final List<String> _categories = [
    'Пользователи',
    'Достопримечательности',
    'Комментарии',
  ];

  final List<Widget> screens = [
    UserDataScreen(),
    ObjectDbScreen(),
    CommentDbScreen(),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: .infinity,
            height: MediaQuery.of(context).size.height / 5,
            decoration: BoxDecoration(
              borderRadius: .vertical(bottom: Radius.circular(16)),
              color: AppColor.red,
              boxShadow: [BoxShadow(blurRadius: 5, color: Colors.blueGrey)],
            ),
            child: Column(
              children: [
                SizedBox(height: 60),
                const Text(
                  "Выбрать таблицу:",
                  style: TextStyle(fontSize: 16, color: AppColor.white),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _categories[selectedIndex],
                  hint: const Text(
                    "Выберите из списка",
                    style: TextStyle(color: AppColor.white),
                  ),
                  isExpanded: true,
                  iconSize: 0,
                  underline: Center(),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Center(
                        child: Container(
                          margin: .symmetric(horizontal: 20, vertical: 5),
                          width: .infinity,
                          decoration: BoxDecoration(
                            borderRadius: .circular(8),
                            color: AppColor.grey,
                          ),
                          child: Row(
                            mainAxisAlignment: .spaceBetween,
                            children: [
                              Icon(
                                Icons.arrow_forward_outlined,
                                color: AppColor.lightGrey,
                              ),
                              Center(
                                child: Text(
                                  category,
                                  style: TextStyle(color: AppColor.white),
                                ),
                              ),
                              Icon(
                                Icons.arrow_back_outlined,
                                color: AppColor.lightGrey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        selectedIndex = _categories.indexOf(newValue);
                      }
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(child: screens[selectedIndex]),
        ],
      ),
    );
  }
}
