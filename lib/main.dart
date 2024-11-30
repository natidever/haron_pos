import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/cart/cart_bloc.dart';
import 'package:haron_pos/bloc/transactions/bloc/transaction_bloc_bloc.dart';
import 'package:haron_pos/models/transaction_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haron_pos/bloc/prodct/products_bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:haron_pos/pages/products/products.dart';
import 'package:haron_pos/pages/main_screen.dart';
import 'package:haron_pos/navigation/bottom_nav_bar.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
// import 'package:haron_pos/bloc/transaction/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize image cache
  PaintingBinding.instance.imageCache.maximumSize = 1000;
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      100 * 1024 * 1024; // 100 MB

  // Initialize Chapa with proper configuration

  Chapa.configure(privateKey: "CHASECK_TEST-NMHnfnAw81g9EWXYoSm6FrobP7rePyRd");
  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(TransactionModelAdapter());

  // Open boxes
  await Hive.openBox<Product>('products');
  await Hive.openBox<TransactionModel>('transactions');

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => TransactionBloc()),
      ],
      child: MaterialApp(
        title: 'Haron POS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          // textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        ),
        home: const BottomNavBar(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc()),
        BlocProvider(create: (context) => CartBloc()),
        BlocProvider(create: (context) => TransactionBloc()),
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
