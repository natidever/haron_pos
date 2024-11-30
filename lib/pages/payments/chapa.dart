import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/transactions/bloc/transaction_bloc_bloc.dart';
import 'package:haron_pos/pages/products/products.dart';
import 'package:haron_pos/pages/transaction/transaction.dart';
import 'package:logger/logger.dart';
import '../../models/cart_item.dart';
import '../../utils/logger.dart';
import '../../models/transaction_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapaService {
  static var logger = Logger();
  static Future<void> initializePayment({
    required BuildContext context,
    required List<CartItem> items,
    required double total,
    required String paymentMethod,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    try {
      logger.i('Starting Chapa payment process');

      try {
        String? paymentUrl = await Chapa.getInstance.startPayment(
          enableInAppPayment: true,
          amount: total.toString(),
          currency: 'ETB',
          context: context,
          onInAppPaymentSuccess: (successMsg) {
            logger.i('Payment Success: $successMsg');

            // Create and save transaction
            final transaction = TransactionModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              date: DateTime.now(),
              transactionId: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
              amount: total,
              status: 'Completed',
              items: items.map((item) => item.product.id).toList(),
              paymentMethod: paymentMethod,
            );

            // Add transaction to bloc
            context
                .read<TransactionBloc>()
                .add(AddTransactionEvent(transaction));

            // Navigate to transaction page
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductsPage(),
              ),
              (route) => false, // This removes all previous routes
            );
          },
          onInAppPaymentError: (errorMsg) {
            logger.e('Payment Error: $errorMsg');
            onError('Payment failed. Please try again.');
          },
        );

        logger.i('Payment URL generated: $paymentUrl');
      } on ChapaException catch (e) {
        logger.e('Chapa Error: ${e.toString()}');
        if (e is AuthException) {
          onError('Authentication failed');
        } else if (e is NetworkException) {
          onError('Network error. Please check your connection');
        } else if (e is ServerException) {
          onError('Server error. Please try again');
        } else {
          onError('Payment failed. Please try again');
        }
      }
    } catch (e, stack) {
      logger.e('General Error', error: e, stackTrace: stack);
      onError('Payment initialization failed');
    }
  }

  // Add verification method
  static Future<bool> verifyPayment(String txRef) async {
    try {
      logger.i('Verifying payment: $txRef');
      final result = await Chapa.getInstance.verifyPayment(txRef: txRef);
      logger.d('Verification result: $result');
      return result['status'] == 'success';
    } catch (e, stack) {
      logger.e('Verification Error', error: e, stackTrace: stack);
      return false;
    }
  }
}
