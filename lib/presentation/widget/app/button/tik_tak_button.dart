import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';

class TikTakButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final GestureTapCallback? function;
  final EdgeInsetsGeometry padding;
  final Color color;
  final int? colorIndex;

  const TikTakButton({
    super.key,
    this.text = "no data",
    this.icon = Icons.coffee,
    this.function,
    this.padding = const .fromLTRB(10, 0, 15, 0),
    this.color = AppColor.red,
    this.colorIndex,
  });

  static List<Color> pastelColors = [
    Color(0xFFFF0066),
    Color(0xFF00CCFF),
    Color(0xFFFFCC00),
    Color(0xFF00FF66),
    Color(0xFF9900FF),
    Color(0xFFFF6600),
    Color(0xFF0066FF),
    Color(0xFFFFFF00),
    Color(0xFFCC00FF),
    Color(0xFF00FF00),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: .circular(17),
      color: AppColor.white,
      elevation: 2,
      child: InkWell(
        onTap: function,
        borderRadius: .circular(17),
        child: Container(
          height: 10,
          padding: padding,
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 20,
                  color: colorIndex != null
                      ? pastelColors[colorIndex! % pastelColors.length]
                      : color,
                ),
                SizedBox(width: 5),
              ],
              Center(
                child: Text(
                  text,
                  textAlign: .center,
                  style: TextStyle(color: AppColor.grey, fontWeight: .w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
