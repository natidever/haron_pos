import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/constants/colors.dart';

Widget HeadingText(String text) {
  return Text(
    text,
    style: GoogleFonts.lexend(fontSize: 28, fontWeight: FontWeight.w500),
  );
}

Widget SubText(String text) {
  return Text(
    text,
    style: GoogleFonts.lexend(
        height: 2,
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: subTextColor),
  );
}

Widget NormalAppText(
    {String? text,
    double? fontSize,
    FontWeight? fontWeight,
    Color? textColor}) {
  return Text(
    text ?? "",
    style: GoogleFonts.lexend(
        fontSize: fontSize, fontWeight: fontWeight, color: textColor),
  );
}
