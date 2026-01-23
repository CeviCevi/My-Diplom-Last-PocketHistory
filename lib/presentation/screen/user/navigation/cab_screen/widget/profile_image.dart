import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';

class ProfileImage extends StatelessWidget {
  final DecorationImage? image;
  final double diametr;
  const ProfileImage({super.key, this.diametr = 110, this.image});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: diametr,
        height: diametr,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: .all(color: AppColor.white, width: 3),
          color: Colors.grey[300],
          boxShadow: [AppShadow.boxMainShadow],
          image: image,
        ),
        child: Center(
          child: Text(
            "?",
            style: TextStyle(
              fontWeight: .bold,
              fontSize: 40,
              color: AppColor.grey,
            ),
          ),
        ),
      ),
    );
  }
}
