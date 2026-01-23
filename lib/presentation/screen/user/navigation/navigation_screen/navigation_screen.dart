import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/security/user.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/presentation/screen/user/navigation/cab_screen/cab_screen.dart';
import 'package:history/presentation/screen/user/navigation/create_account_screen/create_account_screen.dart';
import 'package:history/presentation/screen/user/navigation/favorite_screen/favorite_screen.dart';
import 'package:history/presentation/screen/user/navigation/map_screen/map_screen.dart';
import 'package:history/presentation/widget/app/toast/no_reg_toast.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 1;
  bool userAuth = false;

  final List<Widget> _screens = [const FavoriteScreen(), const MapScreen()];

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
  void initState() {
    getFutureData();
    super.initState();

    userAuth = CacheService.instance.getBool(AppKey.userAuth) ?? false;
    _screens.add(userAuth ? const CabScreen() : CreateAccountScreen());
  }

  Future<void> getFutureData() async {
    var data = await UserService().getUserById(
      CacheService.instance.getInt(AppKey.userInSystem) ?? 0,
    );

    if (data != null) user = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (userAuth || index != 0) {
            setState(() {
              _currentIndex = index;
            });
          } else {
            notRegisteredToast(context);
          }
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
