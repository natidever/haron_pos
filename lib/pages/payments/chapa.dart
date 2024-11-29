import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/pages/products/products.dart';
import 'package:logger/logger.dart';
import '../../models/cart_item.dart';
import '../../utils/logger.dart';

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

            // Show success dialog
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success Icon with Animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 600),
                          tween: Tween(begin: 0, end: 1),
                          builder: (context, value, child) {
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

                        // Success Message
                        Text(
                          'Payment Successful!',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Your transaction has been completed',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Continue Button
                        ElevatedButton(
                          onPressed: () {
                            // Close dialog and navigate
                            Navigator.of(context).pop();
                            onSuccess();

                            // Navigate to products page
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const ProductsPage(),
                              ),
                              (route) => false, // Remove all previous routes
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Continue Shopping',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
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
