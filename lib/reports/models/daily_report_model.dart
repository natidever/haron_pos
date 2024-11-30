import 'package:haron_pos/models/transaction_model.dart';

class DailyReport {
  final DateTime date;
  final double totalSales;
  final int transactionCount;
  final Map<String, double> paymentMethodTotals;
  final List<TopSellingItem> topSellingItems;

  DailyReport({
    required this.date,
    required this.totalSales,
    required this.transactionCount,
    required this.paymentMethodTotals,
    required this.topSellingItems,
  });

  // Factory method to create report from transactions
  factory DailyReport.fromTransactions(List<TransactionModel> transactions) {
    final today = DateTime.now();
    final todayTransactions = transactions
        .where((t) =>
            t.date.year == today.year &&
            t.date.month == today.month &&
            t.date.day == today.day)
        .toList();

    // Calculate totals by payment method
    final methodTotals = <String, double>{};
    for (var transaction in todayTransactions) {
      methodTotals.update(
        transaction.paymentMethod,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    // Calculate top selling items
    final itemCounts = <String, int>{};
    for (var transaction in todayTransactions) {
      for (var itemId in transaction.items) {
        itemCounts.update(itemId, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    final topItems = itemCounts.entries
        .map((e) => TopSellingItem(id: e.key, quantity: e.value))
        .toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    return DailyReport(
      date: today,
      totalSales: todayTransactions.fold(0, (sum, item) => sum + item.amount),
      transactionCount: todayTransactions.length,
      paymentMethodTotals: methodTotals,
      topSellingItems: topItems.take(5).toList(),
    );
  }
}

class TopSellingItem {
  final String id;
  final int quantity;

  TopSellingItem({required this.id, required this.quantity});
}
