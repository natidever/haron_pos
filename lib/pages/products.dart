import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Product> products = [
    Product(
      id: 'PR001',
      name: 'Cappuccino',
      description:
          'Italian coffee drink made with espresso and steamed milk foam',
      price: 4.99,
      quantityInStock: 100,
      sku: 'CAP-001',
      barcode: '890123456789',
      supplier: 'Premium Coffee Supplies',
      image: 'assets/images/products/pr1.jpg',
      discount: 0,
      taxRate: 10,
      category: 'Hot Drinks',
    ),
    Product(
      id: 'PR002',
      name: 'Iced Americano',
      description: 'Chilled espresso drink with cold water and ice cubes',
      price: 3.99,
      quantityInStock: 150,
      sku: 'ICE-AM-002',
      barcode: '890123456790',
      supplier: 'Premium Coffee Supplies',
      image: 'assets/images/products/pr1.jpg',
      discount: 5,
      taxRate: 10,
      category: 'Cold Drinks',
    ),
    Product(
      id: 'PR003',
      name: 'Chocolate Croissant',
      description: 'Buttery, flaky pastry filled with rich chocolate',
      price: 3.49,
      quantityInStock: 50,
      sku: 'PST-CR-003',
      barcode: '890123456791',
      supplier: 'Fresh Bakery Co.',
      image: 'assets/images/products/pr1.jpg',
      discount: 0,
      taxRate: 8,
      category: 'Pastries',
    ),
    Product(
      id: 'PR004',
      name: 'Green Tea Latte',
      description: 'Matcha green tea with steamed milk and honey',
      price: 4.49,
      quantityInStock: 80,
      sku: 'TEA-GT-004',
      barcode: '890123456792',
      supplier: 'Tea Masters Inc.',
      image: 'assets/images/products/pr1.jpg',
      discount: 0,
      taxRate: 10,
      category: 'Hot Drinks',
    ),
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
