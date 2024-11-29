import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../utils/logger.dart';

class ChapaService {
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
