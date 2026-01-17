import 'package:flutter/material.dart';
import 'package:history/const/style/app_color.dart';
import 'package:history/const/style/app_shadow.dart';

class ProfileImage extends StatelessWidget {
  final ImageProvider<Object> image;
  final double diametr;
  const ProfileImage({
    super.key,
    this.diametr = 110,
    this.image = const NetworkImage(
      "https://img.freepik.com/free-photo/beautiful-african-woman-face-portrait-close-up_53876-148041.jpg",
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: diametr,
        height: diametr,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360),
          border: .all(color: AppColor.white, width: 3),
          color: Colors.red,
          boxShadow: [AppShadow.boxMainShadow],
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
