import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2) // Make sure this ID is unique
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String transactionId;

  @HiveField(3)
  final double amount;

  @HiveField(4)
  final String status;

  @HiveField(5)
  final List<String> items; // Store product IDs

  @HiveField(6)
  final String paymentMethod;

  TransactionModel({
    required this.id,
    required this.date,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.items,
    required this.paymentMethod,
  });
}
