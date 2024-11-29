import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/cart/cart_bloc.dart';
import 'package:haron_pos/models/product_model.dart';
import 'package:haron_pos/utils/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import 'package:haron_pos/widgets/cart_summary.dart';
import 'package:haron_pos/pages/payments/chapa.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool hasTimedOut = false;
  bool isProcessing = false;

  final paymentMethods = [
    ('Credit Card', 'Pay with credit or debit card', Icons.credit_card),
    ('Cash', 'Pay with cash on delivery', Icons.money),
    ('Bank Transfer', 'Pay via bank transfer', Icons.account_balance),
  ];

  Future<void> _processPayment(CartState state) async {
    if (isProcessing) return;

    try {
      setState(() {
        isProcessing = true;
        hasTimedOut = false;
      });

      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) => WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );

      // Remove the timeout since Chapa handles its own loading
      await ChapaService.initializePayment(
        context: context,
        items: state.items,
        total: state.total,
        paymentMethod: state.selectedPaymentMethod,
        onSuccess: () {
          if (mounted) {
            setState(() {
              isProcessing = false;
            });

            // Dismiss loading dialog only if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            context.read<CartBloc>().add(ClearCartEvent());

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment successful!',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.of(context).popUntil((route) => route.isFirst);
          }
        },
        onError: (error) {
          logger.e('Payment failed: $error');
          if (mounted) {
            setState(() {
              isProcessing = false;
            });

            // Dismiss loading dialog only if it's showing
            if (Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Something went wrong. Please try again.',
                  style: GoogleFonts.poppins(),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e, stack) {
      logger.e('Error processing payment', error: e, stackTrace: stack);
      if (mounted) {
        setState(() {
          isProcessing = false;
        });

        // Dismiss loading dialog only if it's showing
        if (Navigator.canPop(context)) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong. Please try again.',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildPaymentButton(CartState state) {
    return ElevatedButton(
      onPressed: state.selectedPaymentMethod.isEmpty
          ? null
          : () => _processPayment(state),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        'Pay \$${state.total.toStringAsFixed(2)}',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state.items.isEmpty) {
          return Scaffold(
              body: const Center(child: Text('Your cart is empty')));
        }

        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            title: Text(
              'Checkout',
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CartSummary(
                  items: state.items,
                  total: state.total,
                ),
                const SizedBox(height: 16),
                // Payment Methods
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Payment Method',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      ...paymentMethods.map((method) {
                        final (title, subtitle, icon) = method;
                        return _PaymentOption(
                          title: title,
                          subtitle: subtitle,
                          icon: icon,
                          isSelected: state.selectedPaymentMethod == title,
                          onTap: () {
                            context
                                .read<CartBloc>()
                                .add(SelectPaymentMethodEvent(title));
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: _buildPaymentButton(state),
            ),
          ),
        );
      },
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected ? Colors.blue.withOpacity(0.05) : null,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).primaryColor.withOpacity(0.1)
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Radio(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
