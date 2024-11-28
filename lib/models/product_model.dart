import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class Product {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final double price;

  @HiveField(5)
  final String description;

  @HiveField(6)
  final int quantityInStock;

  @HiveField(7)
  final String sku;

  @HiveField(8)
  final String barcode;

  @HiveField(9)
  final String supplier;

  @HiveField(10)
  final double discount;

  @HiveField(11)
  final double taxRate;

  @HiveField(12)
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
