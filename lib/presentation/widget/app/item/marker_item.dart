import 'package:flutter/material.dart';

class MarkerItem extends StatelessWidget {
  const MarkerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      decoration: BoxDecoration(
        borderRadius: .circular(360),
        color: Colors.red,
        border: .all(width: .5, color: Colors.black87),
      ),
    );
  }
}
