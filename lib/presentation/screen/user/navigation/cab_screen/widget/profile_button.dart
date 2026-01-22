import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';

class ProfileButton extends StatelessWidget {
  final GestureTapCallback? function;
  final String text;
  final IconData icon;
  const ProfileButton({
    super.key,
    this.function,
    this.icon = Icons.color_lens,
    this.text = " Пусто",
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: function,
      padding: const .all(0),
      child: Row(
        spacing: 10,
        children: [
          Icon(icon, size: 25, color: AppColor.black),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: .ellipsis,
              softWrap: false,
              style: AppStyle.main.copyWith(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
