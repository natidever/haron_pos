import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/custom_form_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              // Image Upload Section
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Center(
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
                        onPressed: () {
                          // Handle image upload
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          elevation: 0,
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: const Text('Browse Files'),
                      ),
                    ],
                  ),
                ),
              ),
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
                  final isBasicInfoValid =
                      _basicInfoFormKey.currentState?.validate() ?? false;
                  final isInventoryValid =
                      _inventoryFormKey.currentState?.validate() ?? false;

                  if (_isBasicInfo) {
                    if (isBasicInfoValid) {
                      // Handle basic info submission or switch to inventory
                      setState(() => _isBasicInfo = false);
                    }
                  } else {
                    if (isInventoryValid) {
                      // Handle final form submission
                      // Both forms are valid at this point
                      if (isBasicInfoValid && isInventoryValid) {
                        // Submit the complete form
                      }
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
                child: Text(
                  _isBasicInfo ? 'Next' : 'Create Product',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
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
