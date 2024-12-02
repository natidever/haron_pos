import 'package:flutter/material.dart';
import 'package:haron_pos/bloc/theme/theme_bloc.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:haron_pos/pages/products/add_product.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/pages/payments/checkout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class ProductDetail extends StatefulWidget {
  final Product product;

  const ProductDetail({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController skuController;
  late TextEditingController barcodeController;
  late TextEditingController supplierController;
  late TextEditingController stockController;
  late TextEditingController discountController;
  late TextEditingController taxController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with product data
    nameController = TextEditingController(text: widget.product.name);
    descriptionController =
        TextEditingController(text: widget.product.description);
    priceController =
        TextEditingController(text: widget.product.price.toString());
    skuController = TextEditingController(text: widget.product.sku);
    barcodeController = TextEditingController(text: widget.product.barcode);
    supplierController = TextEditingController(text: widget.product.supplier);
    stockController =
        TextEditingController(text: widget.product.quantityInStock.toString());
    discountController =
        TextEditingController(text: widget.product.discount.toString());
    taxController =
        TextEditingController(text: widget.product.taxRate.toString());
    categoryController = TextEditingController(text: widget.product.category);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    skuController.dispose();
    barcodeController.dispose();
    supplierController.dispose();
    stockController.dispose();
    discountController.dispose();
    taxController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Product Details',
              style: GoogleFonts.poppins(
                color: theme.colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black87),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primaryColor,
                            theme.primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primaryColor.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.shopping_cart_checkout,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '\$${widget.product.totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product Image
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.cardColor,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.product.image.startsWith('assets/')
                            ? Image.asset(
                                widget.product.image,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(widget.product.image),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: theme.cardColor,
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 50,
                                        color: theme.colorScheme.onBackground
                                            .withOpacity(0.5),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Fields
                    CustomFormField(
                      label: 'Product Name',
                      placeholder: 'Enter product name',
                      controller: nameController,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Please enter a name' : null,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Description',
                      placeholder: 'Enter product description',
                      controller: descriptionController,
                      maxLines: 3,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Price (\$)',
                      placeholder: 'Enter price',
                      controller: priceController,
                      isNumber: true,
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter a price'
                          : null,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'SKU',
                      placeholder: 'Enter SKU',
                      controller: skuController,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Barcode',
                      placeholder: 'Enter barcode',
                      controller: barcodeController,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Supplier',
                      placeholder: 'Enter supplier name',
                      controller: supplierController,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Stock Quantity',
                      placeholder: 'Enter stock quantity',
                      controller: stockController,
                      isNumber: true,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Discount (%)',
                      placeholder: 'Enter discount percentage',
                      controller: discountController,
                      isNumber: true,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Tax Rate (%)',
                      placeholder: 'Enter tax rate',
                      controller: taxController,
                      isNumber: true,
                      theme: theme,
                    ),
                    CustomFormField(
                      label: 'Category',
                      placeholder: 'Enter category',
                      controller: categoryController,
                      theme: theme,
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: Text(
                              'Checkout',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: theme.primaryColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: GoogleFonts.poppins(
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductPage(),
                ),
              );
            },
            backgroundColor: theme.primaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
