import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/cart/cart_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haron_pos/bloc/prodct/products_bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:haron_pos/pages/products/products.dart';
import 'package:haron_pos/pages/main_screen.dart';
import 'package:haron_pos/navigation/bottom_nav_bar.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Chapa
  Chapa.configure(privateKey: "CHASECK_TEST-HlZh7Xo8vNvT2jm6j08OzcnFnB63Yauf");

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Product adapter
  Hive.registerAdapter(ProductAdapter());

  // Open the products box
  await Hive.openBox<Product>('products');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
      ],
      child: MaterialApp(
        title: 'Haron POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const BottomNavBar(),
      ),
    );
  }
}
