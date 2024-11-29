import 'package:haron_pos/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.finalPrice * quantity;
  double get totalTax => product.taxAmount * quantity;
  double get totalWithTax => product.totalPrice * quantity;
}
