

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget NeuText(
    {required String text, required double fontSize, required Color color, double strokeWidth = 3, Offset offset = const Offset(3, 3)}) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Text(
        text,
        style: GoogleFonts.kavoon(
            shadows: [Shadow(offset: offset, color: Colors.black)],
            letterSpacing: 3,
            fontSize: fontSize.sp,
            color: color),
      ),
      Text(
        text,
        style: GoogleFonts.kavoon(
            letterSpacing: 3,
            fontSize: fontSize.sp,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth.sp),
      ),
    ],
  );
}