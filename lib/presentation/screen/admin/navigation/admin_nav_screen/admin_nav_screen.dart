import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/screen/admin/navigation/db_screen/admin_db_screen.dart';
import 'package:history/presentation/screen/admin/navigation/moder_screen/moder_screen.dart';

class AdminNavigationScreen extends StatefulWidget {
  const AdminNavigationScreen({super.key});

  @override
  State<AdminNavigationScreen> createState() => _AdminNavigationScreenState();
}

class _AdminNavigationScreenState extends State<AdminNavigationScreen> {
  int _currentIndex = 0;

  // Список экранов для админа
  final List<Widget> _screens = [AdminDbScreen(), ModerScreen()];

  // Элементы навигации
  final List<BottomNavigationBarItem> barItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.storage_outlined),
      activeIcon: Icon(Icons.storage_rounded),
      label: 'Базы данных',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.fact_check_outlined),
      activeIcon: Icon(Icons.fact_check_rounded),
      label: 'Модерация',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // Используем IndexedStack для сохранения состояния вкладок
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: barItems,
        selectedItemColor: AppColor.red, // Твой фирменный красный
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 28),
        backgroundColor: Colors.white,
        elevation: 10,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
