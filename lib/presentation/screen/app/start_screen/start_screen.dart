import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';
import 'package:history/const/text/app_text.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          Center(
            child: Icon(Icons.castle_sharp, size: 30, color: AppColor.red),
          ),
          SizedBox(height: 10),
          Text(AppText.appName, style: AppStyle.main),
        ],
      ),
    );
  }
}
