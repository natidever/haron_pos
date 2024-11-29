import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:intl/intl.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  late TransactionDataSource _transactionDataSource;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy hh:mm a');
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _transactionDataSource = TransactionDataSource(transactions: transactions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey),
                        border: InputBorder.none,
                        icon: const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Filter Button
                PopupMenuButton<String>(
                  onSelected: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.grey),
                  ),
                  itemBuilder: (context) => [
                    'All',
                    'Today',
                    'This Week',
                    'This Month',
                  ]
                      .map((filter) => PopupMenuItem(
                            value: filter,
                            child: Text(filter),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),

          // Transaction Table
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: Colors.grey[50],
                  gridLineColor: Colors.grey[200]!,
                  gridLineStrokeWidth: 1,
                ),
                child: SfDataGrid(
                  source: _transactionDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  rowHeight: 70,
                  columns: [
                    GridColumn(
                      columnName: 'date',
                      width: 150,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Date & Time',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'transactionId',
                      width: 140,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.tag, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Transaction ID',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'amount',
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.attach_money,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Amount',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GridColumn(
                      columnName: 'status',
                      width: 120,
                      label: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.info_outline,
                                size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Status',
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionDataSource extends DataGridSource {
  TransactionDataSource({required List<TransactionData> transactions}) {
    dataGridRows = transactions
        .map<DataGridRow>((transaction) => DataGridRow(cells: [
              DataGridCell<String>(
                columnName: 'date',
                value:
                    DateFormat('MMM dd, yyyy hh:mm a').format(transaction.date),
              ),
              DataGridCell<String>(
                columnName: 'transactionId',
                value: transaction.transactionId,
              ),
              DataGridCell<double>(
                columnName: 'amount',
                value: transaction.amount,
              ),
              DataGridCell<String>(
                columnName: 'status',
                value: transaction.status,
              ),
            ]))
        .toList();
  }

  List<DataGridRow> dataGridRows = [];

  @override
  List<DataGridRow> get rows => dataGridRows;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        Color? textColor;
        if (cell.columnName == 'status') {
          textColor = cell.value == 'Completed'
              ? Colors.green
              : cell.value == 'Pending'
                  ? Colors.orange
                  : Colors.red;
        }
        if (cell.columnName == 'amount') {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.center,
            child: Text(
              '\$${cell.value.toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          alignment: Alignment.center,
          child: Text(
            cell.value.toString(),
            style: GoogleFonts.poppins(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }
}

class TransactionData {
  final DateTime date;
  final String transactionId;
  final double amount;
  final String status;

  TransactionData({
    required this.date,
    required this.transactionId,
    required this.amount,
    required this.status,
  });
}

// Sample data
final List<TransactionData> transactions = [
  TransactionData(
    date: DateTime.now(),
    transactionId: 'TRX-001',
    amount: 150.00,
    status: 'Completed',
  ),
  // Add more sample transactions
];
