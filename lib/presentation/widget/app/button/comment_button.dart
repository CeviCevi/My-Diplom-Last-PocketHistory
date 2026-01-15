import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:history/const/style/app_color.dart';

class CommentsButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color? backgroundColor;

  const CommentsButton({
    super.key,
    required this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon(Icons.arrow_forward_ios),
          Icon(Icons.arrow_forward),
          SizedBox(width: 25),
          CupertinoButton(
            onPressed: onPressed,
            padding: const .all(0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColor.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((255 * 0.1).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Посмотреть отзывы",
                    style: GoogleFonts.manrope(
                      color: AppColor.black,
                      fontSize: 18,
                      fontWeight: .bold,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 26),

          // Icon(Icons.arrow_back_ios),
          Icon(Icons.arrow_back),
        ],
      ),
    );
  }
}
