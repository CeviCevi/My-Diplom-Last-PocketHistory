import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';

class TikTakButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final GestureTapCallback? function;
  final EdgeInsetsGeometry padding;
  final Color color;
  final int? colorIndex;
  final bool? isActive;
  final bool isSmall;

  const TikTakButton({
    super.key,
    this.text = "no data",
    this.icon = Icons.coffee,
    this.function,
    this.padding = const .fromLTRB(10, 0, 15, 0),
    this.color = AppColor.red,
    this.colorIndex,
    this.isActive = false,
    this.isSmall = false,
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
    final newIsActive = isActive ?? false;
    return Material(
      borderRadius: .circular(17),
      color: AppColor.white,
      elevation: 2,
      child: InkWell(
        onTap: function,
        borderRadius: .circular(17),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: icon != null ? padding : const .symmetric(horizontal: 15),
          decoration: BoxDecoration(
            border: .all(
              color: newIsActive ? AppColor.red : Colors.transparent,
              width: 3,
            ),
            borderRadius: .circular(17),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                AnimatedScale(
                  scale: isSmall ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeInOut,
                  child: Icon(
                    icon,
                    size: 20,
                    color: colorIndex != null
                        ? pastelColors[colorIndex! % pastelColors.length]
                        : color,
                  ),
                ),
                SizedBox(width: 5),
              ],
              Center(
                child: AnimatedDefaultTextStyle(
                  style: TextStyle(
                    color: AppColor.grey,
                    fontWeight: .w500,
                    fontSize: isSmall ? 0.0 : 14.0,
                  ),
                  duration: Duration(milliseconds: 150),
                  child: Text(text, textAlign: .center),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
