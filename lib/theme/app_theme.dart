import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.grey[100],
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: primaryColor.withOpacity(0.8),
      surface: Colors.white,
      background: Colors.grey[100]!,
      error: Colors.red[400]!,
    ),
    cardColor: Colors.white,
    shadowColor: Colors.grey.withOpacity(0.1),
    dividerColor: Colors.grey[300],
    textTheme: GoogleFonts.poppinsTextTheme(),
  );

  static final darkTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: primaryColor.withOpacity(0.8),
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      error: Colors.red[400]!,
      onSurface: Colors.white.withOpacity(0.87),
      onBackground: Colors.white.withOpacity(0.87),
    ),
    cardColor: const Color(0xFF1E1E1E),
    shadowColor: Colors.black.withOpacity(0.2),
    dividerColor: Colors.white.withOpacity(0.12),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );
}
