import 'package:flutter/material.dart';
import 'package:haron_pos/pages/products/product_detail.dart';
import '../../models/product_model.dart';
import '../../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // Dummy data for demonstration
  final List<Product> products = [
    Product(
      name: 'Coffee Latte',
      image: 'assets/images/products/pr1.jpg',
      category: 'Drinks',
      price: 4.99,
    ),
    Product(
      name: 'Coffee Latte',
      image: 'assets/images/products/pr1.jpg',
      category: 'Drinks',
      price: 4.99,
    ),
    Product(
      name: 'Coffee Latte',
      image: 'assets/images/products/pr1.jpg',
      category: 'Drinks',
      price: 4.99,
    ),
    Product(
      name: 'Coffee Latte',
      image: 'assets/images/products/pr1.jpg',
      category: 'Drinks',
      price: 4.99,
    ),
    Product(
      name: 'Coffee Latte',
      image: 'assets/images/products/pr1.jpg',
      category: 'Drinks',
      price: 4.99,
    ),
    // Add more products here
  ];

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
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                          product: products[index],
                        )),
              ),
              child: ProductCard(
                product: products[index],
                onIncrement: () => _updateQuantity(index, true),
                onDecrement: () => _updateQuantity(index, false),
              ),
            );
          },
        ),
      ),
    );
  }
}
