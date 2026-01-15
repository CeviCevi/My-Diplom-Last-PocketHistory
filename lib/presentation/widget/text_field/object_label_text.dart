import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_style.dart';

class ObjectLabelText extends StatelessWidget {
  final String label;
  final String address;

  const ObjectLabelText({
    super.key,
    required this.label,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, 2],
          colors: [
            Colors.black.withAlpha((255 * 1).toInt()),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppStyle.main.copyWith(
              fontWeight: .w600,
              fontSize: 20,
              color: AppColor.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            address,
            style: AppStyle.main.copyWith(
              fontSize: 15,
              color: AppColor.white.withAlpha(200),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
