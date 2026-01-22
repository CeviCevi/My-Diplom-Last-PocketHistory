import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/presentation/screen/user/navigation/cab_screen/cab_screen.dart';
import 'package:history/presentation/screen/user/navigation/favorite_screen/favorite_screen.dart';
import 'package:history/presentation/screen/user/navigation/map_screen/map_screen.dart';

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
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite_outline),
      activeIcon: Icon(Icons.favorite_rounded),
      label: 'Избранное',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.castle_outlined),
      activeIcon: Icon(Icons.castle_rounded),
      label: 'Поиск',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person_rounded),
      label: 'Профиль',
    ),
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
        backgroundColor: AppColor.white,
        elevation: 5,
        enableFeedback: true,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: .bold,
        ),

        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
