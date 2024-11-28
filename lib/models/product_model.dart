class Product {
  final String id;
  final String name;
  final String image;
  final String category;
  final double price;
  final String description;
  final int quantityInStock;
  final String sku;
  final String barcode;
  final String supplier;
  final double discount;
  final double taxRate;
  int quantity; // For cart quantity

  Product({
    this.id = '',
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    this.description = '',
    this.quantityInStock = 0,
    this.sku = '',
    this.barcode = '',
    this.supplier = '',
    this.discount = 0,
    this.taxRate = 0,
    this.quantity = 0,
  });

  // Calculate final price after discount
  double get finalPrice {
    return price - (price * discount / 100);
  }

  // Calculate tax amount
  double get taxAmount {
    return finalPrice * (taxRate / 100);
  }

  // Calculate total price including tax
  double get totalPrice {
    return finalPrice + taxAmount;
  }
}
