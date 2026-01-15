import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var textFieldShadow = BoxShadow(
  color: Colors.black.withAlpha((255 * 0.5).toInt()),
  blurRadius: 4,
  offset: const Offset(0, 2),
);

var textHintStyle = GoogleFonts.manrope(
  fontSize: 16,
  color: const Color(0xFF666666),
  fontWeight: FontWeight.w400,
);

var textFieldStyle = GoogleFonts.manrope(
  fontSize: 16,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
