import 'package:flutter/material.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_path.dart';
import 'package:history/data/service/cache_service/router_service.dart';
import 'package:history/presentation/screen/app/object/create_object/create_object.dart';
import 'package:history/presentation/screen/user/cab_screen/widget/profile_button.dart';
import 'package:history/presentation/screen/user/cab_screen/widget/profile_image.dart';
import 'package:history/presentation/screen/user/cab_screen/widget/settings_block.dart';

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
          height: MediaQuery.of(context).size.height * 1.1,
          width: MediaQuery.of(context).size.width,
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
                    Text(
                      "Пупкина Залупкина",
                      style: AppStyle.main.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 5),
                    Text("zalypkina@gmail.com", style: AppStyle.main),
                    SizedBox(height: 25),
                    SettingsBlock(),
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
                        ),
                        ProfileButton(
                          text: "Мои достижения",
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
                        ),
                        ProfileButton(
                          text: "Удалить аккаунт",
                          icon: Icons.delete_forever_outlined,
                        ),
                      ],
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: MediaQuery.of(context).size.height * 0.3 - 70,
                child: ProfileImage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
