import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Product> products = [];

  void _updateQuantity(int index, bool increment) {
    setState(() {
      if (increment) {
        products[index].quantity++;
      } else if (products[index].quantity > 0) {
        products[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],
              onIncrement: () => _updateQuantity(index, true),
              onDecrement: () => _updateQuantity(index, false),
            );
          },
        ),
      ),
    );
  }
}
