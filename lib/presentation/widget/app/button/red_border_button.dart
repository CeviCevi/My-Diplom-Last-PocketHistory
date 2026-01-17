import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';

class RedBorderButton extends StatelessWidget {
  final GestureTapCallback? function;
  final String text;
  const RedBorderButton({super.key, this.function, this.text = "Сохранить"});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      borderRadius: .circular(8),
      child: InkWell(
        borderRadius: .circular(8),
        onTap: function,
        child: Container(
          padding: const .all(20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: .circular(8),
            border: .all(color: AppColor.red, width: 2),
          ),
          child: Center(
            child: Text(
              "Сохранить",
              style: AppStyle.main.copyWith(
                color: AppColor.red,
                fontWeight: .bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
