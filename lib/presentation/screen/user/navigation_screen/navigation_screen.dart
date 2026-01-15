import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/screen/user/cab_screen/cab_screen.dart';
import 'package:history/presentation/screen/user/favorite_screen/favorite_screen.dart';
import 'package:history/presentation/screen/user/map_screen/map_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = [
    const FavoriteScreen(),
    const MapScreen(),
    const CabScreen(),
  ];

  final List<BottomNavigationBarItem> barItems = [
    BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Избранное'),
    BottomNavigationBarItem(icon: Icon(Icons.castle_rounded), label: 'Поиск'),
    BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Профиль'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: barItems,
        selectedItemColor: AppColor.red,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(size: 30),
        selectedLabelStyle: GoogleFonts.manrope(fontSize: 12),
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
