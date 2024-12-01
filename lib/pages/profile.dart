import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haron_pos/constants/colors.dart';
import 'package:haron_pos/setting.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:haron_pos/models/transaction_model.dart';
import 'package:haron_pos/reports/widgets/custom_text.dart';
// import 'package:haron_pos/pages/settings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Box userBox;
  late Box<TransactionModel> transactionBox;
  String userEmail = '';
  int totalTransactions = 0;
  double totalSales = 0.0;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    userBox = await Hive.openBox('userBox');
    transactionBox = await Hive.openBox<TransactionModel>('transactions');

    // Add listener for real-time updates
    transactionBox.listenable().addListener(_updateTransactionStats);

    _updateTransactionStats();
  }

  void _updateTransactionStats() {
    if (!mounted) return;

    setState(() {
      userEmail = userBox.get('userEmail', defaultValue: 'No email set');
      totalTransactions = transactionBox.length;

      // Calculate total sales from all transactions
      totalSales = transactionBox.values.fold(0.0, (sum, transaction) {
        // Ensure we're handling null values properly
        if (transaction.amount != null) {
          return sum + transaction.amount!;
        }
        return sum;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use ValueListenableBuilder to rebuild only when transaction data changes
    return ValueListenableBuilder(
      valueListenable: Hive.box<TransactionModel>('transactions').listenable(),
      builder: (context, Box<TransactionModel> box, _) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          userEmail,
                          style: GoogleFonts.lexend(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildStatCard(
                          'Total Transactions',
                          box.length.toString(),
                          Icons.receipt_long,
                        ),
                        const SizedBox(height: 15),
                        _buildStatCard(
                          'Total Sales',
                          '\$${_calculateTotalSales(box).toStringAsFixed(2)}',
                          Icons.attach_money,
                        ),
                        const SizedBox(height: 20),
                        _buildActionButton(
                          'Generate Report',
                          Icons.assessment,
                          () {
                            // Implement report generation
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildActionButton(
                          'Settings',
                          Icons.settings,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SettingsPage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildActionButton(
                          'Logout',
                          Icons.logout,
                          () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          color: Colors.red[400],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  double _calculateTotalSales(Box<TransactionModel> box) {
    return box.values.fold(0.0, (sum, transaction) {
      if (transaction.amount != null) {
        return sum + transaction.amount!;
      }
      return sum;
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, VoidCallback onTap,
      {Color? color}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: color ?? primaryColor),
              const SizedBox(width: 15),
              Text(
                title,
                style: GoogleFonts.lexend(
                  fontSize: 16,
                  color: color ?? Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
