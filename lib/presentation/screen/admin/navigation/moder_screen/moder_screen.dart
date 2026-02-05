import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/data/service/router_service/router_service.dart';
import 'package:history/presentation/screen/admin/navigation/moder_screen/widget/comment_scr.dart';
import 'package:history/presentation/screen/admin/navigation/moder_screen/widget/obj_scr.dart';
import 'package:history/presentation/screen/auth/auth_screen.dart';
import 'package:history/presentation/widget/app/button/two_positioned_button.dart';

class ModerScreen extends StatefulWidget {
  const ModerScreen({super.key});

  @override
  State<ModerScreen> createState() => _ModerScreenState();
}

class _ModerScreenState extends State<ModerScreen> {
  bool isLeft = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 30),
          CupertinoButton(
            padding: .all(0),
            onPressed: () =>
                RouterService.routeCloseAll(context, RegisterScreen()),
            child: Text(
              "Покинуть меню администратора",
              style: TextStyle(color: AppColor.red),
            ),
          ),
          SizedBox(height: 30),
          TwoPositionButton(
            leftLabel: "Комментарии",
            rightLabel: "Объекты ",
            onChanged: (value) => setState(() => isLeft = !isLeft),
          ),
          SizedBox(height: 20),
          Expanded(child: isLeft ? CommentScr() : ObjScr()),
        ],
      ),
    );
  }
}
