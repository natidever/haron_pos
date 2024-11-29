import 'package:flutter/material.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:haron_pos/pages/products/add_product.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_form_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/pages/payments/checkout.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            color: Colors.black87,
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
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColor.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
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
                    image: DecorationImage(
                      image: AssetImage(widget.product.image),
                      fit: BoxFit.cover,
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
                ),
                CustomFormField(
                  label: 'Description',
                  placeholder: 'Enter product description',
                  controller: descriptionController,
                  maxLines: 3,
                ),
                CustomFormField(
                  label: 'Price (\$)',
                  placeholder: 'Enter price',
                  controller: priceController,
                  isNumber: true,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter a price' : null,
                ),
                CustomFormField(
                  label: 'SKU',
                  placeholder: 'Enter SKU',
                  controller: skuController,
                ),
                CustomFormField(
                  label: 'Barcode',
                  placeholder: 'Enter barcode',
                  controller: barcodeController,
                ),
                CustomFormField(
                  label: 'Supplier',
                  placeholder: 'Enter supplier name',
                  controller: supplierController,
                ),
                CustomFormField(
                  label: 'Stock Quantity',
                  placeholder: 'Enter stock quantity',
                  controller: stockController,
                  isNumber: true,
                ),
                CustomFormField(
                  label: 'Discount (%)',
                  placeholder: 'Enter discount percentage',
                  controller: discountController,
                  isNumber: true,
                ),
                CustomFormField(
                  label: 'Tax Rate (%)',
                  placeholder: 'Enter tax rate',
                  controller: taxController,
                  isNumber: true,
                ),
                CustomFormField(
                  label: 'Category',
                  placeholder: 'Enter category',
                  controller: categoryController,
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
                          backgroundColor: Theme.of(context).primaryColor,
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
                            color: Theme.of(context).primaryColor,
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
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
