import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/pages/products/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haron POS',
      debugShowCheckedModeBanner: false,
      home: const ProductsPage(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
