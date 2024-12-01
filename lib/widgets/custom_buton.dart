import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget PrimaryButton({Color? color, String? text, Color? textColor}) {
  return Container(
    width: 335,
    height: 56,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
        child: Text(
      text ?? '',
      style: GoogleFonts.lexend(
        textStyle: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w300,
        ),
      ),
    )),
  );
}
