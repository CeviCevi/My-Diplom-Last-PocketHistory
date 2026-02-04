import 'package:flutter/cupertino.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/text/app_key.dart';
import 'package:history/data/service/cache_service/cache_service.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/user/navigation/navigation_screen/navigation_screen.dart';
import 'package:history/presentation/widget/app/button/red_border_button.dart';

class BaseAuth extends StatelessWidget {
  final GestureTapCallback? login;
  final GestureTapCallback? register;
  BaseAuth({super.key, this.login, this.register});

  final _chache = CacheService.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      mainAxisAlignment: .center,
      children: [
        SizedBox(height: 30),
        RedBorderButton(
          bgColor: AppColor.white,
          color: AppColor.red,
          function: login,
          text: "Войти",
        ),
        RedBorderButton(
          bgColor: AppColor.red,
          color: AppColor.white,
          enabledBorder: false,
          function: register,
          text: "Зарегистрировать",
        ),
        SizedBox(height: 15),
        CupertinoButton(
          padding: .all(0),
          onPressed: () async {
            await _chache.setBool(AppKey.userAuth, false);
            RouterService.routeCloseAll(context, NavigationScreen());
          },
          child: Text(
            "Продолжить без регистрации",
            style: TextStyle(color: AppColor.red, fontWeight: .w500),
          ),
        ),
        Spacer(),
      ],
    );
  }
}
