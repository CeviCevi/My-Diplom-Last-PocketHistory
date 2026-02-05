import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/data/service/data%20services/achive_service/achive_service.dart';
import 'package:history/data/service/data%20services/ar_image_service/ar_image_service.dart';
import 'package:history/data/service/data%20services/comment_service.dart/comment_service.dart';
import 'package:history/data/service/data%20services/marker_service/marker_service.dart';
import 'package:history/data/service/data%20services/object_service/object_service.dart';
import 'package:history/data/service/data%20services/user_service/user_service.dart';
import 'package:history/presentation/screen/auth/widget/base_auth.dart';
import 'package:history/presentation/screen/auth/widget/login.dart';
import 'package:history/presentation/screen/auth/widget/reg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double del = 2.3;
  int _currentIndex = 0;

  // Добавлены ValueKey для каждого виджета, чтобы AnimatedSwitcher понимал, когда менять состояние
  late List<Widget> widgetsList = [
    BaseAuth(
      key: const ValueKey(0),
      login: () {
        setState(() {
          del = 1.2;
          _currentIndex = 1;
        });
      },
      register: () {
        setState(() {
          del = 1.2;
          _currentIndex = 2;
        });
      },
    ),
    LoginScreen(
      key: const ValueKey(1),
      onBack: () {
        setState(() {
          del = 2.3;
          _currentIndex = 0;
        });
      },
    ),
    RegistrationScreen(
      key: const ValueKey(2),
      onBack: () {
        setState(() {
          del = 2.3;
          _currentIndex = 0;
        });
      },
    ),
  ];

  Future<void> getAsunc() async {
    UserService().initUsers();
    ObjectService().initDatabase();
    MarkerService().initMarkers();
    CommentService().initComments();
    ArImageService().initArImages();
    AchiveService().initAchievements();
  }

  @override
  void initState() {
    getAsunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Фон
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: AppColor.black,
              image: DecorationImage(
                image: AssetImage(AppPath.imageBg),
                fit: BoxFit.cover,
                opacity: 0.7,
              ),
            ),
          ),

          // Блюр
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        opacity: _currentIndex == 0 ? 1.0 : 0.0,
                        child: const Icon(
                          Icons.map_outlined,
                          size: 50,
                          color: AppColor.white,
                        ),
                      ),
                      Text(
                        "ИСТОРИЯ В КАРМАНЕ",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.manrope(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Контейнер с формой
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInSine,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / del,
                decoration: const BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.elliptical(100, 40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  // AnimatedSwitcher обеспечивает анимацию фейда при смене дочернего виджета
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: widgetsList[_currentIndex],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
