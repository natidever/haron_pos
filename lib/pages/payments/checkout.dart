import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/bloc/cart/cart_bloc.dart';
import 'package:haron_pos/bloc/theme/theme_bloc.dart';
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

  Widget _buildPaymentButton(CartState state, ThemeData theme) {
    return ElevatedButton(
      onPressed: state.selectedPaymentMethod.isEmpty
          ? null
          : () => _processPayment(state),
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        disabledBackgroundColor: theme.disabledColor,
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
          color: state.selectedPaymentMethod.isEmpty
              ? theme.colorScheme.onSurface.withOpacity(0.38)
              : theme.colorScheme.onPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final theme = Theme.of(context);

        return BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return Scaffold(
                backgroundColor: theme.scaffoldBackgroundColor,
                body: Center(
                  child: Text(
                    'Your cart is empty',
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
              );
            }

            return Scaffold(
              backgroundColor: theme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Checkout',
                  style: GoogleFonts.poppins(
                    color: theme.colorScheme.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CartSummary(
                      items: state.items,
                      total: state.total,
                      theme: theme,
                    ),
                    const SizedBox(height: 16),
                    // Payment Methods
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor,
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
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: theme.dividerColor,
                          ),
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
                              theme: theme,
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
                  color: theme.cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor,
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: _buildPaymentButton(state, theme),
                ),
              ),
            );
          },
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
  final ThemeData theme;

  const _PaymentOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected ? theme.primaryColor.withOpacity(0.05) : null,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.primaryColor.withOpacity(0.1)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? theme.primaryColor
                    : theme.colorScheme.onBackground.withOpacity(0.6),
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
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
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
              activeColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
