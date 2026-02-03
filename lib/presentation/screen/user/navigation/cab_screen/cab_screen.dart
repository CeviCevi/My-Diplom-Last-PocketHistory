import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:history/const/security/user.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/presentation/screen/app/object/create_object/create_object.dart';
import 'package:history/presentation/screen/auth/auth_screen.dart';
import 'package:history/presentation/screen/user/acivment_screen/achivment_screen.dart';
import 'package:history/presentation/screen/user/activity_screen/activity_screen.dart';
import 'package:history/presentation/screen/user/edit_profile_screen/edit_profile_screen.dart';
import 'package:history/presentation/screen/user/navigation/cab_screen/widget/profile_button.dart';
import 'package:history/presentation/screen/user/navigation/cab_screen/widget/profile_image.dart';
import 'package:history/presentation/screen/user/navigation/cab_screen/widget/settings_block.dart';
import 'package:history/presentation/widget/app/toast/achive_toast.dart';

class CabScreen extends StatefulWidget {
  const CabScreen({super.key});

  @override
  State<CabScreen> createState() => _CabScreenState();
}

class _CabScreenState extends State<CabScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppPath.imageProfileBg),
                          fit: .cover,
                          opacity: .2,
                        ),
                        //color: Colors.red.withAlpha(80),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.elliptical(360, 45),
                        ),
                      ),
                    ),
                    SizedBox(height: 55),
                    GestureDetector(
                      onDoubleTap: () =>
                          achievementToast(context, message: "Исследователь"),
                      child: Text(
                        "${user.name} ${user.surname}",
                        style: AppStyle.main.copyWith(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(user.email, style: AppStyle.main),
                    SizedBox(height: 25),
                    SettingsBlock(
                      buttons: [
                        ProfileButton(
                          text: "Редактировать профиль",
                          icon: Icons.edit,
                          function: () => RouterService.routeFade(
                            context,
                            EditProfileScreen(fuction: () => setState(() {})),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SettingsBlock(
                      spacing: 1,
                      buttons: [
                        ProfileButton(
                          text: "Предложить объект",
                          icon: Icons.account_balance_rounded,
                          function: () =>
                              RouterService.routeFade(context, CreateObject()),
                        ),
                        ProfileButton(
                          text: "Моя активность",
                          icon: Icons.comment_rounded,
                          function: () => RouterService.routeFade(
                            context,
                            ActivityScreen(),
                          ),
                        ),
                        ProfileButton(
                          text: "Мои достижения",
                          function: () => RouterService.routeFade(
                            context,
                            AchievementsScreen(),
                          ),
                          icon: Icons.workspace_premium_rounded,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    SettingsBlock(
                      buttons: [
                        ProfileButton(
                          text: "Выйти из аккаунта",
                          icon: Icons.exit_to_app_rounded,
                          function: () {
                            CacheService.instance.clear();
                            RouterService.routeCloseAll(
                              context,
                              RegisterScreen(),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height * 0.3 - 70,
                child: ProfileImage(
                  image: user.image != null
                      ? DecorationImage(
                          image: MemoryImage(base64Decode(user.image!)),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
