import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:haron_pos/models/cart_item.dart';
import 'package:haron_pos/utils/logger.dart';

class ChapaService {
  static const String _testKey =
      "CHASECK_TEST-HlZh7Xo8vNvT2jm6j08OzcnFnB63Yauf";

  static Future<void> initializePayment({
    required BuildContext context,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      logger.i('Initializing Chapa payment');

      // Generate a unique transaction reference
      final txRef = DateTime.now().millisecondsSinceEpoch.toString();

      // Create order description from cart items
      final description = items
          .map((item) => "${item.product.name} x${item.quantity}")
          .join(", ");

      logger.d('Transaction Reference: $txRef');
      logger.d('Order Description: $description');

      final paymentUrl = await Chapa.getInstance.startPayment(
        context: context,
        onInAppPaymentSuccess: (successMsg) {
          logger.i('Payment successful: $successMsg');
          onSuccess();
        },
        onInAppPaymentError: (errorMsg) {
          logger.e('Payment error: $errorMsg');
          onError(errorMsg);
        },
        amount: total.toString(),
        currency: 'ETB',
        txRef: txRef,
        description: description,
        title: 'Order Payment',
      );

      if (paymentUrl == null) {
        throw Exception('Failed to initialize payment');
      }

      logger.i('Payment URL generated: $paymentUrl');
    } catch (e, stackTrace) {
      logger.e('Error initializing payment', error: e, stackTrace: stackTrace);
      onError(e.toString());
    }
  }
}
