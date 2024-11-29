import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/bloc/cart/cart_bloc.dart';
import 'package:haron_pos/bloc/prodct/products_bloc.dart';
import 'package:haron_pos/models/cart_item.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:haron_pos/pages/payments/checkout.dart';
import 'package:haron_pos/pages/products/add_product.dart';
import 'package:haron_pos/widgets/product_card.dart';
import 'package:haron_pos/widgets/product_shimmer.dart';
import 'package:logger/logger.dart';

import 'package:google_fonts/google_fonts.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

var logger = Logger();

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    super.initState();
    logger.i('Initializing ProductsPage');
    context.read<ProductsBloc>().add(LoadProductsEvent());
  }

  void _updateQuantity(Product product, bool increment) {
    logger.i('Attempting to update quantity for product: ${product.name}');

    setState(() {
      if (increment) {
        product.quantity++;
        context.read<CartBloc>().add(AddToCartEvent(product, 1));
        logger
            .i('Increased quantity for ${product.name} to ${product.quantity}');
        _showSnackBar(context, product, true);
      } else if (product.quantity > 0) {
        product.quantity--;
        context.read<CartBloc>().add(UpdateQuantityEvent(
              product,
              product.quantity,
            ));
        logger
            .i('Decreased quantity for ${product.name} to ${product.quantity}');
        _showSnackBar(context, product, false);
      }
    });
  }

  void _showSnackBar(BuildContext context, Product product, bool isAdded) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isAdded ? Icons.add_shopping_cart : Icons.remove_shopping_cart,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Text(
              isAdded
                  ? '${product.name} added to cart'
                  : '${product.name} removed from cart',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: isAdded ? Colors.green.shade800 : Colors.red.shade800,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'VIEW CART',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CheckoutPage(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Building ProductsPage');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // Show confirmation dialog before deleting
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    'Clear All Products',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  content: Text(
                    'Are you sure you want to delete all products? This action cannot be undone.',
                    style: GoogleFonts.poppins(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductsBloc>().add(ClearProductsEvent());
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        'Delete All',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_sweep),
            color: Colors.red,
            tooltip: 'Clear All Products',
          ),
        ],
      ),
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          logger.d('Cart state updated: ${state.items.length} items');
        },
        child: BlocBuilder<ProductsBloc, ProductsState>(
          builder: (context, state) {
            logger.d('ProductsBloc state: ${state.runtimeType}');

            if (state is ProductLoading) {
              logger.i('Loading products...');
              return const Center(child: ProductShimmer());
            }

            if (state is ProductError) {
              logger.e('Error loading products: ${state.error}');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading products',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductsBloc>().add(LoadProductsEvent());
                      },
                      child: Text(
                        'Retry',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is ProductLoaded) {
              final products = state.products;
              logger.i(
                  'Products loaded successfully: ${products.length} products');

              if (products.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Empty state illustration
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 88,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Main message
                        Text(
                          'No Products Yet',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Supportive text
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            'Start adding products to your inventory to get started with sales',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Add Product Button with animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 0.8, end: 1.0),
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddProductPage(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline,
                                        color:
                                            Color.fromARGB(255, 215, 215, 215),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Add Your First Product',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  logger.d('Building ProductCard for: ${product.name}');
                  return ProductCard(
                    product: product,
                    onIncrement: () => _updateQuantity(product, true),
                    onDecrement: () => _updateQuantity(product, false),
                  );
                },
              );
            }

            logger.w('Unknown state encountered: ${state.runtimeType}');
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
