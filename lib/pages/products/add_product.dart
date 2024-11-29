import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/prodct/products_bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:image_picker/image_picker.dart';
import '../../widgets/custom_form_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:haron_pos/utils/logger.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  // Create separate form keys for each section
  final _basicInfoFormKey = GlobalKey<FormState>();
  final _inventoryFormKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _isBasicInfo = true;

  // Controllers for form fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _stockController = TextEditingController();
  final _supplierController = TextEditingController();
  final _discountController = TextEditingController();
  final _taxController = TextEditingController();

  // Add ImagePicker instance
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Add image picker function
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      // Handle any errors
      debugPrint('Error picking image: $e');
    }
  }

  // Show image picker modal
  void _showImagePickerModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Image Source',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ImagePickerButton(
                    icon: Icons.camera_alt,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _ImagePickerButton(
                    icon: Icons.photo_library,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Update the image container in the build method
  Widget _buildImageSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: _selectedImage != null
          ? Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 48,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upload Product Image',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _showImagePickerModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).primaryColor,
                      elevation: 0,
                      side: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    child: const Text('Choose Image'),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _stockController.dispose();
    _supplierController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon with Animation
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 600),
                  tween: Tween<double>(begin: 0, end: 1),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.green.shade400,
                          size: 72,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Success Message with Animation
                FadeTransition(
                  opacity: CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeIn,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Success!',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Product has been added successfully',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close dialog
                          Navigator.pop(context); // Go back to products page
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        child: Text(
                          'View Products',
                          style: GoogleFonts.poppins(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _resetForm();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add Another',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetForm() {
    setState(() {
      _selectedImage = null;
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _categoryController.clear();
      _skuController.clear();
      _barcodeController.clear();
      _stockController.clear();
      _supplierController.clear();
      _discountController.clear();
      _taxController.clear();
      _isBasicInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductsBloc, ProductsState>(
      listener: (context, state) {
        logger.i('State changed to: ${state.runtimeType}');
        if (state is ProductAdded) {
          logger.i('Product added successfully');
          _showSuccessDialog();
        } else if (state is ProductAddingError) {
          logger.e('Error adding product: ${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Error: ${state.error}',
                style: GoogleFonts.poppins(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            'Add New Product',
            style: GoogleFonts.poppins(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImageSection(),
                const SizedBox(height: 24),

                // Toggle Buttons for form sections
                Row(
                  children: [
                    Expanded(
                      child: _SectionButton(
                        title: 'Basic Info',
                        isSelected: _isBasicInfo,
                        onTap: () => setState(() => _isBasicInfo = true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _SectionButton(
                        title: 'Inventory',
                        isSelected: !_isBasicInfo,
                        onTap: () => setState(() => _isBasicInfo = false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form Sections
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isBasicInfo
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: _BasicInfoForm(
                    formKey: _basicInfoFormKey,
                    nameController: _nameController,
                    descriptionController: _descriptionController,
                    priceController: _priceController,
                    categoryController: _categoryController,
                    discountController: _discountController,
                    taxController: _taxController,
                  ),
                  secondChild: _InventoryForm(
                    formKey: _inventoryFormKey,
                    skuController: _skuController,
                    barcodeController: _barcodeController,
                    stockController: _stockController,
                    supplierController: _supplierController,
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    logger.i('Submit button pressed');
                    final isBasicInfoValid =
                        _basicInfoFormKey.currentState?.validate() ?? false;
                    final isInventoryValid =
                        _inventoryFormKey.currentState?.validate() ?? false;

                    if (_isBasicInfo) {
                      if (isBasicInfoValid) {
                        setState(() => _isBasicInfo = false);
                        logger.i('Moving to inventory section');
                      }
                    } else {
                      if (isBasicInfoValid && isInventoryValid) {
                        logger.i('Creating product object');
                        final product = Product(
                          name: _nameController.text,
                          image: _selectedImage?.path ??
                              'assets/images/products/place_holder.jpg',
                          category: _categoryController.text,
                          price: double.tryParse(_priceController.text) ?? 0,
                          description: _descriptionController.text,
                          quantityInStock:
                              int.tryParse(_stockController.text) ?? 0,
                          sku: _skuController.text,
                          barcode: _barcodeController.text,
                          supplier: _supplierController.text,
                          discount:
                              double.tryParse(_discountController.text) ?? 0,
                          taxRate: double.tryParse(_taxController.text) ?? 0,
                        );

                        logger.i(
                            'Creating product with image: ${_selectedImage?.path ?? "placeholder"}');
                        context
                            .read<ProductsBloc>()
                            .add(AddProductEvent(product));
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      if (state is ProductAdding) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      return Text(
                        _isBasicInfo ? 'Next' : 'Create Product',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SectionButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _BasicInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final TextEditingController categoryController;
  final TextEditingController discountController;
  final TextEditingController taxController;

  const _BasicInfoForm({
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.priceController,
    required this.categoryController,
    required this.discountController,
    required this.taxController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
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
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  label: 'Price',
                  placeholder: 'Enter price',
                  controller: priceController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Category',
                  placeholder: 'Select category',
                  controller: categoryController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  label: 'Discount (%)',
                  placeholder: '0',
                  controller: discountController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Tax Rate (%)',
                  placeholder: '0',
                  controller: taxController,
                  isNumber: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController skuController;
  final TextEditingController barcodeController;
  final TextEditingController stockController;
  final TextEditingController supplierController;

  const _InventoryForm({
    required this.formKey,
    required this.skuController,
    required this.barcodeController,
    required this.stockController,
    required this.supplierController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  label: 'SKU',
                  placeholder: 'Enter SKU',
                  controller: skuController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Barcode',
                  placeholder: 'Scan barcode',
                  controller: barcodeController,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: CustomFormField(
                  label: 'Stock Quantity',
                  placeholder: '0',
                  controller: stockController,
                  isNumber: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomFormField(
                  label: 'Supplier',
                  placeholder: 'Select supplier',
                  controller: supplierController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Add this new widget for the image picker buttons
class _ImagePickerButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ImagePickerButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Theme.of(context).primaryColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
