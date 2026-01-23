import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';

class RedBorderButton extends StatelessWidget {
  final GestureTapCallback? function;
  final String text;
  final Color bgColor;
  final Color color;
  final bool enabledBorder;
  const RedBorderButton({
    super.key,
    this.function,
    this.text = "Сохранить",
    this.bgColor = AppColor.white,
    this.color = AppColor.red,
    this.enabledBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: .circular(16),
      child: InkWell(
        borderRadius: .circular(16),
        onTap: function,
        child: Container(
          padding: const .all(20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: .circular(16),
            border: enabledBorder ? .all(color: color, width: 2) : null,
          ),
          child: Center(
            child: Text(
              text,
              style: AppStyle.main.copyWith(
                color: color,
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
