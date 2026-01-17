import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';

class MopdernIconButton extends StatelessWidget {
  final GestureTapCallback? function;
  final String text;
  final IconData icon;
  const MopdernIconButton({
    super.key,
    this.function,
    this.text = "No Text",
    this.icon = Icons.shopping_basket_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.white,
      elevation: 2,
      borderRadius: .circular(8),
      child: InkWell(
        onTap: function,
        borderRadius: .circular(8),
        child: Container(
          padding: .symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(borderRadius: .circular(8)),
          child: Row(
            spacing: 10,
            children: [
              Icon(icon, color: AppColor.black),
              Text(text, style: AppStyle.main.copyWith(fontWeight: .bold)),
              Center(),
            ],
          ),
        ),
      ),
    );
  }
}
