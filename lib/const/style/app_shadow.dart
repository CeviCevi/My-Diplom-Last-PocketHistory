import 'package:flutter/material.dart';

class AppShadow {
  static final boxMainShadow = BoxShadow(
    color: Colors.black.withAlpha((255 * 0.5).toInt()),
    blurRadius: 4,
    offset: Offset(0, 2),
  );
}
